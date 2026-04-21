#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <julia.h>
#include "MetaModelicaJuliaLayer.h"

jl_function_t* omc_jl_some = NULL;
jl_function_t* omc_jl_cons = NULL;
jl_function_t* omc_jl_cons_typed = NULL;
jl_function_t* omc_jl_sourceinfo = NULL;
jl_function_t* omc_jl_listEmpty = NULL;
jl_function_t* omc_jl_listReverse = NULL;
jl_function_t* omc_jl_tuple2 = NULL;
jl_function_t* omc_jl_isDerCref = NULL;
jl_value_t* omc_jl_nil = NULL;

void OpenModelica_initMetaModelicaJuliaLayer()
{
  // Skip if already initialized
  if (omc_jl_some != NULL) return;

  // Use Base.require instead of 'using' to avoid creating globals in Main.
  // This is required for Julia 1.12+ precompilation compatibility.
  jl_module_t *MetaModelicaModule = (jl_module_t*)jl_eval_string(
    "Base.require(Base.PkgId(Base.UUID(\"9d7f2a79-07b5-5542-8b19-c0100dda6b06\"), \"MetaModelica\"))");
  jl_module_t *ImmutableList = (jl_module_t*)jl_eval_string(
    "Base.require(Base.PkgId(Base.UUID(\"4a558cac-c1ed-11e9-20da-3584bcd8709a\"), \"ImmutableList\"))");
  jl_module_t *ListDefModule = (jl_module_t*)jl_get_global(ImmutableList, jl_symbol("ListDef"));
  jl_module_t *parserModule = (jl_module_t*)jl_eval_string(
    "Base.require(Base.PkgId(Base.UUID(\"11f87224-cae7-4e99-a924-e50d12f62c59\"), \"OMParser\"))");

  if (!MetaModelicaModule)
  {
    fprintf(stderr, "module MetaModelica not loaded, load it via using.");
    fflush(NULL);
  }
  assert(jl_is_module(MetaModelicaModule));

  if (!ImmutableList)
  {
    fprintf(stderr, "module ImmutableList not loaded, load it via using.");
    fflush(NULL);
  }
  assert(jl_is_module(ImmutableList));

  if (!ListDefModule)
  {
    fprintf(stderr, "module ImmutableList.ListDef not loaded, load it via using.");
    fflush(NULL);
  }
  assert(jl_is_module(ListDefModule));

  if (!parserModule)
  {
    fprintf(stderr, "module OpenModelicaParser not loaded, load it via using.");
    fflush(NULL);
  }
  assert(jl_is_module(parserModule));

  assert((omc_jl_some = jl_get_function(MetaModelicaModule, "SOME")));
  assert((omc_jl_cons = jl_get_function(ListDefModule, "cons")));
  assert((omc_jl_cons_typed = jl_get_function(ListDefModule, "consExternalC")));
  assert((omc_jl_sourceinfo = jl_get_function(MetaModelicaModule, "SOURCEINFO")));
  assert((omc_jl_listReverse = jl_get_function(MetaModelicaModule, "listReverse")));
  assert((omc_jl_listEmpty = jl_get_function(MetaModelicaModule, "listEmpty")));
  assert((omc_jl_isDerCref = jl_get_function(parserModule, "isDerCref")));
  assert((omc_jl_tuple2 = jl_get_function(jl_base_module, "tuple")));
  assert((omc_jl_nil = jl_get_global(ListDefModule, jl_symbol("nil"))));
}

static const char* source_message_token(const char** ctokens, int nTokens, int tokenIndex)
{
  const char* token = "";

  if (ctokens != NULL && tokenIndex < nTokens) {
    if (ctokens[tokenIndex] != NULL) {
      token = ctokens[tokenIndex];
    }
  }

  return token;
}

static size_t formatted_source_message_length(const char* message, const char** ctokens, int nTokens)
{
  int tokenIndex = 0;
  size_t length = 0;

  for (size_t i = 0; message[i] != '\0'; ++i) {
    if (message[i] == '%' && message[i+1] != '\0') {
      if (message[i+1] == '%') {
        ++length;
        ++i;
        continue;
      }

      if (message[i+1] == 's') {
        length += strlen(source_message_token(ctokens, nTokens, tokenIndex));
        ++tokenIndex;
        ++i;
        continue;
      }
    }

    ++length;
  }

  return length;
}

static char* format_source_message(const char* message, const char** ctokens, int nTokens)
{
  char* formatted = NULL;
  int tokenIndex = 0;
  size_t writeIndex = 0;

  if (message == NULL) {
    return NULL;
  }

  formatted = malloc(formatted_source_message_length(message, ctokens, nTokens) + 1);
  if (formatted == NULL) {
    return NULL;
  }

  for (size_t i = 0; message[i] != '\0'; ++i) {
    const char* replacement = NULL;
    size_t replacementLength = 0;

    if (message[i] == '%' && message[i+1] != '\0') {
      if (message[i+1] == '%') {
        replacement = "%";
        replacementLength = 1;
        ++i;
      } else if (message[i+1] == 's') {
        replacement = source_message_token(ctokens, nTokens, tokenIndex);
        replacementLength = strlen(replacement);
        ++tokenIndex;
        ++i;
      }
    }

    if (replacement != NULL) {
      memcpy(formatted + writeIndex, replacement, replacementLength);
      writeIndex += replacementLength;
    } else {
      formatted[writeIndex++] = message[i];
    }
  }

  formatted[writeIndex] = '\0';
  return formatted;
}

static void set_last_error_message(const char* rendered_message, jl_value_t* filename, int startLine, int startCol, int endLine, int endCol)
{
  parser_members* members = pthread_getspecific(modelicaParserKey);
  int written = 0;
  size_t capacity = 0;
  char* updated = NULL;

  if (members == NULL || rendered_message == NULL) {
    return;
  }

  free(members->last_error_message);
  members->last_error_message = NULL;

  written = snprintf(NULL, 0, "%s:%d:%d-%d:%d: %s",
    jl_string_data(filename), startLine, startCol, endLine, endCol, rendered_message);
  if (written < 0) {
    return;
  }

  capacity = (size_t) written + 1;
  updated = (char*) malloc(capacity);
  if (updated == NULL) {
    return;
  }

  snprintf(updated, capacity, "%s:%d:%d-%d:%d: %s",
    jl_string_data(filename), startLine, startCol, endLine, endCol, rendered_message);
  members->last_error_message = updated;
}

OMPARSER_EXPORT const char* OMParser_lastErrorMessage(void)
{
  parser_members* members = pthread_getspecific(modelicaParserKey);

  if (members == NULL) {
    return NULL;
  }

  return members->last_error_message;
}

OMPARSER_EXPORT void OMParser_clearLastErrorMessage(void)
{
  parser_members* members = pthread_getspecific(modelicaParserKey);

  if (members == NULL) {
    return;
  }

  free(members->last_error_message);
  members->last_error_message = NULL;
}

void c_add_source_message(
       void *dummy,
       int errorID,
       ErrorType type,
       ErrorLevel severity,
       const char* message,
       const char** ctokens,
       int nTokens,
       int startLine,
       int startCol,
       int endLine,
       int endCol,
       int isReadOnly,
       jl_value_t* filename)
{
  char* formatted = format_source_message(message, ctokens, nTokens);
  const char* rendered = message;

  if (formatted != NULL) {
    rendered = formatted;
  }

  set_last_error_message(rendered, filename, startLine, startCol, endLine, endCol);
  fprintf(stderr, "%s:%d:%d-%d:%d: %s\n", jl_string_data(filename), startLine, startCol, endLine, endCol, rendered);
  free(formatted);
}


/*
jl_value_t* mmc_mk_some_or_none(jl_value_t *value) {
  JL_GC_PUSH1(&value); // make a root so GC can trac this one
  jl_value_t* result = value ? jl_call1(omc_jl_some, value) : jl_nothing;
  JL_GC_POP();
  return result;
}

jl_value_t* mmc_mk_scon(const char *str) {
  return jl_cstr_to_string(str);
}

jl_value_t* __mmc_mk_cons(jl_value_t* head, jl_value_t* tail) {
  JL_GC_PUSH2(&head, &tail);  
  jl_value_t *result = jl_call2(omc_jl_cons, head, tail);
  assert(result);
  JL_GC_POP();
  return result;
}

jl_value_t* mmc_mk_cons_typed(jl_value_t* T, jl_value_t* head, jl_value_t* tail) {
  JL_GC_PUSH3(&T, &head, &tail);
  jl_value_t *result = jl_call3(omc_jl_cons_typed, T, head, tail);
  assert(result);
  JL_GC_POP();
  return result;
}


#if !defined(JL_GC_PUSH9)
#define JL_GC_PUSH9(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)                      \
  void *__gc_stkf[] = {(void*)JL_GC_ENCODE_PUSH(9), jl_pgcstack, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9}; \
  jl_pgcstack = (jl_gcframe_t*)__gc_stkf;
#endif

jl_value_t* SourceInfo__SOURCEINFO(jl_value_t* fileName, int isReadOnly, int lineNumberStart, int columnNumberStart, int lineNumberEnd, int columnNumberEnd, double lastModification)
{
  jl_value_t* v1 = NULL, *v2 = NULL, *v3 = NULL, *v4 = NULL, *v5 = NULL, *v6 = NULL, *result = NULL, **vals = NULL;
  JL_GC_PUSH9(&filename, &v1, &v2, &v3, &v4, &v5, &v6, &result, vals);
  v1 = mmc_mk_bcon(isReadOnly);
  v2 = mmc_mk_icon(lineNumberStart);
  v3 = mmc_mk_icon(columnNumberStart);
  v4 = mmc_mk_icon(lineNumberEnd);
  v5 = mmc_mk_icon(columnNumberEnd);
  v6 = mmc_mk_rcon(lastModification);
  {
    JL_GC_PUSHARGS(vals, 7);
    vals[0] = fileName;
    vals[1] = v1;
    vals[2] = v2;
    vals[3] = v3;
    vals[4] = v4;
    vals[5] = v5;
    vals[6] = v6;   
    result = jl_call(omc_jl_sourceinfo, vals, 7);
    assert(result);
    JL_GC_POP();
  }
  JL_GC_POP();
  return result;
}

*/
