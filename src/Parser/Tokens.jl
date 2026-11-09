#=
This file is part of OpenModelica.
Copyright (c) 1998-2026, Open Source Modelica Consortium (OSMC),
c/o Linköpings universitet, Department of Computer and Information Science,
SE-58183 Linköping, Sweden.

All rights reserved.

THIS PROGRAM IS PROVIDED UNDER THE TERMS OF THE GPL VERSION 3 LICENSE OR
THE OSMC PUBLIC LICENSE (OSMC-PL) VERSION 1.2.
ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES
RECIPIENT'S ACCEPTANCE OF THE OSMC PUBLIC LICENSE OR THE GPL VERSION 3,
ACCORDING TO RECIPIENTS CHOICE.

The OpenModelica software and the OSMC (Open Source Modelica Consortium)
Public License (OSMC-PL) are obtained from OSMC, either from the above
address, from the URLs: http://www.openmodelica.org or
http://www.ida.liu.se/projects/OpenModelica, and in the OpenModelica
distribution. GNU version 3 is obtained from:
http://www.gnu.org/copyleft/gpl.html.

This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, EXCEPT AS
EXPRESSLY SET FORTH IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE
CONDITIONS OF OSMC-PL.
=#

"""
    TokenKind

The token kinds of the OpenModelica lexers (`BaseModelica_Lexer.g`, `Modelica_3_Lexer.g`,
`MetaModelica_Lexer.g`). Composite tokens (`TK_END_IF`, `TK_END_IDENT`, `TK_BEGIN_MODIFICATION`, ...)
are `end`/`begin` followed by whitespace and a word, as the ANTLR lexers produce them.
"""
@enum TokenKind::UInt8 begin
  TK_EOF
  TK_BOM
  TK_IDENT
  TK_UNSIGNED_INTEGER
  TK_UNSIGNED_REAL
  TK_STRING
  #= Keywords of both lexers =#
  TK_ALGORITHM
  TK_AND
  TK_ANNOTATION
  TK_BLOCK
  TK_CLASS
  TK_CONNECT
  TK_CONNECTOR
  TK_CONSTANT
  TK_DISCRETE
  TK_DER
  TK_DEFINEUNIT
  TK_EACH
  TK_ELSE
  TK_ELSEIF
  TK_ELSEWHEN
  TK_ENUMERATION
  TK_EQUATION
  TK_ENCAPSULATED
  TK_EXPANDABLE
  TK_EXTENDS
  TK_CONSTRAINEDBY
  TK_EXTERNAL
  TK_FALSE
  TK_FINAL
  TK_FLOW
  TK_FOR
  TK_FUNCTION
  TK_IF
  TK_IMPORT
  TK_IN
  TK_INITIAL
  TK_INNER
  TK_INPUT
  TK_LOOP
  TK_MODEL
  TK_MODE
  TK_NOT
  TK_OUTER
  TK_OPERATOR
  TK_OVERLOAD
  TK_OR
  TK_OUTPUT
  TK_PACKAGE
  TK_PARAMETER
  TK_PARTIAL
  TK_PROTECTED
  TK_PUBLIC
  TK_RECORD
  TK_REDECLARE
  TK_REPLACEABLE
  TK_THEN
  TK_TRUE
  TK_TYPE
  TK_WHEN
  TK_WHILE
  TK_WITHIN
  TK_RETURN
  TK_BREAK
  TK_STREAM
  TK_PURE
  TK_IMPURE
  TK_OPTIMIZATION
  TK_CONSTRAINT
  TK_FIELD
  TK_NONFIELD
  TK_INDOMAIN
  TK_CODE
  TK_CODE_NAME
  TK_CODE_EXP
  TK_CODE_ANNOTATION
  TK_CODE_VAR
  TK_RECONFIGURE
  TK_UPON
  TK_PROMPT
  TK_BEGIN_MODIFICATION
  TK_END_MODIFICATION
  TK_END_RECONFIGURE
  TK_END
  TK_END_IDENT
  TK_END_IF
  TK_END_FOR
  TK_END_WHEN
  TK_END_WHILE
  #= MetaModelica (and ParModelica, which only the MetaModelica lexer knows) =#
  TK_AS
  TK_CASE
  TK_CONTINUE
  TK_EQUALITY
  TK_FAILURE
  TK_GUARD
  TK_LOCAL
  TK_MATCH
  TK_MATCHCONTINUE
  TK_UNIONTYPE
  TK_ALLWILD
  TK_WILD
  TK_SUBTYPEOF
  TK_COLONCOLON
  TK_MOD
  TK_TRY
  TK_END_TRY
  TK_END_MATCH
  TK_END_MATCHCONTINUE
  TK_PARFOR
  TK_PARALLEL
  TK_PARLOCAL
  TK_PARGLOBAL
  TK_PARKERNEL
  TK_END_PARFOR
  TK_THREADED
  #= Operators and punctuation =#
  TK_DOT
  TK_LPAR
  TK_RPAR
  TK_LBRACK
  TK_RBRACK
  TK_LBRACE
  TK_RBRACE
  TK_EQUALS
  TK_ASSIGN
  TK_COMMA
  TK_COLON
  TK_SEMICOLON
  TK_PLUS
  TK_MINUS
  TK_STAR
  TK_SLASH
  TK_POWER
  TK_PLUS_EW
  TK_MINUS_EW
  TK_STAR_EW
  TK_SLASH_EW
  TK_POWER_EW
  TK_LESS
  TK_LESSEQ
  TK_LESSGT
  TK_GREATER
  TK_GREATEREQ
  TK_EQEQ
  TK_IMPLIES
end

"""
    tokenName(k::TokenKind)::String

How a token kind is shown in error messages: the keyword or operator as written, or a
description (`identifier`, `end of file`). Every kind has an entry in `TOKEN_NAMES` (tested).
"""
function tokenName(k::TokenKind)::String
  return TOKEN_NAMES[k]
end

"""
The spelling of every keyword and operator token, for error messages.
"""
const TOKEN_NAMES = Dict{TokenKind, String}(
  TK_EOF => "end of file", TK_BOM => "byte order mark", TK_IDENT => "identifier",
  TK_UNSIGNED_INTEGER => "integer literal", TK_UNSIGNED_REAL => "real literal", TK_STRING => "string literal",
  TK_ALGORITHM => "'algorithm'", TK_AND => "'and'", TK_ANNOTATION => "'annotation'", TK_BLOCK => "'block'",
  TK_CLASS => "'class'", TK_CONNECT => "'connect'", TK_CONNECTOR => "'connector'", TK_CONSTANT => "'constant'",
  TK_DISCRETE => "'discrete'", TK_DER => "'der'", TK_DEFINEUNIT => "'defineunit'", TK_EACH => "'each'",
  TK_ELSE => "'else'", TK_ELSEIF => "'elseif'", TK_ELSEWHEN => "'elsewhen'", TK_ENUMERATION => "'enumeration'",
  TK_EQUATION => "'equation'", TK_ENCAPSULATED => "'encapsulated'", TK_EXPANDABLE => "'expandable'",
  TK_EXTENDS => "'extends'", TK_CONSTRAINEDBY => "'constrainedby'", TK_EXTERNAL => "'external'",
  TK_FALSE => "'false'", TK_FINAL => "'final'", TK_FLOW => "'flow'", TK_FOR => "'for'", TK_FUNCTION => "'function'",
  TK_IF => "'if'", TK_IMPORT => "'import'", TK_IN => "'in'", TK_INITIAL => "'initial'", TK_INNER => "'inner'",
  TK_INPUT => "'input'", TK_LOOP => "'loop'", TK_MODEL => "'model'", TK_MODE => "'structuralmode'",
  TK_NOT => "'not'", TK_OUTER => "'outer'", TK_OPERATOR => "'operator'", TK_OVERLOAD => "'\$overload'",
  TK_OR => "'or'", TK_OUTPUT => "'output'", TK_PACKAGE => "'package'", TK_PARAMETER => "'parameter'",
  TK_PARTIAL => "'partial'", TK_PROTECTED => "'protected'", TK_PUBLIC => "'public'", TK_RECORD => "'record'",
  TK_REDECLARE => "'redeclare'", TK_REPLACEABLE => "'replaceable'", TK_THEN => "'then'", TK_TRUE => "'true'",
  TK_TYPE => "'type'", TK_WHEN => "'when'", TK_WHILE => "'while'", TK_WITHIN => "'within'",
  TK_RETURN => "'return'", TK_BREAK => "'break'", TK_STREAM => "'stream'", TK_PURE => "'pure'",
  TK_IMPURE => "'impure'", TK_OPTIMIZATION => "'optimization'", TK_CONSTRAINT => "'constraint'",
  TK_FIELD => "'field'", TK_NONFIELD => "'nonfield'", TK_INDOMAIN => "'indomain'", TK_CODE => "'\$Code'",
  TK_CODE_NAME => "'\$TypeName'", TK_CODE_EXP => "'\$Exp'", TK_CODE_ANNOTATION => "'\$annotation'",
  TK_CODE_VAR => "'\$Var'", TK_RECONFIGURE => "'reconfigure'", TK_UPON => "'upon'", TK_PROMPT => "'prompt'",
  TK_BEGIN_MODIFICATION => "'begin modification'", TK_END_MODIFICATION => "'end modification'",
  TK_END_RECONFIGURE => "'end reconfigure'", TK_END => "'end'", TK_END_IDENT => "'end <name>'",
  TK_END_IF => "'end if'", TK_END_FOR => "'end for'", TK_END_WHEN => "'end when'", TK_END_WHILE => "'end while'",
  TK_AS => "'as'", TK_CASE => "'case'", TK_CONTINUE => "'continue'", TK_EQUALITY => "'equality'",
  TK_FAILURE => "'failure'", TK_GUARD => "'guard'", TK_LOCAL => "'local'", TK_MATCH => "'match'",
  TK_MATCHCONTINUE => "'matchcontinue'", TK_UNIONTYPE => "'uniontype'", TK_ALLWILD => "'__'", TK_WILD => "'_'",
  TK_SUBTYPEOF => "'subtypeof'", TK_COLONCOLON => "'::'", TK_MOD => "'%'", TK_TRY => "'try'",
  TK_END_TRY => "'end try'", TK_END_MATCH => "'end match'", TK_END_MATCHCONTINUE => "'end matchcontinue'",
  TK_PARFOR => "'parfor'", TK_PARALLEL => "'parallel'", TK_PARLOCAL => "'parlocal'", TK_PARGLOBAL => "'parglobal'",
  TK_PARKERNEL => "'parkernel'", TK_END_PARFOR => "'end parfor'", TK_THREADED => "'threaded'",
  TK_DOT => "'.'", TK_LPAR => "'('", TK_RPAR => "')'", TK_LBRACK => "'['", TK_RBRACK => "']'", TK_LBRACE => "'{'",
  TK_RBRACE => "'}'", TK_EQUALS => "'='", TK_ASSIGN => "':='", TK_COMMA => "','", TK_COLON => "':'",
  TK_SEMICOLON => "';'", TK_PLUS => "'+'", TK_MINUS => "'-'", TK_STAR => "'*'", TK_SLASH => "'/'",
  TK_POWER => "'^'", TK_PLUS_EW => "'.+'", TK_MINUS_EW => "'.-'", TK_STAR_EW => "'.*'", TK_SLASH_EW => "'./'",
  TK_POWER_EW => "'.^'", TK_LESS => "'<'", TK_LESSEQ => "'<='", TK_LESSGT => "'<>'", TK_GREATER => "'>'",
  TK_GREATEREQ => "'>='", TK_EQEQ => "'=='", TK_IMPLIES => "'=>'",
)

"""
    packWord(s::String)::UInt128

The bytes of a keyword packed into an integer (first byte lowest), the key of the keyword tables.
Keywords are at most 16 bytes and contain no zero byte, so the packing is unique.
"""
function packWord(s::String)::UInt128
  local k::UInt128 = UInt128(0)
  local i::Int = 0
  for b::UInt8 in codeunits(s)
    k |= UInt128(b) << (8 * i)
    i += 1
  end
  return k
end

"""
Keywords of both lexers (`BaseModelica_Lexer.g`), `stream` and `impure` included. `end` is handled by
the lexer itself (composite tokens).
"""
const BASE_KEYWORDS = Dict{UInt128, TokenKind}(packWord(w) => k for (w, k) in (
  "algorithm" => TK_ALGORITHM, "and" => TK_AND, "annotation" => TK_ANNOTATION, "block" => TK_BLOCK,
  "class" => TK_CLASS, "connect" => TK_CONNECT, "connector" => TK_CONNECTOR, "constant" => TK_CONSTANT,
  "discrete" => TK_DISCRETE, "der" => TK_DER, "defineunit" => TK_DEFINEUNIT, "each" => TK_EACH,
  "else" => TK_ELSE, "elseif" => TK_ELSEIF, "elsewhen" => TK_ELSEWHEN, "enumeration" => TK_ENUMERATION,
  "equation" => TK_EQUATION, "encapsulated" => TK_ENCAPSULATED, "expandable" => TK_EXPANDABLE,
  "extends" => TK_EXTENDS, "constrainedby" => TK_CONSTRAINEDBY, "external" => TK_EXTERNAL, "false" => TK_FALSE,
  "final" => TK_FINAL, "flow" => TK_FLOW, "for" => TK_FOR, "function" => TK_FUNCTION, "if" => TK_IF,
  "import" => TK_IMPORT, "in" => TK_IN, "initial" => TK_INITIAL, "inner" => TK_INNER, "input" => TK_INPUT,
  "loop" => TK_LOOP, "model" => TK_MODEL, "structuralmode" => TK_MODE, "not" => TK_NOT, "outer" => TK_OUTER,
  "operator" => TK_OPERATOR, "\$overload" => TK_OVERLOAD, "or" => TK_OR, "output" => TK_OUTPUT,
  "package" => TK_PACKAGE, "parameter" => TK_PARAMETER, "partial" => TK_PARTIAL, "protected" => TK_PROTECTED,
  "public" => TK_PUBLIC, "record" => TK_RECORD, "redeclare" => TK_REDECLARE, "replaceable" => TK_REPLACEABLE,
  "then" => TK_THEN, "true" => TK_TRUE, "type" => TK_TYPE, "unsigned_real" => TK_UNSIGNED_REAL,
  "when" => TK_WHEN, "while" => TK_WHILE, "within" => TK_WITHIN, "return" => TK_RETURN, "break" => TK_BREAK,
  "stream" => TK_STREAM, "impure" => TK_IMPURE, "\$Code" => TK_CODE, "\$TypeName" => TK_CODE_NAME,
  "\$Exp" => TK_CODE_EXP, "\$annotation" => TK_CODE_ANNOTATION, "\$Var" => TK_CODE_VAR,
  "reconfigure" => TK_RECONFIGURE, "upon" => TK_UPON, "prompt" => TK_PROMPT,
))

"""
Keywords of the Modelica 3 lexer only (`Modelica_3_Lexer.g`): `pure` is an identifier in MetaModelica.
"""
const MODELICA_KEYWORDS = Dict{UInt128, TokenKind}(packWord("pure") => TK_PURE)

"""
Keywords of the MetaModelica lexer only (`MetaModelica_Lexer.g`), ParModelica's included.
"""
const METAMODELICA_KEYWORDS = Dict{UInt128, TokenKind}(packWord(w) => k for (w, k) in (
  "as" => TK_AS, "case" => TK_CASE, "continue" => TK_CONTINUE, "equality" => TK_EQUALITY,
  "failure" => TK_FAILURE, "guard" => TK_GUARD, "local" => TK_LOCAL, "match" => TK_MATCH,
  "matchcontinue" => TK_MATCHCONTINUE, "uniontype" => TK_UNIONTYPE, "__" => TK_ALLWILD, "_" => TK_WILD,
  "subtypeof" => TK_SUBTYPEOF, "try" => TK_TRY, "parfor" => TK_PARFOR, "parallel" => TK_PARALLEL,
  "parlocal" => TK_PARLOCAL, "parglobal" => TK_PARGLOBAL, "parkernel" => TK_PARKERNEL, "threaded" => TK_THREADED,
))

"""
Keywords that are identifiers unless their dialect is on: Optimica's and PDEModelica's.
"""
const OPTIMICA_KEYWORDS = Dict{UInt128, TokenKind}(packWord("optimization") => TK_OPTIMIZATION,
                                                   packWord("constraint") => TK_CONSTRAINT)
const PDEMODELICA_KEYWORDS = Dict{UInt128, TokenKind}(packWord("field") => TK_FIELD,
                                                      packWord("nonfield") => TK_NONFIELD,
                                                      packWord("indomain") => TK_INDOMAIN)

"""
Words after `end` and whitespace that form one token in both lexers (`end if`, `end for`, ...).
"""
const END_WORDS = Dict{UInt128, TokenKind}(packWord(w) => k for (w, k) in (
  "if" => TK_END_IF, "for" => TK_END_FOR, "when" => TK_END_WHEN, "while" => TK_END_WHILE,
  "reconfigure" => TK_END_RECONFIGURE, "modification" => TK_END_MODIFICATION,
))

"""
Words after `end` and whitespace that form one token in the MetaModelica lexer only.
"""
const METAMODELICA_END_WORDS = Dict{UInt128, TokenKind}(packWord(w) => k for (w, k) in (
  "try" => TK_END_TRY, "match" => TK_END_MATCH, "matchcontinue" => TK_END_MATCHCONTINUE,
  "parfor" => TK_END_PARFOR,
))
