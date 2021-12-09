#if !defined(__METAMODELICA_JULIA_LAYER__H)
#define __METAMODELICA_JULIA_LAYER__H

#include <julia.h>

#define jl_debug_println(X) jl_call1(jl_get_function(jl_base_module, "show"), (X));

#define omc_AbsynUtil_isDerCref(IGNORE, X) (X ? jl_call1(omc_jl_isDerCref, X) : jl_nothing)
#define mmc_mk_tuple2(x1,x2) (jl_call2(omc_jl_tuple2, x1, x2))

#define MMC_TRUE jl_true
#define MMC_FALSE jl_false
#define mmc_mk_bcon(X) X ? jl_true : jl_false
#define mmc_mk_icon(X) jl_box_int64(X)
#define mmc_mk_rcon(X) jl_box_float64(X)
#define mmc_mk_nil() omc_jl_nil
#define mmc_mk_none() jl_nothing
#define mmc_mk_some(X) jl_call1(omc_jl_some, X)
#define listReverseInPlace(X) jl_call1(omc_jl_listReverse, X)
#define listReverse(X) jl_call1(omc_jl_listReverse, X)
#define listEmpty(X) (jl_true == jl_call1(omc_jl_listEmpty, (X)))
#define optionNone(X) jl_is_nothing(X)

/* Note: These values may be garbage collected away? Call this before each file is parsed? */
void OpenModelica_initMetaModelicaJuliaLayer();

extern jl_function_t* omc_jl_some;
extern jl_function_t* omc_jl_cons;
extern jl_function_t* omc_jl_cons_typed;
extern jl_function_t* omc_jl_sourceinfo;
extern jl_function_t* omc_jl_listReverse;
extern jl_function_t* omc_jl_listEmpty;
extern jl_function_t* omc_jl_tuple2;
extern jl_function_t* omc_jl_isDerCref;
extern jl_value_t* omc_jl_nil;

/*
extern jl_value_t* mmc_mk_some_or_none(jl_value_t *value);
extern jl_value_t* mmc_mk_scon(const char *str);
extern jl_value_t* __mmc_mk_cons(jl_value_t* head, jl_value_t* tail);
extern jl_value_t* mmc_mk_cons_typed(jl_value_t* T, jl_value_t* head, jl_value_t* tail);
extern jl_value_t* SourceInfo__SOURCEINFO(jl_value_t* fileName, int isReadOnly, int lineNumberStart, int columnNumberStart, int lineNumberEnd, int columnNumberEnd, double lastModification);
*/

static inline jl_value_t* mmc_mk_some_or_none(jl_value_t *value) {
  JL_GC_PUSH1(&value); // make a root so GC can trac this one
  jl_value_t* result = value ? jl_call1(omc_jl_some, value) : jl_nothing;
  JL_GC_POP();
  return result;
}

static inline jl_value_t* mmc_mk_scon(const char *str) {
  return jl_cstr_to_string(str);
}

static inline jl_value_t* __mmc_mk_cons(jl_value_t* head, jl_value_t* tail) {
  JL_GC_PUSH2(&head, &tail);  
  jl_value_t *result = jl_call2(omc_jl_cons, head, tail);
  assert(result);
  JL_GC_POP();
  return result;
}

static inline jl_value_t* mmc_mk_cons_typed(jl_value_t* T, jl_value_t* head, jl_value_t* tail) {
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

static inline jl_value_t* SourceInfo__SOURCEINFO(jl_value_t* fileName, int isReadOnly, int lineNumberStart, int columnNumberStart, int lineNumberEnd, int columnNumberEnd, double lastModification)
{
  jl_value_t* v1 = NULL, *v2 = NULL, *v3 = NULL, *v4 = NULL, *v5 = NULL, *v6 = NULL, *result = NULL, **vals = NULL;
  JL_GC_PUSH9(&fileName, &v1, &v2, &v3, &v4, &v5, &v6, &result, vals);
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

enum enumErrorType {ErrorType_syntax=0,ErrorType_grammar,ErrorType_translation,ErrorType_symbolic,ErrorType_runtime,ErrorType_scripting};
enum enumErrorLevel {ErrorLevel_internal=0,ErrorLevel_error,ErrorLevel_warning,ErrorLevel_notification};
typedef enum enumErrorType ErrorType;
typedef enum enumErrorLevel ErrorLevel;

extern void c_add_source_message(
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
       jl_value_t* filename);

/* TODO: These should probably be some calls to Julia iconv functions? Or real iconv, who knows... */
#define SystemImpl__iconv(STR,FROM,TO,ERR) STR
#define SystemImpl__iconv__ascii(STR) STR

static inline jl_value_t* or_nil(jl_value_t *value) {
  return value ? value : mmc_mk_nil();
}

#endif
