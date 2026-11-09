#=
This file is part of OpenModelica.
Copyright (c) 1998-2026, Open Source Modelica Consortium (OSMC),
c/o Linköpings universitet, Department of Computer and Information Science,
SE-58183 Linköping, Sweden.

All rights reserved.

THIS PROGRAM IS PROVIDED UNDER THE TERMS OF THE BSD NEW LICENSE OR THE
GPL VERSION 3 LICENSE OR THE OSMC PUBLIC LICENSE (OSMC-PL) VERSION 1.2.
ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES
RECIPIENT'S ACCEPTANCE OF THE OSMC PUBLIC LICENSE OR THE GPL VERSION 3,
ACCORDING TO RECIPIENTS CHOICE.

The OpenModelica software and the OSMC (Open Source Modelica Consortium)
Public License (OSMC-PL) are obtained from OSMC, either from the above
address, from the URLs: http://www.openmodelica.org or
http://www.ida.liu.se/projects/OpenModelica, and in the OpenModelica
distribution. GNU version 3 is obtained from:
http://www.gnu.org/copyleft/gpl.html. The New BSD License is obtained from:
http://www.opensource.org/licenses/BSD-3-Clause.

This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, EXCEPT AS
EXPRESSLY SET FORTH IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE
CONDITIONS OF OSMC-PL.
=#

#=
The parser: one function per rule of omc's ANTLR grammar (`OMCompiler/Parser/Modelica.g` in the
OpenModelica repository), building the same Absyn values with the same calls as its actions (the
constructors, `SOME`, typed and untyped `cons`, `listReverse`), so the trees are identical,
SourceInfo and comment items included.
Recursive list rules are loops that cons from the end, which makes the same calls in the same
order.
=#

const NIL = ImmutableList.ListDef.nil
const consU = ImmutableList.ListDef.cons
const listRev = MetaModelica.listReverse
const SOME = MetaModelica.SOME

"""
The array constructor's function name when it has iterators (`{e for i in r}`).
"""
const ARRAY_REDUCTION_NAME = "\$array"

"""
    ParserState

The state of one parse: the tokens, the dialect, the position of the next token (`LT(1)` of
ANTLR) and the first comment not yet put into the tree (`omc_first_comment`).
"""
mutable struct ParserState
  const ts::Tokens
  const kinds::Vector{TokenKind}
  const dialect::Dialect
  const metaModelica::Bool
  const fileName::String
  const readOnly::Bool
  pos::Int
  firstComment::Int
end

function ParserState(ts::Tokens, dialect::Dialect, readOnly::Bool)
  return ParserState(ts, ts.kind, dialect, dialect.metaModelica, ts.fileName, readOnly, 1, 1)
end

"""
    AnnotationList

The annotation list a class body collects into (the `void **ann` argument of the list rules).
"""
mutable struct AnnotationList
  list::ImmutableList.List{Absyn.Annotation}
end

#= Tokens =#

@inline la(p::ParserState)::TokenKind = @inbounds p.kinds[p.pos]

@inline function la(p::ParserState, k::Int)::TokenKind
  local i::Int = p.pos + k - 1
  return i <= length(p.kinds) ? (@inbounds p.kinds[i]) : TK_EOF
end

"""
    advance!(p::ParserState)::Int

Consume the next token and return its index.
"""
@inline function advance!(p::ParserState)::Int
  local i::Int = p.pos
  if i < length(p.kinds)
    p.pos = i + 1
  end
  return i
end

"""
    expect!(p::ParserState, k::TokenKind, context::String = "")::Int

Consume the next token, which must be of kind `k`, and return its index.
"""
@inline function expect!(p::ParserState, k::TokenKind, context::String = "")::Int
  la(p) == k || expectedError(p, tokenName(k), context)
  return advance!(p)
end

"""
    accept!(p::ParserState, k::TokenKind)::Int

Consume the next token if it is of kind `k` and return its index, or return 0.
"""
@inline function accept!(p::ParserState, k::TokenKind)::Int
  la(p) == k || return 0
  return advance!(p)
end

@inline text(p::ParserState, i::Int)::String = tokenText(p.ts, i)

"""
    info(p::ParserState, startToken::Int)::MetaModelica.SourceInfo

`PARSER_INFO(start)`: from token `startToken` to the next token. Columns are ANTLR's character
positions plus one (plus two for a start on line 1), lines and columns of bytes.
"""
function info(p::ParserState, startToken::Int)::MetaModelica.SourceInfo
  local ts::Tokens = p.ts
  local line1::Int = Int(@inbounds ts.line[startToken])
  local col1::Int = Int(@inbounds ts.rawColumn[startToken]) + (line1 == 1 ? 2 : 1)
  local line2::Int = Int(@inbounds ts.line[p.pos])
  local col2::Int = Int(@inbounds ts.rawColumn[p.pos]) + 1
  return MetaModelica.SOURCEINFO(p.fileName, p.readOnly, line1, col1, line2, col2, 0.0)
end

#= Errors =#

"""
    describeToken(p::ParserState, i::Int)::String

Token `i` for an error message: `'model'`, `identifier 'x'`, `end of file`.
"""
function describeToken(p::ParserState, i::Int)::String
  local k::TokenKind = p.kinds[i]
  if k == TK_IDENT
    return "identifier '" * text(p, i) * "'"
  elseif k == TK_END_IDENT
    return "'end " * text(p, i) * "'"
  elseif k == TK_UNSIGNED_INTEGER || k == TK_UNSIGNED_REAL
    return "number " * text(p, i)
  elseif k == TK_STRING
    local s::String = text(p, i)
    return "string \"" * (length(s) > 30 ? first(s, 27) * "..." : s) * "\""
  end
  return tokenName(k)
end

"""
    errorAt(p::ParserState, i::Int, message::String)

Throw a `ParseError` at token `i`.
"""
function errorAt(p::ParserState, i::Int, message::String)
  local ts::Tokens = p.ts
  local pos::Int = Int(ts.start[i])
  local line::Int = Int(ts.line[i])
  local lineStart::Int = pos - Int(ts.rawColumn[i]) - (line == 1 ? 1 : 0)
  throw(ParseError(p.fileName, line, displayColumn(ts.source, lineStart, pos), message, sourceLineAt(ts.source, pos)))
end

"""
    expectedError(p::ParserState, expected::String, context::String = "")

Throw "Expected <expected> [<context>] but found <next token>" at the next token. When the next
token is on a later line than the end of the token before it (a `;` missing at the end of a
line), the error is right after that token and names the next token's line.
"""
function expectedError(p::ParserState, expected::String, context::String = "")
  local where_::String = isempty(context) ? "" : " " * context
  local message::String = "Expected " * expected * where_ * " but found " * describeToken(p, p.pos)
  local ts::Tokens = p.ts
  local prev::Int = p.pos - 1
  if prev >= 1
    local prevEnd::Int = Int(ts.textStop[prev]) + (p.kinds[prev] == TK_STRING ? 1 : 0)
    local cu::Base.CodeUnits{UInt8, String} = codeunits(ts.source)
    local prevEndLine::Int = Int(ts.line[prev]) + count(==(0x0a), view(cu, Int(ts.start[prev]):prevEnd))
    if Int(ts.line[p.pos]) > prevEndLine
      local pos::Int = prevEnd + 1
      local lineStart::Int = something(findprev(==(0x0a), cu, prevEnd), 0) + 1
      throw(ParseError(p.fileName, prevEndLine, displayColumn(ts.source, lineStart, pos),
                       message * " on line " * string(ts.line[p.pos]), sourceLineAt(ts.source, prevEnd)))
    end
  end
  errorAt(p, p.pos, message)
end

#= Comments: the comment tokens before the next token become comment items. =#

"""
    commentsBefore(p::ParserState)::Int

The number of comments before the next token.
"""
@inline function commentsBefore(p::ParserState)::Int
  return searchsortedlast(p.ts.commentNext, Int32(p.pos))
end

"""
    elementComments!(p::ParserState, ast::ImmutableList.List{Absyn.ElementItem})

`element_list`'s comment loop: cons the comments before the next token as `LEXER_COMMENT`s.
"""
function elementComments!(p::ParserState, ast::ImmutableList.List{Absyn.ElementItem})::ImmutableList.List{Absyn.ElementItem}
  local last::Int = commentsBefore(p)
  while p.firstComment <= last
    ast = consT(Absyn.ElementItem, Absyn.LEXER_COMMENT(commentText(p.ts, p.firstComment)), ast)
    p.firstComment += 1
  end
  return ast
end

"""
    equationComments!(p::ParserState, ast::ImmutableList.List{Absyn.EquationItem})

`equation_annotation_list`'s comment loop (`EQUATIONITEMCOMMENT`).
"""
function equationComments!(p::ParserState, ast::ImmutableList.List{Absyn.EquationItem})::ImmutableList.List{Absyn.EquationItem}
  local last::Int = commentsBefore(p)
  while p.firstComment <= last
    ast = consT(Absyn.EquationItem, Absyn.EQUATIONITEMCOMMENT(commentText(p.ts, p.firstComment)), ast)
    p.firstComment += 1
  end
  return ast
end

"""
    algorithmComments!(p::ParserState, ast::ImmutableList.List{Absyn.AlgorithmItem})

`algorithm_annotation_list`'s comment loop (`ALGORITHMITEMCOMMENT`).
"""
function algorithmComments!(p::ParserState, ast::ImmutableList.List{Absyn.AlgorithmItem})::ImmutableList.List{Absyn.AlgorithmItem}
  local last::Int = commentsBefore(p)
  while p.firstComment <= last
    ast = consT(Absyn.AlgorithmItem, Absyn.ALGORITHMITEMCOMMENT(commentText(p.ts, p.firstComment)), ast)
    p.firstComment += 1
  end
  return ast
end

#= Token classes (FIRST sets of the rules) =#

"""
    startsClassDefinition(k::TokenKind)::Bool

`class_definition` starts with `k`: `encapsulated`, `partial` or a class type.
"""
function startsClassDefinition(k::TokenKind)::Bool
  return k == TK_ENCAPSULATED || k == TK_PARTIAL || k == TK_CLASS || k == TK_OPTIMIZATION || k == TK_MODEL ||
         k == TK_RECORD || k == TK_BLOCK || k == TK_EXPANDABLE || k == TK_CONNECTOR || k == TK_TYPE ||
         k == TK_PACKAGE || k == TK_PURE || k == TK_IMPURE || k == TK_OPERATOR || k == TK_PARALLEL ||
         k == TK_PARKERNEL || k == TK_FUNCTION || k == TK_UNIONTYPE
end

"""
    startsComponentClause(k::TokenKind)::Bool

`component_clause` starts with `k`: a type prefix or a name.
"""
function startsComponentClause(k::TokenKind)::Bool
  return k == TK_FLOW || k == TK_STREAM || k == TK_MODE || k == TK_PARLOCAL || k == TK_PARGLOBAL ||
         k == TK_DISCRETE || k == TK_PARAMETER || k == TK_CONSTANT || k == TK_INPUT || k == TK_OUTPUT ||
         k == TK_FIELD || k == TK_NONFIELD || k == TK_DOT || k == TK_IDENT || k == TK_CODE
end

"""
    startsElement(k::TokenKind)::Bool

`element` starts with `k`.
"""
function startsElement(k::TokenKind)::Bool
  return k == TK_IMPORT || k == TK_EXTENDS || k == TK_DEFINEUNIT || k == TK_REDECLARE || k == TK_FINAL ||
         k == TK_INNER || k == TK_OUTER || k == TK_REPLACEABLE || k == TK_CONNECT || startsClassDefinition(k) ||
         startsComponentClause(k)
end

"""
    startsSimpleExpression(k::TokenKind)::Bool

`simple_expression` starts with `k`.
"""
function startsSimpleExpression(k::TokenKind)::Bool
  return k == TK_UNSIGNED_INTEGER || k == TK_UNSIGNED_REAL || k == TK_STRING || k == TK_FALSE || k == TK_TRUE ||
         k == TK_DOT || k == TK_IDENT || k == TK_OPERATOR || k == TK_ALLWILD || k == TK_WILD || k == TK_INITIAL ||
         k == TK_DER || k == TK_PURE || k == TK_LPAR || k == TK_LBRACK || k == TK_LBRACE || k == TK_END ||
         k == TK_PLUS || k == TK_MINUS || k == TK_PLUS_EW || k == TK_MINUS_EW || k == TK_NOT
end

"""
    startsEquation(k::TokenKind)::Bool

`equation` starts with `k`.
"""
function startsEquation(k::TokenKind)::Bool
  return startsSimpleExpression(k) || k == TK_IF || k == TK_FOR || k == TK_PARFOR || k == TK_CONNECT ||
         k == TK_WHEN || k == TK_RECONFIGURE || k == TK_FAILURE || k == TK_EQUALITY
end

"""
    startsAlgorithm(k::TokenKind)::Bool

`algorithm` starts with `k`.
"""
function startsAlgorithm(k::TokenKind)::Bool
  return startsSimpleExpression(k) || k == TK_IF || k == TK_FOR || k == TK_PARFOR || k == TK_WHILE ||
         k == TK_TRY || k == TK_WHEN || k == TK_BREAK || k == TK_RETURN || k == TK_CONTINUE ||
         k == TK_FAILURE || k == TK_EQUALITY
end

#= Helpers mirroring the C macros =#

@inline someOrNone(x::Nothing)::Nothing = nothing
@inline someOrNone(x::T) where {T} = SOME(x)

"""
    someOf(::Type{T}, x::Union{Nothing, T})::Union{Nothing, SOME{T}}

`SOME(x)` (or `nothing`) as a field of type `Option{T}` holds it: the constructors convert a
`SOME{S}` to `SOME{T}`. With the field's type the constructor call is resolved when compiled, also
when `T` is abstract.
"""
@inline someOf(::Type{T}, x::Union{Nothing, T}) where {T} = x === nothing ? nothing : SOME{T}(x)

"""
    consT(::Type{T}, head::T, tail::Union{ImmutableList.ListDef.Nil, ImmutableList.ListDef.Cons{T}})::ImmutableList.ListDef.Cons{T}

`consExternalC` of the C layer: a `Cons{T}`. Resolved when compiled, also when `T` is abstract
(`consExternalC`'s `X <: T` parameter is not).
"""
@inline consT(::Type{T}, head::T, tail::Union{ImmutableList.ListDef.Nil, ImmutableList.ListDef.Cons{T}}) where {T} =
  ImmutableList.ListDef.Cons{T}(head, tail)

@inline orNil(x::Nothing) = NIL
@inline orNil(x::T) where {T} = x

#= stored_definition, within =#

"""
    storedDefinition(p::ParserState)::Absyn.Program

`stored_definition`: `BOM? (within_clause ';')? class_definition_list? EOF`.
"""
function storedDefinition(p::ParserState)::Absyn.Program
  accept!(p, TK_BOM)
  local within_::Union{Nothing, Absyn.Within} = nothing
  if la(p) == TK_WITHIN
    within_ = withinClause(p)
    expect!(p, TK_SEMICOLON, "after the within clause")
  end
  local classes::Union{Nothing, ImmutableList.List{Absyn.Class}} = nothing
  local k::TokenKind = la(p)
  if k == TK_FINAL || startsClassDefinition(k)
    classes = classDefinitionList(p)
  end
  la(p) == TK_EOF || expectedError(p, "a class definition")
  return Absyn.PROGRAM(orNil(classes), within_ === nothing ? Absyn.TOP() : within_)
end

"""
    withinClause(p::ParserState)::Absyn.Within

`within_clause`: `within name_path?`.
"""
function withinClause(p::ParserState)::Absyn.Within
  expect!(p, TK_WITHIN)
  local k::TokenKind = la(p)
  if k == TK_DOT || k == TK_IDENT || k == TK_CODE
    return Absyn.WITHIN(namePath(p))
  end
  return Absyn.TOP()
end

"""
    classDefinitionList(p::ParserState)::ImmutableList.List{Absyn.Class}

`class_definition_list`: `(final? class_definition ';')+`.
"""
function classDefinitionList(p::ParserState)::ImmutableList.List{Absyn.Class}
  local classes::Vector{Absyn.Class} = Absyn.Class[]
  while true
    local isFinal::Bool = accept!(p, TK_FINAL) != 0
    startsClassDefinition(la(p)) || expectedError(p, "a class definition")
    push!(classes, classDefinition(p, isFinal))
    expect!(p, TK_SEMICOLON, "after the class definition")
    local k::TokenKind = la(p)
    (k == TK_FINAL || startsClassDefinition(k)) || break
  end
  local ast::ImmutableList.List{Absyn.Class} = NIL
  for i::Int in length(classes):-1:1
    ast = consT(Absyn.Class, classes[i], ast)
  end
  return ast
end

#= Classes =#

"""
    classDefinition(p::ParserState, isFinal::Bool)::Absyn.Class

`class_definition`: `encapsulated? partial? class_type class_specifier`.
"""
function classDefinition(p::ParserState, isFinal::Bool)::Absyn.Class
  local start::Int = p.pos
  local e::Bool = accept!(p, TK_ENCAPSULATED) != 0
  local partial::Bool = accept!(p, TK_PARTIAL) != 0
  local restriction::Absyn.Restriction = classType(p)
  local (spec::Absyn.ClassDef, name::String) = classSpecifier(p)
  return Absyn.CLASS(name, partial, isFinal, e, restriction, spec, info(p, start))
end

"""
    classType(p::ParserState)::Absyn.Restriction

`class_type`: the restriction keyword(s).
"""
function classType(p::ParserState)::Absyn.Restriction
  local k::TokenKind = la(p)
  if k == TK_CLASS
    advance!(p); return Absyn.R_CLASS()
  elseif k == TK_OPTIMIZATION
    advance!(p); return Absyn.R_OPTIMIZATION()
  elseif k == TK_MODEL
    advance!(p); return Absyn.R_MODEL()
  elseif k == TK_RECORD
    advance!(p); return Absyn.R_RECORD()
  elseif k == TK_BLOCK
    advance!(p); return Absyn.R_BLOCK()
  elseif k == TK_EXPANDABLE
    advance!(p); expect!(p, TK_CONNECTOR, "after 'expandable'"); return Absyn.R_EXP_CONNECTOR()
  elseif k == TK_CONNECTOR
    advance!(p); return Absyn.R_CONNECTOR()
  elseif k == TK_TYPE
    advance!(p); return Absyn.R_TYPE()
  elseif k == TK_PACKAGE
    advance!(p); return Absyn.R_PACKAGE()
  elseif k == TK_UNIONTYPE
    advance!(p); return Absyn.R_UNIONTYPE()
  elseif k == TK_OPERATOR && la(p, 2) != TK_FUNCTION
    advance!(p)
    return accept!(p, TK_RECORD) != 0 ? Absyn.R_OPERATOR_RECORD() : Absyn.R_OPERATOR()
  elseif k == TK_PURE || k == TK_IMPURE || k == TK_OPERATOR || k == TK_PARALLEL || k == TK_PARKERNEL || k == TK_FUNCTION
    local pur::Bool = accept!(p, TK_PURE) != 0
    local impur::Bool = !pur && accept!(p, TK_IMPURE) != 0
    local opr::Bool = accept!(p, TK_OPERATOR) != 0
    local prl::Bool = !opr && accept!(p, TK_PARALLEL) != 0
    local ker::Bool = !opr && !prl && accept!(p, TK_PARKERNEL) != 0
    expect!(p, TK_FUNCTION)
    return opr ? Absyn.R_FUNCTION(Absyn.FR_OPERATOR_FUNCTION()) :
           prl ? Absyn.R_FUNCTION(Absyn.FR_PARALLEL_FUNCTION()) :
           ker ? Absyn.R_FUNCTION(Absyn.FR_KERNEL_FUNCTION()) :
           pur ? Absyn.R_FUNCTION(Absyn.FR_NORMAL_FUNCTION(Absyn.PURE())) :
           impur ? Absyn.R_FUNCTION(Absyn.FR_NORMAL_FUNCTION(Absyn.IMPURE())) :
           Absyn.R_FUNCTION(Absyn.FR_NORMAL_FUNCTION(Absyn.NO_PURITY()))
  end
  expectedError(p, "a class type (model, block, function, ...)")
end

"""
    identifier(p::ParserState)::String

`identifier`: a class name (an identifier, or `der`, `\$Code`, `equality`, `initial`).
"""
function identifier(p::ParserState)::String
  local k::TokenKind = la(p)
  (k == TK_IDENT || k == TK_DER || k == TK_CODE || k == TK_EQUALITY || k == TK_INITIAL) ||
    expectedError(p, "a class name")
  return text(p, advance!(p))
end

"""
    classSpecifier(p::ParserState)::Tuple{Absyn.ClassDef, String}

`class_specifier`: the class name and its body, or `extends name ... end name`.
"""
function classSpecifier(p::ParserState)::Tuple{Absyn.ClassDef, String}
  local start::Int = p.pos
  if la(p) == TK_EXTENDS
    advance!(p)
    local s1::String = identifier(p)
    local mod::Union{Nothing, ImmutableList.List{Absyn.ElementArg}} = la(p) == TK_LPAR ? classModification(p) : nothing
    local cmt::Union{Nothing, String} = stringComment(p)
    local (parts::ImmutableList.List{Absyn.ClassPart}, ann::ImmutableList.List{Absyn.Annotation}) = composition(p)
    la(p) == TK_END_IDENT || expectedError(p, "'end " * s1 * "'")
    local endTok::Int = advance!(p)
    s1 == text(p, endTok) || errorAt(p, start, "The identifier at start and end are different: '" * s1 * "' and '" * text(p, endTok) * "'")
    return (Absyn.CLASS_EXTENDS(s1, orNil(mod), someOrNone(cmt), parts, listRev(ann)), s1)
  end
  local name::String = identifier(p)
  local (spec::Absyn.ClassDef, s2::Union{Nothing, String}) = classSpecifier2(p, name)
  if s2 !== nothing && s2 != name
    errorAt(p, start, "The identifier at start and end are different: '" * name * "' and '" * s2 * "'")
  end
  return (spec, name)
end

"""
    classSpecifier2(p::ParserState, name::String)::Tuple{Absyn.ClassDef, Union{Nothing, String}}

`class_specifier2`: the body after the class name (parts, a short class definition, an
enumeration, `der`, `\$overload`, `subtypeof`) and the name after `end`, if any.
"""
function classSpecifier2(p::ParserState, name::String)::Tuple{Absyn.ClassDef, Union{Nothing, String}}
  local start::Int = p.pos
  local k::TokenKind = la(p)
  if k == TK_EQUALS
    local k2::TokenKind = la(p, 2)
    advance!(p)
    if k2 == TK_ENUMERATION
      return (enumeration(p), nothing)
    elseif k2 == TK_DER
      return (pder(p), nothing)
    elseif k2 == TK_OVERLOAD
      return (overloading(p), nothing)
    end
    local attr::Absyn.ElementAttributes = basePrefix(p)
    local path::Absyn.TypeSpec = typeSpecifier(p)
    local cm::Union{Nothing, ImmutableList.List{Absyn.ElementArg}} = la(p) == TK_LPAR ? classModification(p) : nothing
    local cmt::Union{Nothing, Absyn.Comment} = comment(p)
    return (Absyn.DERIVED(path, attr, orNil(cm), someOrNone(cmt)), nothing)
  elseif k == TK_SUBTYPEOF
    advance!(p)
    local ts::Absyn.TypeSpec = typeSpecifier(p)
    return (Absyn.DERIVED(Absyn.TCOMPLEX(Absyn.IDENT("polymorphic"), consT(Absyn.TypeSpec, ts, NIL), NIL),
                          Absyn.ATTR(false, false, Absyn.NON_PARALLEL(), Absyn.VAR(), Absyn.BIDIR(), Absyn.NONFIELD(), NIL, false),
                          NIL, nothing), nothing)
  elseif k == TK_LPAR
    local lp::Int = advance!(p)
    local na::ImmutableList.List{Absyn.NamedArg} = namedArguments(p)
    expect!(p, TK_RPAR, "after the class attributes")
    local attrCmt::Union{Nothing, String} = stringComment(p)
    local (attrParts::ImmutableList.List{Absyn.ClassPart}, attrAnn::ImmutableList.List{Absyn.Annotation}) = composition(p)
    expect!(p, TK_END_IDENT, "at the end of class " * name)
    p.dialect.optimica || errorAt(p, start, "Class attributes are currently allowed only for Optimica. Use -g=Optimica.")
    return (Absyn.PARTS(NIL, na, attrParts, listRev(attrAnn), someOrNone(attrCmt)), nothing)
  end
  local ids::Union{Nothing, ImmutableList.List{String}} = nothing
  if k == TK_LESS
    advance!(p)
    ids = identList(p)
    expect!(p, TK_GREATER, "after the type variables")
  end
  local cmtStr::Union{Nothing, String} = stringComment(p)
  local (parts::ImmutableList.List{Absyn.ClassPart}, ann::ImmutableList.List{Absyn.Annotation}) = composition(p)
  la(p) == TK_END_IDENT || expectedError(p, "'end " * name * ";'", "at the end of class " * name)
  local s2::String = text(p, advance!(p))
  if ids !== nothing
    p.metaModelica || errorAt(p, start, "Polymorphic classes are only available in MetaModelica")
    return (Absyn.PARTS(ids, NIL, parts, listRev(ann), someOrNone(cmtStr)), s2)
  end
  return (Absyn.PARTS(NIL, NIL, parts, listRev(ann), someOrNone(cmtStr)), s2)
end

"""
    pder(p::ParserState)::Absyn.ClassDef

`pder`: `der(name, idents) comment`.
"""
function pder(p::ParserState)::Absyn.ClassDef
  expect!(p, TK_DER)
  expect!(p, TK_LPAR)
  local func::Absyn.Path = namePath(p)
  expect!(p, TK_COMMA)
  local vars::ImmutableList.List{String} = identList(p)
  expect!(p, TK_RPAR)
  local cmt::Union{Nothing, Absyn.Comment} = comment(p)
  return Absyn.PDER(func, vars, someOrNone(cmt))
end

"""
    identList(p::ParserState)::ImmutableList.List{String}

`ident_list`: `IDENT (',' IDENT)*` (an untyped cons list).
"""
function identList(p::ParserState)::ImmutableList.List{String}
  local names::Vector{String} = String[]
  push!(names, text(p, expect!(p, TK_IDENT)))
  while accept!(p, TK_COMMA) != 0
    push!(names, text(p, expect!(p, TK_IDENT)))
  end
  local ast::ImmutableList.List{String} = NIL
  for i::Int in length(names):-1:1
    ast = consU(names[i], ast)
  end
  return ast
end

"""
    overloading(p::ParserState)::Absyn.ClassDef

`overloading`: `\$overload(names) comment`.
"""
function overloading(p::ParserState)::Absyn.ClassDef
  expect!(p, TK_OVERLOAD)
  expect!(p, TK_LPAR)
  local nl::ImmutableList.List{Absyn.Path} = nameList(p)
  expect!(p, TK_RPAR)
  local cmt::Union{Nothing, Absyn.Comment} = comment(p)
  return Absyn.OVERLOAD(nl, someOrNone(cmt))
end

"""
    basePrefix(p::ParserState)::Absyn.ElementAttributes

`base_prefix`: the type prefix as an `ATTR` without dimensions.
"""
function basePrefix(p::ParserState)::Absyn.ElementAttributes
  local tp::TypePrefix = typePrefix(p)
  return Absyn.ATTR(tp.flow, tp.stream, tp.parallelism, tp.variability, tp.direction, tp.field, NIL, tp.isMode)
end

"""
    nameList(p::ParserState)::ImmutableList.List{Absyn.Path}

`name_list`: `name_path (',' name_path)*`.
"""
function nameList(p::ParserState)::ImmutableList.List{Absyn.Path}
  local names::Vector{Absyn.Path} = Absyn.Path[namePath(p)]
  while accept!(p, TK_COMMA) != 0
    push!(names, namePath(p))
  end
  local ast::ImmutableList.List{Absyn.Path} = NIL
  for i::Int in length(names):-1:1
    ast = consT(Absyn.Path, names[i], ast)
  end
  return ast
end

"""
    enumeration(p::ParserState)::Absyn.ClassDef

`enumeration`: `enumeration '(' (enum_list | ':') ')' comment`.
"""
function enumeration(p::ParserState)::Absyn.ClassDef
  expect!(p, TK_ENUMERATION)
  expect!(p, TK_LPAR, "after 'enumeration'")
  if accept!(p, TK_COLON) != 0
    expect!(p, TK_RPAR, "after 'enumeration(:'")
    local colonCmt::Union{Nothing, Absyn.Comment} = comment(p)
    return Absyn.ENUMERATION(Absyn.ENUM_COLON(), someOrNone(colonCmt))
  end
  local literals::Vector{Absyn.EnumLiteral} = Absyn.EnumLiteral[]
  while true
    local name::String = text(p, expect!(p, TK_IDENT, "(an enumeration literal)"))
    local c1::Union{Nothing, Absyn.Comment} = comment(p)
    push!(literals, Absyn.ENUMLITERAL(name, someOrNone(c1)))
    accept!(p, TK_COMMA) != 0 || break
  end
  expect!(p, TK_RPAR, "after the enumeration literals")
  local cmt::Union{Nothing, Absyn.Comment} = comment(p)
  local el::ImmutableList.List{Absyn.EnumLiteral} = NIL
  for i::Int in length(literals):-1:1
    el = consT(Absyn.EnumLiteral, literals[i], el)
  end
  return Absyn.ENUMERATION(Absyn.ENUMLITERALS(el), someOrNone(cmt))
end

"""
    composition(p::ParserState)::Tuple{ImmutableList.List{Absyn.ClassPart}, ImmutableList.List{Absyn.Annotation}}

`composition`: the public element list, the other sections, the external clause and the
annotation after it. Returns the class parts and the (not yet reversed) annotation list.
"""
function composition(p::ParserState)::Tuple{ImmutableList.List{Absyn.ClassPart}, ImmutableList.List{Absyn.Annotation}}
  local ann::AnnotationList = AnnotationList(NIL)
  local el::ImmutableList.List{Absyn.ElementItem} = elementList(p, ann)
  local els::ImmutableList.List{Absyn.ClassPart} = composition2(p, ann)
  local a::Union{Nothing, Absyn.Annotation} = nothing
  if la(p) == TK_ANNOTATION
    a = annotation(p)
    expect!(p, TK_SEMICOLON, "after the annotation")
  end
  local ast::ImmutableList.List{Absyn.ClassPart} = consT(Absyn.ClassPart, Absyn.PUBLIC(el), els)
  local annList::ImmutableList.List{Absyn.Annotation} = a === nothing ? ann.list : consT(Absyn.Annotation, a, ann.list)
  return (ast, annList)
end

"""
    composition2(p::ParserState, ann::AnnotationList)::ImmutableList.List{Absyn.ClassPart}

`composition2`: the sections (`public`, `protected`, `equation`, `algorithm`, their `initial`
forms, `constraint`) and the external clause.
"""
function composition2(p::ParserState, ann::AnnotationList)::ImmutableList.List{Absyn.ClassPart}
  local parts::Vector{Absyn.ClassPart} = Absyn.ClassPart[]
  local tail::ImmutableList.List{Absyn.ClassPart} = NIL
  while true
    local k::TokenKind = la(p)
    if k == TK_PUBLIC
      advance!(p)
      push!(parts, Absyn.PUBLIC(elementList(p, ann)))
    elseif k == TK_PROTECTED
      advance!(p)
      push!(parts, Absyn.PROTECTED(elementList(p, ann)))
    elseif k == TK_INITIAL && la(p, 2) == TK_EQUATION
      advance!(p); advance!(p)
      push!(parts, Absyn.INITIALEQUATIONS(equationAnnotationList(p, ann)))
    elseif k == TK_INITIAL && la(p, 2) == TK_ALGORITHM
      advance!(p); advance!(p)
      push!(parts, Absyn.INITIALALGORITHMS(algorithmAnnotationList(p, ann, false)))
    elseif k == TK_EQUATION
      advance!(p)
      push!(parts, Absyn.EQUATIONS(equationAnnotationList(p, ann)))
    elseif k == TK_CONSTRAINT
      advance!(p)
      push!(parts, Absyn.CONSTRAINTS(constraintAnnotationList(p, ann)))
    elseif k == TK_ALGORITHM
      advance!(p)
      push!(parts, Absyn.ALGORITHMS(algorithmAnnotationList(p, ann, false)))
    else
      if k == TK_EXTERNAL
        tail = externalClause(p)
      end
      break
    end
  end
  local ast::ImmutableList.List{Absyn.ClassPart} = tail
  for i::Int in length(parts):-1:1
    ast = consT(Absyn.ClassPart, parts[i], ast)
  end
  return ast
end

"""
    externalClause(p::ParserState)::ImmutableList.List{Absyn.ClassPart}

`external_clause`: `external language? ((cref '=')? IDENT '(' expressions? ')')? annotation? ';'`.
"""
function externalClause(p::ParserState)::ImmutableList.List{Absyn.ClassPart}
  expect!(p, TK_EXTERNAL)
  local lang::Union{Nothing, String} = nothing
  if la(p) == TK_STRING
    lang = text(p, advance!(p))
  end
  local retexp::Union{Nothing, Absyn.ComponentRef} = nothing
  local funcname::Union{Nothing, String} = nothing
  local expl::Union{Nothing, ImmutableList.List{Absyn.Exp}} = nothing
  local k::TokenKind = la(p)
  if k == TK_IDENT || k == TK_DOT || k == TK_OPERATOR || k == TK_WILD || k == TK_ALLWILD
    if !(k == TK_IDENT && la(p, 2) == TK_LPAR)
      retexp = componentReference(p)
      expect!(p, TK_EQUALS, "after the external output")
    end
    funcname = text(p, expect!(p, TK_IDENT, "(the external function name)"))
    expect!(p, TK_LPAR, "after the external function name")
    if la(p) != TK_RPAR
      expl = expressionList(p)
    end
    expect!(p, TK_RPAR, "after the external function arguments")
  end
  local ann1::Union{Nothing, Absyn.Annotation} = la(p) == TK_ANNOTATION ? annotation(p) : nothing
  expect!(p, TK_SEMICOLON, "after the external clause")
  local decl::Absyn.ExternalDecl = Absyn.EXTERNALDECL(someOf(String, funcname),
                                                      someOf(String, lang), someOf(Absyn.ComponentRef, retexp),
                                                      orNil(expl), someOf(Absyn.Annotation, ann1))
  return consT(Absyn.ClassPart, Absyn.EXTERNAL(decl, nothing), NIL)
end

"""
    elementList(p::ParserState, ann::Union{Nothing, AnnotationList})::ImmutableList.List{Absyn.ElementItem}

`element_list`: `((element | annotation) ';')*` with the comments as `LEXER_COMMENT` items.
Annotations go to `ann` (not allowed when it is `nothing`, the local declarations of a match).
"""
function elementList(p::ParserState, ann::Union{Nothing, AnnotationList})::ImmutableList.List{Absyn.ElementItem}
  local ast::ImmutableList.List{Absyn.ElementItem} = elementComments!(p, NIL)
  while true
    local k::TokenKind = la(p)
    if k == TK_ANNOTATION && ann !== nothing
      local a::Absyn.Annotation = annotation(p)
      ann.list = consT(Absyn.Annotation, a, ann.list)
    elseif startsElement(k)
      local e::Absyn.Element = element(p)
      ast = consT(Absyn.ElementItem, Absyn.ELEMENTITEM(e), ast)
    else
      break
    end
    expect!(p, TK_SEMICOLON, k == TK_ANNOTATION ? "after the annotation" : "after the element")
    ast = elementComments!(p, ast)
  end
  ast = listRev(ast)
  if ann !== nothing
    ann.list = listRev(ann.list)
  end
  return ast
end

"""
    element(p::ParserState)::Absyn.Element

`element`: an import, extends or defineunit clause, or a class definition or component clause
with its prefixes (`redeclare final inner outer replaceable`).
"""
function element(p::ParserState)::Absyn.Element
  local start::Int = p.pos
  local k::TokenKind = la(p)
  if k == TK_IMPORT
    local ic::Absyn.ElementSpec = importClause(p)
    return Absyn.ELEMENT(false, nothing, Absyn.NOT_INNER_OUTER(), ic, info(p, start), nothing)
  elseif k == TK_EXTENDS
    local ec::Absyn.ElementSpec = extendsClause(p)
    return Absyn.ELEMENT(false, nothing, Absyn.NOT_INNER_OUTER(), ec, info(p, start), nothing)
  elseif k == TK_DEFINEUNIT
    return defineunitClause(p)
  elseif k == TK_CONNECT
    errorAt(p, start, "Found the start of a connect equation but expected an element (are you missing the equation keyword?)")
  end
  local r::Bool = accept!(p, TK_REDECLARE) != 0
  local f::Bool = accept!(p, TK_FINAL) != 0
  local i::Bool = accept!(p, TK_INNER) != 0
  local o::Bool = accept!(p, TK_OUTER) != 0
  local innerouter::Absyn.InnerOuter = i && o ? Absyn.INNER_OUTER() : i ? Absyn.INNER() : o ? Absyn.OUTER() : Absyn.NOT_INNER_OUTER()
  if la(p) == TK_REPLACEABLE
    advance!(p)
    local spec::Absyn.ElementSpec = if startsClassDefinition(la(p))
      Absyn.CLASSDEF(true, classDefinition(p, f))
    else
      componentClause(p)
    end
    local constr::Union{Nothing, Absyn.ConstrainClass} = nothing
    if la(p) == TK_EXTENDS || la(p) == TK_CONSTRAINEDBY
      constr = constrainingClauseComment(p)
    end
    local replRedecl::Absyn.RedeclareKeywords = r ? Absyn.REDECLARE_REPLACEABLE() : Absyn.REPLACEABLE()
    return Absyn.ELEMENT(f, SOME(replRedecl), innerouter, spec, info(p, start), someOrNone(constr))
  end
  local redecl::Union{Nothing, SOME{Absyn.REDECLARE}} = r ? SOME(Absyn.REDECLARE()) : nothing
  if startsClassDefinition(la(p))
    local cdef::Absyn.Class = classDefinition(p, f)
    return Absyn.ELEMENT(f, redecl, innerouter, Absyn.CLASSDEF(false, cdef), info(p, start), nothing)
  end
  startsComponentClause(la(p)) || expectedError(p, "a component or class declaration")
  local cc::Absyn.ElementSpec = componentClause(p)
  return Absyn.ELEMENT(f, redecl, innerouter, cc, info(p, start), nothing)
end

"""
    importClause(p::ParserState)::Absyn.ElementSpec

`import_clause`: `import (IDENT '=' name | name | name.* | name.{...}) comment`.
"""
function importClause(p::ParserState)::Absyn.ElementSpec
  local im::Int = expect!(p, TK_IMPORT)
  local imp::Absyn.Import
  local k::TokenKind = la(p)
  if (k == TK_IDENT || k == TK_CODE) && la(p, 2) == TK_EQUALS
    local id::String = text(p, advance!(p))
    advance!(p)
    imp = Absyn.NAMED_IMPORT(id, namePath(p))
  else
    local (path::Absyn.Path, unqual::Bool, lst::Union{Nothing, ImmutableList.List{Absyn.GroupImport}}) = namePathStar(p)
    imp = lst !== nothing ? Absyn.GROUP_IMPORT(path, lst) : unqual ? Absyn.UNQUAL_IMPORT(path) : Absyn.QUAL_IMPORT(path)
  end
  local cmt::Union{Nothing, Absyn.Comment} = comment(p)
  return Absyn.IMPORT(imp, someOrNone(cmt), info(p, im))
end

"""
    defineunitClause(p::ParserState)::Absyn.Element

`defineunit_clause`: `defineunit IDENT ('(' named_arguments ')')?`.
"""
function defineunitClause(p::ParserState)::Absyn.Element
  expect!(p, TK_DEFINEUNIT)
  local id::Int = expect!(p, TK_IDENT, "after 'defineunit'")
  local na::Union{Nothing, ImmutableList.List{Absyn.NamedArg}} = nothing
  if accept!(p, TK_LPAR) != 0
    na = namedArguments(p)
    expect!(p, TK_RPAR)
  end
  return Absyn.DEFINEUNIT(text(p, id), orNil(na), info(p, id))
end

"""
    extendsClause(p::ParserState)::Absyn.ElementSpec

`extends_clause`: `extends name class_or_inheritance_modification? annotation?`.
"""
function extendsClause(p::ParserState)::Absyn.ElementSpec
  expect!(p, TK_EXTENDS)
  local path::Absyn.Path = namePath(p)
  local mod::Union{Nothing, ImmutableList.List{Absyn.ElementArg}} = la(p) == TK_LPAR ? classModification(p, true) : nothing
  local ann::Union{Nothing, Absyn.Annotation} = la(p) == TK_ANNOTATION ? annotation(p) : nothing
  return Absyn.EXTENDS(path, orNil(mod), someOrNone(ann))
end

"""
    constrainingClauseComment(p::ParserState)::Absyn.ConstrainClass

`constraining_clause_comment`: `(extends | constrainedby) name class_modification? comment`.
"""
function constrainingClauseComment(p::ParserState)::Absyn.ConstrainClass
  advance!(p)
  local np::Absyn.Path = namePath(p)
  local mod::Union{Nothing, ImmutableList.List{Absyn.ElementArg}} = la(p) == TK_LPAR ? classModification(p) : nothing
  local constr::Absyn.ElementSpec = Absyn.EXTENDS(np, orNil(mod), nothing)
  local cmt::Union{Nothing, Absyn.Comment} = comment(p)
  return Absyn.CONSTRAINCLASS(constr, someOrNone(cmt))
end

"""
    TypePrefix

The result of `type_prefix`.
"""
struct TypePrefix
  flow::Bool
  stream::Bool
  parallelism::Absyn.Parallelism
  variability::Absyn.Variability
  direction::Absyn.Direction
  field::Absyn.IsField
  isMode::Bool
end

"""
    typePrefix(p::ParserState)::TypePrefix

`type_prefix`: `(flow|stream)? structuralmode? (parlocal|parglobal)? (discrete|parameter|constant)?
input? output? (field|nonfield)?`.
"""
function typePrefix(p::ParserState)::TypePrefix
  local fl::Bool = accept!(p, TK_FLOW) != 0
  local st::Bool = !fl && accept!(p, TK_STREAM) != 0
  local mo::Bool = accept!(p, TK_MODE) != 0
  local srd::Bool = accept!(p, TK_PARLOCAL) != 0
  local glb::Bool = !srd && accept!(p, TK_PARGLOBAL) != 0
  local di::Bool = accept!(p, TK_DISCRETE) != 0
  local pa::Bool = !di && accept!(p, TK_PARAMETER) != 0
  local co::Bool = !di && !pa && accept!(p, TK_CONSTANT) != 0
  local inTok::Int = accept!(p, TK_INPUT)
  local outTok::Int = accept!(p, TK_OUTPUT)
  local fi::Bool = accept!(p, TK_FIELD) != 0
  local nofi::Bool = !fi && accept!(p, TK_NONFIELD) != 0
  local parallelism::Absyn.Parallelism = srd ? Absyn.PARLOCAL() : glb ? Absyn.PARGLOBAL() : Absyn.NON_PARALLEL()
  local variability::Absyn.Variability = di ? Absyn.DISCRETE() : pa ? Absyn.PARAM() : co ? Absyn.CONST() : Absyn.VAR()
  local direction::Absyn.Direction
  if inTok != 0 && outTok != 0
    p.metaModelica || errorAt(p, inTok, "Type prefix \"input output\" is not available in Modelica (use either input or output)")
    direction = Absyn.INPUT_OUTPUT()
  else
    direction = inTok != 0 ? Absyn.INPUT() : outTok != 0 ? Absyn.OUTPUT() : Absyn.BIDIR()
  end
  local field::Absyn.IsField = fi ? Absyn.FIELD() : Absyn.NONFIELD()
  return TypePrefix(fl, st, parallelism, variability, direction, field, mo)
end

"""
    TypeSpecifierParts

The parts of a `type_specifier`: the name, the type arguments (MetaModelica) and the dimensions.
"""
struct TypeSpecifierParts
  path::Absyn.Path
  typeArgs::Union{Nothing, ImmutableList.List{Absyn.TypeSpec}}
  dims::Union{Nothing, ImmutableList.List{Absyn.Subscript}}
end

"""
    typeSpecifierParts(p::ParserState)::TypeSpecifierParts

`type_specifier` without building the `TypeSpec`: `name ('<' type_specifier_list '>')? array_subscripts?`.
"""
function typeSpecifierParts(p::ParserState)::TypeSpecifierParts
  local start::Int = p.pos
  local np::Absyn.Path = namePath(p)
  local ts::Union{Nothing, ImmutableList.List{Absyn.TypeSpec}} = nothing
  if la(p) == TK_LESS
    advance!(p)
    local specs::Vector{Absyn.TypeSpec} = Absyn.TypeSpec[typeSpecifier(p)]
    while accept!(p, TK_COMMA) != 0
      push!(specs, typeSpecifier(p))
    end
    expect!(p, TK_GREATER, "after the type arguments")
    local lst::ImmutableList.List{Absyn.TypeSpec} = NIL
    for i::Int in length(specs):-1:1
      lst = consT(Absyn.TypeSpec, specs[i], lst)
    end
    ts = lst
  end
  local as::Union{Nothing, ImmutableList.List{Absyn.Subscript}} = la(p) == TK_LBRACK ? arraySubscripts(p) : nothing
  if ts !== nothing
    p.metaModelica || errorAt(p, start, "Algebraic data types are only available in MetaModelica")
  end
  return TypeSpecifierParts(np, ts, as)
end

"""
    typeSpecifier(p::ParserState)::Absyn.TypeSpec

`type_specifier`: `TPATH` or (MetaModelica) `TCOMPLEX`.
"""
function typeSpecifier(p::ParserState)::Absyn.TypeSpec
  local tsp::TypeSpecifierParts = typeSpecifierParts(p)
  local args::Union{Nothing, ImmutableList.List{Absyn.TypeSpec}} = tsp.typeArgs
  if args !== nothing
    return Absyn.TCOMPLEX(tsp.path, args, someOf(ImmutableList.List{Absyn.Subscript}, tsp.dims))
  end
  return Absyn.TPATH(tsp.path, someOf(ImmutableList.List{Absyn.Subscript}, tsp.dims))
end

"""
    componentClause(p::ParserState)::Absyn.ElementSpec

`component_clause`: `type_prefix type_specifier component_list`. The dimensions after the type
name move to the attributes (the type specifier keeps none).
"""
function componentClause(p::ParserState)::Absyn.ElementSpec
  local tp::TypePrefix = typePrefix(p)
  local tsp::TypeSpecifierParts = typeSpecifierParts(p)
  local clst::ImmutableList.List{Absyn.ComponentItem} = componentList(p)
  local args::Union{Nothing, ImmutableList.List{Absyn.TypeSpec}} = tsp.typeArgs
  local path::Absyn.TypeSpec = args !== nothing ? Absyn.TCOMPLEX(tsp.path, args, nothing) : Absyn.TPATH(tsp.path, nothing)
  local dims::Union{Nothing, ImmutableList.List{Absyn.Subscript}} = tsp.dims
  local arr::ImmutableList.List{Absyn.Subscript} = dims === nothing ? NIL : dims
  return Absyn.COMPONENTS(Absyn.ATTR(tp.flow, tp.stream, tp.parallelism, tp.variability, tp.direction, tp.field, arr, tp.isMode),
                          path, clst)
end

"""
    componentList(p::ParserState)::ImmutableList.List{Absyn.ComponentItem}

`component_list`: `component_declaration (',' component_declaration)*`.
"""
function componentList(p::ParserState)::ImmutableList.List{Absyn.ComponentItem}
  local items::Vector{Absyn.ComponentItem} = Absyn.ComponentItem[componentDeclaration(p)]
  while accept!(p, TK_COMMA) != 0
    push!(items, componentDeclaration(p))
  end
  local ast::ImmutableList.List{Absyn.ComponentItem} = NIL
  for i::Int in length(items):-1:1
    ast = consT(Absyn.ComponentItem, items[i], ast)
  end
  return ast
end

"""
    componentDeclaration(p::ParserState)::Absyn.ComponentItem

`component_declaration`: `declaration (if expression)? comment`.
"""
function componentDeclaration(p::ParserState)::Absyn.ComponentItem
  local decl::Absyn.Component = declaration(p)
  local cond::Union{Nothing, Absyn.Exp} = nothing
  if accept!(p, TK_IF) != 0
    cond = expression(p, p.metaModelica)
  end
  local cmt::Union{Nothing, Absyn.Comment} = comment(p)
  return Absyn.COMPONENTITEM(decl, someOf(Absyn.Exp, cond), someOf(Absyn.Comment, cmt))
end

"""
    declaration(p::ParserState)::Absyn.Component

`declaration`: `(IDENT | operator) array_subscripts? modification?`.
"""
function declaration(p::ParserState)::Absyn.Component
  local k::TokenKind = la(p)
  (k == TK_IDENT || k == TK_OPERATOR) || expectedError(p, "a component name")
  local id::String = text(p, advance!(p))
  local as::Union{Nothing, ImmutableList.List{Absyn.Subscript}} = la(p) == TK_LBRACK ? arraySubscripts(p) : nothing
  local mod::Union{Nothing, Absyn.Modification} = nothing
  k = la(p)
  if k == TK_LPAR || k == TK_EQUALS || k == TK_ASSIGN
    mod = modification(p)
  end
  return Absyn.COMPONENT(id, orNil(as), someOrNone(mod))
end

#= Modifications =#

"""
    modification(p::ParserState)::Absyn.Modification

`modification`: `class_modification ('=' expr)? | '=' expr | ':=' expr`, where `expr` may be
`break`.
"""
function modification(p::ParserState)::Absyn.Modification
  local cm::Union{Nothing, ImmutableList.List{Absyn.ElementArg}} = nothing
  local eq::Int = 0
  local e::Union{Nothing, Absyn.Exp} = nothing
  local k::TokenKind = la(p)
  if k == TK_LPAR
    cm = classModification(p)
    if la(p) == TK_EQUALS
      eq = advance!(p)
      e = modificationExpression(p)
    end
  elseif k == TK_EQUALS || k == TK_ASSIGN
    eq = advance!(p)
    e = modificationExpression(p)
  else
    expectedError(p, "a modification")
  end
  return Absyn.CLASSMOD(orNil(cm), e === nothing ? Absyn.NOMOD() : Absyn.EQMOD(e, info(p, eq)))
end

"""
    modificationExpression(p::ParserState)::Absyn.Exp

`modification_expression`: an expression or `break`.
"""
function modificationExpression(p::ParserState)::Absyn.Exp
  if accept!(p, TK_BREAK) != 0
    return Absyn.BREAK()
  end
  return expression(p, p.metaModelica)
end

"""
    classModification(p::ParserState, canHaveBreak::Bool = false)::ImmutableList.List{Absyn.ElementArg}

`class_modification` (and `class_or_inheritance_modification` when `canHaveBreak`):
`'(' argument_list? ')'`.
"""
function classModification(p::ParserState, canHaveBreak::Bool = false)::ImmutableList.List{Absyn.ElementArg}
  expect!(p, TK_LPAR)
  local ast::ImmutableList.List{Absyn.ElementArg} = NIL
  if la(p) != TK_RPAR
    ast = argumentList(p, canHaveBreak)
  end
  expect!(p, TK_RPAR, "at the end of the modification")
  return ast
end

"""
    argumentList(p::ParserState, canHaveBreak::Bool)::ImmutableList.List{Absyn.ElementArg}

`argument_list`: `(argument | inheritance_modification) (',' ...)*`.
"""
function argumentList(p::ParserState, canHaveBreak::Bool)::ImmutableList.List{Absyn.ElementArg}
  local args::Vector{Absyn.ElementArg} = Absyn.ElementArg[]
  while true
    if la(p) == TK_BREAK
      canHaveBreak || errorAt(p, p.pos, "'break' is only allowed in the modification of an extends clause")
      push!(args, inheritanceModification(p))
    else
      push!(args, argument(p))
    end
    accept!(p, TK_COMMA) != 0 || break
  end
  local ast::ImmutableList.List{Absyn.ElementArg} = NIL
  for i::Int in length(args):-1:1
    ast = consT(Absyn.ElementArg, args[i], ast)
  end
  return ast
end

"""
    inheritanceModification(p::ParserState)::Absyn.ElementArg

`inheritance_modification`: `break connect(a, b)` or `break IDENT` (stored as
`connect(break, IDENT)`).
"""
function inheritanceModification(p::ParserState)::Absyn.ElementArg
  local start::Int = expect!(p, TK_BREAK)
  if la(p) == TK_CONNECT
    local c::Absyn.Equation = connectClause(p)
    return Absyn.INHERITANCEBREAK(c, info(p, start))
  end
  local i::Int = expect!(p, TK_IDENT, "after 'break'")
  return Absyn.INHERITANCEBREAK(Absyn.EQ_CONNECT(Absyn.CREF_IDENT("break", NIL), Absyn.CREF_IDENT(text(p, i), NIL)),
                                info(p, start))
end

"""
    argument(p::ParserState)::Absyn.ElementArg

`argument`: `element_modification_or_replaceable | element_redeclaration`.
"""
function argument(p::ParserState)::Absyn.ElementArg
  if la(p) == TK_REDECLARE
    return elementRedeclaration(p)
  end
  local e::Bool = accept!(p, TK_EACH) != 0
  local f::Bool = accept!(p, TK_FINAL) != 0
  if la(p) == TK_REPLACEABLE
    return elementReplaceable(p, e, f, false)
  end
  return elementModification(p, e ? Absyn.EACH() : Absyn.NON_EACH(), f)
end

"""
    elementModification(p::ParserState, each::Absyn.Each, isFinal::Bool)::Absyn.ElementArg

`element_modification`: `name_path2 modification? string_comment` (`name[` is an error).
"""
function elementModification(p::ParserState, each::Absyn.Each, isFinal::Bool)::Absyn.ElementArg
  local start::Int = p.pos
  local k::TokenKind = la(p)
  (k == TK_IDENT || k == TK_CODE) || expectedError(p, "a name to modify")
  local path::Absyn.Path = namePath2(p)
  if la(p) == TK_LBRACK
    errorAt(p, p.pos, "Subscripting modifiers is not allowed. Apply the modification on the whole identifier using an array-expression or an each-modifier.")
  end
  local mod::Union{Nothing, Absyn.Modification} = nothing
  k = la(p)
  if k == TK_LPAR || k == TK_EQUALS || k == TK_ASSIGN
    mod = modification(p)
  end
  local cmt::Union{Nothing, String} = stringComment(p)
  return Absyn.MODIFICATION(isFinal, each, path, someOrNone(mod), someOrNone(cmt), info(p, start))
end

"""
    elementRedeclaration(p::ParserState)::Absyn.ElementArg

`element_redeclaration`: `redeclare each? final? (class_definition | component_clause1 |
element_replaceable)`.
"""
function elementRedeclaration(p::ParserState)::Absyn.ElementArg
  local start::Int = expect!(p, TK_REDECLARE)
  local e::Bool = accept!(p, TK_EACH) != 0
  local f::Bool = accept!(p, TK_FINAL) != 0
  if la(p) == TK_REPLACEABLE
    return elementReplaceable(p, e, f, true)
  end
  local spec::Absyn.ElementSpec = if startsClassDefinition(la(p))
    Absyn.CLASSDEF(false, classDefinition(p, f))
  else
    componentClause1(p)
  end
  return Absyn.REDECLARATION(f, Absyn.REDECLARE(), e ? Absyn.EACH() : Absyn.NON_EACH(), spec, nothing, info(p, start))
end

"""
    elementReplaceable(p::ParserState, each::Bool, isFinal::Bool, redeclare::Bool)::Absyn.ElementArg

`element_replaceable`: `replaceable (class_definition | component_clause1) constraining_clause_comment?`.
"""
function elementReplaceable(p::ParserState, each::Bool, isFinal::Bool, redeclare::Bool)::Absyn.ElementArg
  local start::Int = expect!(p, TK_REPLACEABLE)
  local spec::Absyn.ElementSpec = if startsClassDefinition(la(p))
    Absyn.CLASSDEF(true, classDefinition(p, isFinal))
  else
    componentClause1(p)
  end
  local constr::Union{Nothing, Absyn.ConstrainClass} = nothing
  if la(p) == TK_EXTENDS || la(p) == TK_CONSTRAINEDBY
    constr = constrainingClauseComment(p)
  end
  local redecl::Absyn.RedeclareKeywords = redeclare ? Absyn.REDECLARE_REPLACEABLE() : Absyn.REPLACEABLE()
  return Absyn.REDECLARATION(isFinal, redecl, each ? Absyn.EACH() : Absyn.NON_EACH(), spec, someOrNone(constr), info(p, start))
end

"""
    componentClause1(p::ParserState)::Absyn.ElementSpec

`component_clause1`: `base_prefix type_specifier component_declaration1` (the dimensions stay in
the type specifier).
"""
function componentClause1(p::ParserState)::Absyn.ElementSpec
  local attr::Absyn.ElementAttributes = basePrefix(p)
  local ts::Absyn.TypeSpec = typeSpecifier(p)
  local decl::Absyn.Component = declaration(p)
  local cmt::Union{Nothing, Absyn.Comment} = comment(p)
  local item::Absyn.ComponentItem = Absyn.COMPONENTITEM(decl, nothing, someOrNone(cmt))
  return Absyn.COMPONENTS(attr, ts, consT(Absyn.ComponentItem, item, NIL))
end

#= Equation and algorithm sections =#

"""
    equationAnnotationList(p::ParserState, ann::AnnotationList)::ImmutableList.List{Absyn.EquationItem}

`equation_annotation_list`: `((equation | annotation) ';')*` up to the next section, with the
comments as `EQUATIONITEMCOMMENT` items.
"""
function equationAnnotationList(p::ParserState, ann::AnnotationList)::ImmutableList.List{Absyn.EquationItem}
  local ast::ImmutableList.List{Absyn.EquationItem} = equationComments!(p, NIL)
  while true
    local k::TokenKind = la(p)
    if k == TK_END_IDENT || k == TK_CONSTRAINT || k == TK_EQUATION || k == TK_ALGORITHM || k == TK_INITIAL ||
       k == TK_PROTECTED || k == TK_PUBLIC
      break
    end
    if k == TK_ANNOTATION
      local ea::Absyn.Annotation = annotation(p)
      expect!(p, TK_SEMICOLON, "after the annotation")
      ann.list = consT(Absyn.Annotation, ea, ann.list)
    elseif startsEquation(k)
      local eq::Absyn.EquationItem = equation(p)
      expect!(p, TK_SEMICOLON, "after the equation")
      ast = consT(Absyn.EquationItem, eq, ast)
    else
      break
    end
    ast = equationComments!(p, ast)
  end
  ast = listRev(ast)
  ann.list = listRev(ann.list)
  return ast
end

"""
    constraintAnnotationList(p::ParserState, ann::AnnotationList)::ImmutableList.List{Absyn.Exp}

`constraint_annotation_list` (Optimica): `((constraint | annotation) ';')*`.
"""
function constraintAnnotationList(p::ParserState, ann::AnnotationList)::ImmutableList.List{Absyn.Exp}
  local items::Vector{Any} = Any[]
  while true
    local k::TokenKind = la(p)
    if k == TK_END_IDENT || k == TK_CONSTRAINT || k == TK_EQUATION || k == TK_ALGORITHM || k == TK_INITIAL ||
       k == TK_PROTECTED || k == TK_PUBLIC
      break
    end
    if k == TK_ANNOTATION
      local a::Absyn.Annotation = annotation(p)
      expect!(p, TK_SEMICOLON)
      ann.list = consT(Absyn.Annotation, a, ann.list)
      push!(items, a)
    else
      local c::Any = constraint(p)
      expect!(p, TK_SEMICOLON)
      push!(items, c)
    end
  end
  local ast::ImmutableList.List{Absyn.Exp} = NIL
  for i::Int in length(items):-1:1
    ast = consT(Absyn.Exp, items[i], ast)
  end
  return ast
end

"""
    algorithmAnnotationList(p::ParserState, ann::Union{Nothing, AnnotationList}, matchCase::Bool)::ImmutableList.List{Absyn.AlgorithmItem}

`algorithm_annotation_list`: `((algorithm | annotation) ';')*` up to the next section (`then`
in a match case), with the comments as `ALGORITHMITEMCOMMENT` items.
"""
function algorithmAnnotationList(p::ParserState, ann::Union{Nothing, AnnotationList}, matchCase::Bool)::ImmutableList.List{Absyn.AlgorithmItem}
  local start::Int = p.pos
  local ast::ImmutableList.List{Absyn.AlgorithmItem} = algorithmComments!(p, NIL)
  while true
    local k::TokenKind = la(p)
    if matchCase
      k == TK_THEN && break
    elseif k == TK_END_IDENT || k == TK_EQUATION || k == TK_ALGORITHM || k == TK_INITIAL || k == TK_PROTECTED ||
           k == TK_PUBLIC
      break
    end
    if k == TK_ANNOTATION
      local a::Absyn.Annotation = annotation(p)
      expect!(p, TK_SEMICOLON, "after the annotation")
      ann === nothing && errorAt(p, start, "Annotations are not allowed in an algorithm list.")
      ann.list = consT(Absyn.Annotation, a, ann.list)
    elseif startsAlgorithm(k)
      local al::Absyn.AlgorithmItem = algorithm(p)
      expect!(p, TK_SEMICOLON, "after the statement")
      ast = consT(Absyn.AlgorithmItem, al, ast)
    else
      break
    end
    ast = algorithmComments!(p, ast)
  end
  ast = listRev(ast)
  if ann !== nothing
    ann.list = listRev(ann.list)
  end
  return ast
end

"""
    equation(p::ParserState)::Absyn.EquationItem

`equation`: one equation and its comment.
"""
function equation(p::ParserState)::Absyn.EquationItem
  local start::Int = p.pos
  local k::TokenKind = la(p)
  local e::Absyn.Equation
  if k == TK_IF
    e = conditionalEquationE(p)
  elseif k == TK_FOR
    e = forClauseE(p)
  elseif k == TK_PARFOR
    e = parforClauseE(p)
  elseif k == TK_CONNECT
    e = connectClause(p)
  elseif k == TK_WHEN
    e = whenClauseE(p)
  elseif k == TK_RECONFIGURE
    e = reconfigureBlock(p)
  elseif k == TK_FAILURE
    advance!(p)
    expect!(p, TK_LPAR, "after 'failure'")
    local eq::Absyn.EquationItem = equation(p)
    expect!(p, TK_RPAR)
    e = Absyn.EQ_FAILURE(eq)
  elseif k == TK_EQUALITY
    advance!(p)
    expect!(p, TK_LPAR, "after 'equality'")
    local e1::Absyn.Exp = expression(p, p.metaModelica)
    expect!(p, TK_EQUALS)
    local e2::Absyn.Exp = expression(p, p.metaModelica)
    expect!(p, TK_RPAR)
    e = Absyn.EQ_NORETCALL(Absyn.CREF_IDENT("equality", NIL),
                           Absyn.FUNCTIONARGS(consT(Absyn.Exp, e1, consT(Absyn.Exp, e2, NIL)), NIL))
  else
    e = equalityOrNoretcallEquation(p)
  end
  local cmt::Union{Nothing, Absyn.Comment} = comment(p)
  return Absyn.EQUATIONITEM(e, someOrNone(cmt), info(p, start))
end

"""
    constraint(p::ParserState)

`constraint` (Optimica): an expression or a statement.
"""
function constraint(p::ParserState)::Any
  local k::TokenKind = la(p)
  local a::Any
  if k == TK_IF
    a = conditionalEquationA(p)
  elseif k == TK_FOR
    a = forClauseA(p)
  elseif k == TK_PARFOR
    a = parforClauseA(p)
  elseif k == TK_WHILE
    a = whileClause(p)
  elseif k == TK_WHEN
    a = whenClauseA(p)
  elseif k == TK_BREAK
    advance!(p); a = Absyn.ALG_BREAK()
  elseif k == TK_RETURN
    advance!(p); a = Absyn.ALG_RETURN()
  elseif k == TK_CONTINUE
    advance!(p); a = Absyn.ALG_CONTINUE()
  else
    a = simpleExpr(p)
  end
  comment(p)
  return a
end

"""
    algorithm(p::ParserState)::Absyn.AlgorithmItem

`algorithm`: one statement and its comment.
"""
function algorithm(p::ParserState)::Absyn.AlgorithmItem
  local start::Int = p.pos
  local k::TokenKind = la(p)
  local a::Absyn.Algorithm
  if k == TK_IF
    a = conditionalEquationA(p)
  elseif k == TK_FOR
    a = forClauseA(p)
  elseif k == TK_PARFOR
    a = parforClauseA(p)
  elseif k == TK_WHILE
    a = whileClause(p)
  elseif k == TK_TRY
    a = tryClause(p)
  elseif k == TK_WHEN
    a = whenClauseA(p)
  elseif k == TK_BREAK
    advance!(p); a = Absyn.ALG_BREAK()
  elseif k == TK_RETURN
    advance!(p); a = Absyn.ALG_RETURN()
  elseif k == TK_CONTINUE
    advance!(p); a = Absyn.ALG_CONTINUE()
  elseif k == TK_FAILURE
    advance!(p)
    expect!(p, TK_LPAR, "after 'failure'")
    local al::Absyn.AlgorithmItem = algorithm(p)
    expect!(p, TK_RPAR)
    a = Absyn.ALG_FAILURE(consT(Absyn.AlgorithmItem, al, NIL))
  elseif k == TK_EQUALITY
    advance!(p)
    expect!(p, TK_LPAR, "after 'equality'")
    local e1::Absyn.Exp = expression(p, p.metaModelica)
    expect!(p, TK_ASSIGN)
    local e2::Absyn.Exp = expression(p, p.metaModelica)
    expect!(p, TK_RPAR)
    local cr::Absyn.ComponentRef = Absyn.CREF_IDENT("equality", NIL)
    a = Absyn.ALG_NORETCALL(cr, Absyn.FUNCTIONARGS(consT(Absyn.Exp, e1, consT(Absyn.Exp, e2, NIL)), NIL))
  else
    a = assignClauseA(p)
  end
  local cmt::Union{Nothing, Absyn.Comment} = comment(p)
  return Absyn.ALGORITHMITEM(a, someOrNone(cmt), info(p, start))
end

"""
    assignClauseA(p::ParserState)::Absyn.Algorithm

`assign_clause_a`: `simple_expression (':=' expression)?` (a call when alone).
"""
function assignClauseA(p::ParserState)::Absyn.Algorithm
  local start::Int = p.pos
  local e1::Absyn.Exp = simpleExpression(p)
  local k::TokenKind = la(p)
  if k == TK_ASSIGN || k == TK_EQUALS
    local op::Int = advance!(p)
    local e2::Absyn.Exp = expression(p, p.metaModelica)
    k == TK_EQUALS && errorAt(p, op, "Algorithms can not contain equations ('='), use assignments (':=') instead")
    local looksLikeCref::Bool = e1 isa Absyn.CREF
    local looksLikeCall::Bool = e1 isa Absyn.TUPLE && e2 isa Absyn.CALL
    local looksLikeDerCr::Bool = !looksLikeCref && !looksLikeCall && isDerCref(e1)
    (p.metaModelica || looksLikeCref || looksLikeCall || looksLikeDerCr) ||
      errorAt(p, start, "Modelica assignment statements are either on the form 'component_reference := expression' or '( output_expression_list ) := function_call'")
    return Absyn.ALG_ASSIGN(e1, e2)
  end
  e1 isa Absyn.CALL || errorAt(p, start, "Only function call expressions may stand alone in an algorithm section")
  local call::Absyn.CALL = e1
  return Absyn.ALG_NORETCALL(call.function_, call.functionArgs)
end

"""
    isDerCref(exp::Absyn.Exp)::Bool

`der(cref)`. (The 0.2 C parser calls `OMParser.isDerCref` on the records of the Absyn package:
`test/Differential/absynDiff.jl` defines it for them.)
"""
function isDerCref(exp::Absyn.Exp)::Bool
  exp isa Absyn.CALL || return false
  local fn::Absyn.ComponentRef = exp.function_
  (fn isa Absyn.CREF_IDENT && fn.name == "der" && fn.subscripts isa ImmutableList.Nil) || return false
  exp.typeVars isa ImmutableList.Nil || return false
  local fa::Absyn.FunctionArgs = exp.functionArgs
  fa isa Absyn.FUNCTIONARGS || return false
  fa.argNames isa ImmutableList.Nil || return false
  local args = fa.args
  return args isa ImmutableList.Cons && args.head isa Absyn.CREF && args.tail isa ImmutableList.Nil
end

"""
    equalityOrNoretcallEquation(p::ParserState)::Absyn.Equation

`equality_or_noretcall_equation`: `simple_expression ('=' expression (indomain cref)?)?` (a call
when alone).
"""
function equalityOrNoretcallEquation(p::ParserState)::Absyn.Equation
  local start::Int = p.pos
  local e1::Absyn.Exp = simpleExpression(p)
  local k::TokenKind = la(p)
  if k == TK_EQUALS || k == TK_ASSIGN
    local op::Int = advance!(p)
    local e2::Absyn.Exp = expression(p, p.metaModelica)
    local cr::Union{Nothing, Absyn.ComponentRef} = nothing
    if la(p) == TK_INDOMAIN
      advance!(p)
      cr = componentReference2(p)
    end
    k == TK_ASSIGN && errorAt(p, op, "Equations can not contain assignments (':='), use equality ('=') instead")
    if cr !== nothing
      return Absyn.EQ_PDE(e1, e2, cr)
    end
    return Absyn.EQ_EQUALS(e1, e2)
  end
  e1 isa Absyn.CALL || errorAt(p, start, "A singleton expression in an equation section is required to be a function call")
  local call::Absyn.CALL = e1
  return Absyn.EQ_NORETCALL(call.function_, call.functionArgs)
end

"""
    endIfError(p::ParserState, hasElse::Bool)

The error of an `if` closed by another `end` than `end if`.
"""
function endIfError(p::ParserState, hasElse::Bool)
  errorAt(p, p.pos, hasElse ? "Expected 'end if'; did you use a nested 'else if' instead of 'elseif'?" : "Expected 'end if'")
end

"""
    conditionalEquationE(p::ParserState)::Absyn.Equation

`conditional_equation_e`: `if e then eqs (elseif e then eqs)* (else eqs)? end if`.
"""
function conditionalEquationE(p::ParserState)::Absyn.Equation
  expect!(p, TK_IF)
  local e::Absyn.Exp = expression(p, p.metaModelica)
  expect!(p, TK_THEN, "after the if condition")
  local thenB::ImmutableList.List{Absyn.EquationItem} = equationList(p)
  local branches::Vector{Tuple{Absyn.Exp, ImmutableList.List{Absyn.EquationItem}}} = Tuple{Absyn.Exp, ImmutableList.List{Absyn.EquationItem}}[]
  while la(p) == TK_ELSEIF
    advance!(p)
    local c::Absyn.Exp = expression(p, p.metaModelica)
    expect!(p, TK_THEN, "after the elseif condition")
    push!(branches, (c, equationList(p)))
  end
  local elseB::Union{Nothing, ImmutableList.List{Absyn.EquationItem}} = nothing
  if accept!(p, TK_ELSE) != 0
    elseB = equationList(p)
  end
  local k::TokenKind = la(p)
  if k != TK_END_IF
    (k == TK_END_IDENT || k == TK_END_FOR || k == TK_END_WHEN) || expectedError(p, "'end if'")
    endIfError(p, elseB !== nothing)
  end
  advance!(p)
  return Absyn.EQ_IF(e, thenB, elseIfList(branches), orNil(elseB))
end

"""
    elseIfList(branches::Vector{E})::ImmutableList.List{E} where {E}

The list of `(condition, body)` tuples of `elseif`/`elsewhen` branches (or `nil`). The C layer
conses them untyped, and the constructors convert that list to the field's type, `List{E}`: built
here as a `List{E}` it is the same list.
"""
function elseIfList(branches::Vector{E})::ImmutableList.List{E} where {E}
  local ast::ImmutableList.List{E} = NIL
  for i::Int in length(branches):-1:1
    ast = consT(E, branches[i], ast)
  end
  return ast
end

"""
    conditionalEquationA(p::ParserState)::Absyn.Algorithm

`conditional_equation_a`: the `if` statement.
"""
function conditionalEquationA(p::ParserState)::Absyn.Algorithm
  expect!(p, TK_IF)
  local e::Absyn.Exp = expression(p, p.metaModelica)
  expect!(p, TK_THEN, "after the if condition")
  local thenB::ImmutableList.List{Absyn.AlgorithmItem} = algorithmList(p)
  local branches::Vector{Tuple{Absyn.Exp, ImmutableList.List{Absyn.AlgorithmItem}}} = Tuple{Absyn.Exp, ImmutableList.List{Absyn.AlgorithmItem}}[]
  while la(p) == TK_ELSEIF
    advance!(p)
    local c::Absyn.Exp = expression(p, p.metaModelica)
    expect!(p, TK_THEN, "after the elseif condition")
    push!(branches, (c, algorithmList(p)))
  end
  local elseB::Union{Nothing, ImmutableList.List{Absyn.AlgorithmItem}} = nothing
  if accept!(p, TK_ELSE) != 0
    elseB = algorithmList(p)
  end
  local k::TokenKind = la(p)
  if k != TK_END_IF
    (k == TK_END_IDENT || k == TK_END_FOR || k == TK_END_WHEN || k == TK_END_WHILE) || expectedError(p, "'end if'")
    endIfError(p, elseB !== nothing)
  end
  advance!(p)
  return Absyn.ALG_IF(e, thenB, elseIfList(branches), orNil(elseB))
end

"""
    forClauseE(p::ParserState)::Absyn.Equation

`for_clause_e`: `for indices loop eqs end for`.
"""
function forClauseE(p::ParserState)::Absyn.Equation
  expect!(p, TK_FOR)
  local is::ImmutableList.List{Absyn.ForIterator} = forIndices(p)
  expect!(p, TK_LOOP, "after the for indices")
  local es::ImmutableList.List{Absyn.EquationItem} = equationList(p)
  expect!(p, TK_END_FOR, "at the end of the for loop")
  return Absyn.EQ_FOR(is, es)
end

"""
    forClauseA(p::ParserState)::Absyn.Algorithm

`for_clause_a`: the `for` statement.
"""
function forClauseA(p::ParserState)::Absyn.Algorithm
  expect!(p, TK_FOR)
  local is::ImmutableList.List{Absyn.ForIterator} = forIndices(p)
  expect!(p, TK_LOOP, "after the for indices")
  local as::ImmutableList.List{Absyn.AlgorithmItem} = algorithmList(p)
  expect!(p, TK_END_FOR, "at the end of the for loop")
  return Absyn.ALG_FOR(is, as)
end

"""
    parforClauseE(p::ParserState)::Absyn.Equation

`parfor_clause_e` (an `EQ_FOR`).
"""
function parforClauseE(p::ParserState)::Absyn.Equation
  expect!(p, TK_PARFOR)
  local is::ImmutableList.List{Absyn.ForIterator} = forIndices(p)
  expect!(p, TK_LOOP)
  local es::ImmutableList.List{Absyn.EquationItem} = equationList(p)
  expect!(p, TK_END_PARFOR)
  return Absyn.EQ_FOR(is, es)
end

"""
    parforClauseA(p::ParserState)::Absyn.Algorithm

`parfor_clause_a`.
"""
function parforClauseA(p::ParserState)::Absyn.Algorithm
  expect!(p, TK_PARFOR)
  local is::ImmutableList.List{Absyn.ForIterator} = forIndices(p)
  expect!(p, TK_LOOP)
  local as::ImmutableList.List{Absyn.AlgorithmItem} = algorithmList(p)
  expect!(p, TK_END_PARFOR)
  return Absyn.ALG_PARFOR(is, as)
end

"""
    whileClause(p::ParserState)::Absyn.Algorithm

`while_clause`: `while e loop stmts end while`.
"""
function whileClause(p::ParserState)::Absyn.Algorithm
  expect!(p, TK_WHILE)
  local e::Absyn.Exp = expression(p, p.metaModelica)
  expect!(p, TK_LOOP, "after the while condition")
  local as::ImmutableList.List{Absyn.AlgorithmItem} = algorithmList(p)
  expect!(p, TK_END_WHILE, "at the end of the while loop")
  return Absyn.ALG_WHILE(e, as)
end

"""
    tryClause(p::ParserState)::Absyn.Algorithm

`try_clause`: `try stmts else stmts end try`.
"""
function tryClause(p::ParserState)::Absyn.Algorithm
  expect!(p, TK_TRY)
  local as1::ImmutableList.List{Absyn.AlgorithmItem} = algorithmList(p)
  expect!(p, TK_ELSE)
  local as2::ImmutableList.List{Absyn.AlgorithmItem} = algorithmList(p)
  expect!(p, TK_END_TRY)
  return Absyn.ALG_TRY(as1, as2)
end

"""
    whenClauseE(p::ParserState)::Absyn.Equation

`when_clause_e`: `when e then eqs (elsewhen e then eqs)* end when`.
"""
function whenClauseE(p::ParserState)::Absyn.Equation
  expect!(p, TK_WHEN)
  local e::Absyn.Exp = expression(p, p.metaModelica)
  expect!(p, TK_THEN, "after the when condition")
  local body::ImmutableList.List{Absyn.EquationItem} = equationList(p)
  local branches::Vector{Tuple{Absyn.Exp, ImmutableList.List{Absyn.EquationItem}}} = Tuple{Absyn.Exp, ImmutableList.List{Absyn.EquationItem}}[]
  while la(p) == TK_ELSEWHEN
    advance!(p)
    local c::Absyn.Exp = expression(p, p.metaModelica)
    expect!(p, TK_THEN, "after the elsewhen condition")
    push!(branches, (c, equationList(p)))
  end
  expect!(p, TK_END_WHEN, "at the end of the when equation")
  return Absyn.EQ_WHEN_E(e, body, elseIfList(branches))
end

"""
    whenClauseA(p::ParserState)::Absyn.Algorithm

`when_clause_a`: the `when` statement.
"""
function whenClauseA(p::ParserState)::Absyn.Algorithm
  expect!(p, TK_WHEN)
  local e::Absyn.Exp = expression(p, p.metaModelica)
  expect!(p, TK_THEN, "after the when condition")
  local body::ImmutableList.List{Absyn.AlgorithmItem} = algorithmList(p)
  local branches::Vector{Tuple{Absyn.Exp, ImmutableList.List{Absyn.AlgorithmItem}}} = Tuple{Absyn.Exp, ImmutableList.List{Absyn.AlgorithmItem}}[]
  while la(p) == TK_ELSEWHEN
    advance!(p)
    local c::Absyn.Exp = expression(p, p.metaModelica)
    expect!(p, TK_THEN, "after the elsewhen condition")
    push!(branches, (c, algorithmList(p)))
  end
  expect!(p, TK_END_WHEN, "at the end of the when statement")
  return Absyn.ALG_WHEN_A(e, body, elseIfList(branches))
end

"""
    reconfigureBlock(p::ParserState)::Absyn.Equation

`reconfigure_block` (variable structure systems).
"""
function reconfigureBlock(p::ParserState)::Absyn.Equation
  expect!(p, TK_RECONFIGURE)
  local vars::ImmutableList.List{Absyn.ElementItem} = reconfigureVarList(p)
  local clauses::Vector{Absyn.WhenClause} = Absyn.WhenClause[]
  while true
    expect!(p, TK_WHEN, "(an upon clause)")
    local e1::Absyn.Exp = expression(p, p.metaModelica)
    if accept!(p, TK_IMPLIES) != 0
      local e2::Absyn.Exp = expression(p, p.metaModelica)
      expect!(p, TK_SEMICOLON)
      push!(clauses, Absyn.WHEN_CONDITIONAL(e1, e2))
    else
      expect!(p, TK_SEMICOLON)
      push!(clauses, Absyn.WHEN_TRIGGER(e1))
    end
    la(p) == TK_WHEN || break
  end
  local cl::ImmutableList.List{Absyn.WhenClause} = NIL
  for i::Int in length(clauses):-1:1
    cl = consT(Absyn.WhenClause, clauses[i], cl)
  end
  local promptOpt::Union{Nothing, Absyn.Exp} = nothing
  if la(p) == TK_PROMPT
    advance!(p)
    expect!(p, TK_LPAR)
    promptOpt = expression(p, p.metaModelica)
    expect!(p, TK_RPAR)
    expect!(p, TK_SEMICOLON)
  end
  local mod::Union{Nothing, ImmutableList.List{Absyn.EquationItem}} = nothing
  if la(p) == TK_BEGIN_MODIFICATION
    advance!(p)
    mod = equationList(p)
    expect!(p, TK_END_MODIFICATION)
  end
  local initEqs::Union{Nothing, ImmutableList.List{Absyn.EquationItem}} = nothing
  if la(p) == TK_INITIAL
    advance!(p)
    expect!(p, TK_EQUATION)
    initEqs = equationList(p)
  end
  expect!(p, TK_END_RECONFIGURE)
  return Absyn.EQ_RECONFIGURE(vars, cl, someOf(Absyn.Exp, promptOpt), someOf(ImmutableList.List{Absyn.EquationItem}, mod),
                              someOf(ImmutableList.List{Absyn.EquationItem}, initEqs))
end

"""
    reconfigureVarList(p::ParserState)::ImmutableList.List{Absyn.ElementItem}

`reconfigure_var_list`: `(component_clause ';')*` up to `when`/`end reconfigure` (the source
info of each element reaches to the end of the list, as in the C actions).
"""
function reconfigureVarList(p::ParserState)::ImmutableList.List{Absyn.ElementItem}
  local k::TokenKind = la(p)
  if k == TK_WHEN || k == TK_END_RECONFIGURE
    return NIL
  end
  local start::Int = p.pos
  local cc::Absyn.ElementSpec = componentClause(p)
  expect!(p, TK_SEMICOLON)
  local rest::ImmutableList.List{Absyn.ElementItem} = reconfigureVarList(p)
  local el::Absyn.Element = Absyn.ELEMENT(false, nothing, Absyn.NOT_INNER_OUTER(), cc, info(p, start), nothing)
  return consT(Absyn.ElementItem, Absyn.ELEMENTITEM(el), rest)
end

"""
    equationListThen(p::ParserState)::ImmutableList.List{Absyn.EquationItem}

`equation_list_then`: `(equation ';')*` up to `then` (match cases).
"""
function equationListThen(p::ParserState)::ImmutableList.List{Absyn.EquationItem}
  local items::Vector{Absyn.EquationItem} = Absyn.EquationItem[]
  while la(p) != TK_THEN
    push!(items, equation(p))
    expect!(p, TK_SEMICOLON, "after the equation")
  end
  local ast::ImmutableList.List{Absyn.EquationItem} = NIL
  for i::Int in length(items):-1:1
    ast = consT(Absyn.EquationItem, items[i], ast)
  end
  return ast
end

"""
    equationList(p::ParserState)::ImmutableList.List{Absyn.EquationItem}

`equation_list`: `(equation ';')*` in a nested body. Each level takes the comments before its
first token (in source order, before its equation).
"""
function equationList(p::ParserState)::ImmutableList.List{Absyn.EquationItem}
  local equations::Vector{Absyn.EquationItem} = Absyn.EquationItem[]
  local firsts::Vector{Int} = Int[]
  local lasts::Vector{Int} = Int[]
  while true
    local first::Int = p.firstComment
    local last::Int = commentsBefore(p)
    p.firstComment = last + 1
    push!(firsts, first)
    push!(lasts, last)
    startsEquation(la(p)) || break
    push!(equations, equation(p))
    expect!(p, TK_SEMICOLON, "after the equation")
  end
  local n::Int = length(firsts)
  local ast::ImmutableList.List{Absyn.EquationItem} = NIL
  for level::Int in n:-1:1
    if level < n
      ast = consT(Absyn.EquationItem, equations[level], ast)
    end
    for c::Int in lasts[level]:-1:firsts[level]
      ast = consT(Absyn.EquationItem, Absyn.EQUATIONITEMCOMMENT(commentText(p.ts, c)), ast)
    end
  end
  return ast
end

"""
    algorithmList(p::ParserState)::ImmutableList.List{Absyn.AlgorithmItem}

`algorithm_list`: `(algorithm ';')*` in a nested body (no comment items).
"""
function algorithmList(p::ParserState)::ImmutableList.List{Absyn.AlgorithmItem}
  local items::Vector{Absyn.AlgorithmItem} = Absyn.AlgorithmItem[]
  while startsAlgorithm(la(p))
    push!(items, algorithm(p))
    expect!(p, TK_SEMICOLON, "after the statement")
  end
  local ast::ImmutableList.List{Absyn.AlgorithmItem} = NIL
  for i::Int in length(items):-1:1
    ast = consT(Absyn.AlgorithmItem, items[i], ast)
  end
  return ast
end

"""
    connectClause(p::ParserState)::Absyn.Equation

`connect_clause`: `connect(cref, cref)`.
"""
function connectClause(p::ParserState)::Absyn.Equation
  expect!(p, TK_CONNECT)
  expect!(p, TK_LPAR, "after 'connect'")
  local cr1::Absyn.ComponentRef = componentReference(p)
  expect!(p, TK_COMMA, "between the connectors")
  local cr2::Absyn.ComponentRef = componentReference(p)
  expect!(p, TK_RPAR, "at the end of the connect")
  return Absyn.EQ_CONNECT(cr1, cr2)
end

#= Expressions =#

"""
    expression(p::ParserState, allowPartEvalFunc::Bool)::Absyn.Exp

`expression`: an if-expression, a simple expression, a code expression, a match expression or
(as a function argument) a partially applied function.
"""
function expression(p::ParserState, allowPartEvalFunc::Bool)::Absyn.Exp
  local k::TokenKind = la(p)
  if k == TK_IF
    return ifExpression(p)
  elseif k == TK_CODE || k == TK_CODE_NAME || k == TK_CODE_ANNOTATION || k == TK_CODE_VAR
    return codeExpression(p)
  elseif k == TK_MATCH || k == TK_MATCHCONTINUE
    return matchExpression(p)
  elseif k == TK_FUNCTION
    local start::Int = advance!(p)
    local cr::Absyn.ComponentRef = componentReference(p)
    expect!(p, TK_LPAR)
    local args::ImmutableList.List{Absyn.NamedArg} = la(p) == TK_RPAR ? NIL : namedArguments(p)
    expect!(p, TK_RPAR)
    allowPartEvalFunc || errorAt(p, start, "Function partial application expressions are only allowed as inputs to functions.")
    return Absyn.PARTEVALFUNCTION(cr, Absyn.FUNCTIONARGS(NIL, args))
  end
  startsSimpleExpression(k) || expectedError(p, "an expression")
  return simpleExpression(p)
end

"""
    ifExpression(p::ParserState)::Absyn.Exp

`if_expression`: `if c then e (elseif c then e)* else e`.
"""
function ifExpression(p::ParserState)::Absyn.Exp
  expect!(p, TK_IF)
  local cond::Absyn.Exp = expression(p, p.metaModelica)
  expect!(p, TK_THEN, "after the if condition")
  local e1::Absyn.Exp = expression(p, p.metaModelica)
  local branches::Vector{Tuple{Absyn.Exp, Absyn.Exp}} = Tuple{Absyn.Exp, Absyn.Exp}[]
  while la(p) == TK_ELSEIF
    advance!(p)
    local c::Absyn.Exp = expression(p, p.metaModelica)
    expect!(p, TK_THEN, "after the elseif condition")
    push!(branches, (c, expression(p, p.metaModelica)))
  end
  expect!(p, TK_ELSE, "(an if-expression needs an else branch)")
  local e2::Absyn.Exp = expression(p, p.metaModelica)
  return Absyn.IFEXP(cond, e1, e2, elseIfList(branches))
end

"""
    forIndices(p::ParserState)::ImmutableList.List{Absyn.ForIterator}

`for_indices`: `for_index (',' for_index)*`.
"""
function forIndices(p::ParserState)::ImmutableList.List{Absyn.ForIterator}
  local its::Vector{Absyn.ForIterator} = Absyn.ForIterator[forIndex(p)]
  while accept!(p, TK_COMMA) != 0
    push!(its, forIndex(p))
  end
  local ast::ImmutableList.List{Absyn.ForIterator} = NIL
  for i::Int in length(its):-1:1
    ast = consT(Absyn.ForIterator, its[i], ast)
  end
  return ast
end

"""
    forIndex(p::ParserState)::Absyn.ForIterator

`for_index`: `IDENT (((if|guard) e)? in e)?`.
"""
function forIndex(p::ParserState)::Absyn.ForIterator
  local i::Int = expect!(p, TK_IDENT, "(a for index)")
  local guard::Union{Nothing, Absyn.Exp} = nothing
  local e::Union{Nothing, Absyn.Exp} = nothing
  local k::TokenKind = la(p)
  if k == TK_IF || k == TK_GUARD || k == TK_IN
    if k != TK_IN
      advance!(p)
      guard = expression(p, p.metaModelica)
    end
    expect!(p, TK_IN, "after the for index")
    e = expression(p, p.metaModelica)
  end
  return Absyn.ITERATOR(text(p, i), someOf(Absyn.Exp, guard), someOf(Absyn.Exp, e))
end

"""
    simpleExpression(p::ParserState)::Absyn.Exp

`simple_expression`: `simple_expr ('::' simple_expression)?` or `IDENT as simple_expression`.
"""
function simpleExpression(p::ParserState)::Absyn.Exp
  if la(p) == TK_IDENT && la(p, 2) == TK_AS
    local i::Int = advance!(p)
    advance!(p)
    local e::Absyn.Exp = simpleExpression(p)
    return Absyn.AS(text(p, i), e)
  end
  local e1::Absyn.Exp = simpleExpr(p)
  if la(p) == TK_COLONCOLON
    advance!(p)
    local e2::Absyn.Exp = simpleExpression(p)
    return Absyn.CONS(e1, e2)
  end
  return e1
end

"""
    simpleExpr(p::ParserState)::Absyn.Exp

`simple_expr`: a logical expression or a range `a:b` / `a:b:c`.
"""
function simpleExpr(p::ParserState)::Absyn.Exp
  local e1::Absyn.Exp = logicalExpression(p)
  la(p) == TK_COLON || return e1
  advance!(p)
  local e2::Absyn.Exp = logicalExpression(p)
  if la(p) == TK_COLON
    advance!(p)
    local e3::Absyn.Exp = logicalExpression(p)
    return Absyn.RANGE(e1, SOME{Absyn.Exp}(e2), e3)
  end
  return Absyn.RANGE(e1, nothing, e2)
end

"""
    logicalExpression(p::ParserState)::Absyn.Exp

`logical_expression`: `logical_term (or logical_term)*`.
"""
function logicalExpression(p::ParserState)::Absyn.Exp
  local ast::Absyn.Exp = logicalTerm(p)
  while la(p) == TK_OR
    advance!(p)
    local e2::Absyn.Exp = logicalTerm(p)
    ast = Absyn.LBINARY(ast, Absyn.OR(), e2)
  end
  return ast
end

"""
    logicalTerm(p::ParserState)::Absyn.Exp

`logical_term`: `logical_factor (and logical_factor)*`.
"""
function logicalTerm(p::ParserState)::Absyn.Exp
  local ast::Absyn.Exp = logicalFactor(p)
  while la(p) == TK_AND
    advance!(p)
    local e2::Absyn.Exp = logicalFactor(p)
    ast = Absyn.LBINARY(ast, Absyn.AND(), e2)
  end
  return ast
end

"""
    logicalFactor(p::ParserState)::Absyn.Exp

`logical_factor`: `not? relation`.
"""
function logicalFactor(p::ParserState)::Absyn.Exp
  if accept!(p, TK_NOT) != 0
    local e::Absyn.Exp = relation(p)
    return Absyn.LUNARY(Absyn.NOT(), e)
  end
  return relation(p)
end

"""
    relation(p::ParserState)::Absyn.Exp

`relation`: `arithmetic_expression (relop arithmetic_expression)?`.
"""
function relation(p::ParserState)::Absyn.Exp
  local e1::Absyn.Exp = arithmeticExpression(p)
  local k::TokenKind = la(p)
  local op::Absyn.Operator
  if k == TK_LESS
    op = Absyn.LESS()
  elseif k == TK_LESSEQ
    op = Absyn.LESSEQ()
  elseif k == TK_GREATER
    op = Absyn.GREATER()
  elseif k == TK_GREATEREQ
    op = Absyn.GREATEREQ()
  elseif k == TK_EQEQ
    op = Absyn.EQUAL()
  elseif k == TK_LESSGT
    op = Absyn.NEQUAL()
  else
    return e1
  end
  advance!(p)
  local e2::Absyn.Exp = arithmeticExpression(p)
  return Absyn.RELATION(e1, op, e2)
end

"""
    arithmeticExpression(p::ParserState)::Absyn.Exp

`arithmetic_expression`: `unary_arithmetic_expression ((+|-|.+|.-) term)*`.
"""
function arithmeticExpression(p::ParserState)::Absyn.Exp
  local ast::Absyn.Exp = unaryArithmeticExpression(p)
  while true
    local k::TokenKind = la(p)
    local op::Absyn.Operator
    if k == TK_PLUS
      op = Absyn.ADD()
    elseif k == TK_MINUS
      op = Absyn.SUB()
    elseif k == TK_PLUS_EW
      op = Absyn.ADD_EW()
    elseif k == TK_MINUS_EW
      op = Absyn.SUB_EW()
    else
      break
    end
    advance!(p)
    local e2::Absyn.Exp = term(p)
    ast = Absyn.BINARY(ast, op, e2)
  end
  return ast
end

"""
    unaryArithmeticExpression(p::ParserState)::Absyn.Exp

`unary_arithmetic_expression`: `(+|-|.+|.-)? term`.
"""
function unaryArithmeticExpression(p::ParserState)::Absyn.Exp
  local k::TokenKind = la(p)
  local op::Absyn.Operator
  if k == TK_PLUS
    op = Absyn.UPLUS()
  elseif k == TK_MINUS
    op = Absyn.UMINUS()
  elseif k == TK_PLUS_EW
    op = Absyn.UPLUS_EW()
  elseif k == TK_MINUS_EW
    op = Absyn.UMINUS_EW()
  else
    return term(p)
  end
  advance!(p)
  local t::Absyn.Exp = term(p)
  return Absyn.UNARY(op, t)
end

"""
    term(p::ParserState)::Absyn.Exp

`term`: `factor ((*|/|.*|./) factor)*`.
"""
function term(p::ParserState)::Absyn.Exp
  local ast::Absyn.Exp = factor(p)
  while true
    local k::TokenKind = la(p)
    local op::Absyn.Operator
    if k == TK_STAR
      op = Absyn.MUL()
    elseif k == TK_SLASH
      op = Absyn.DIV()
    elseif k == TK_STAR_EW
      op = Absyn.MUL_EW()
    elseif k == TK_SLASH_EW
      op = Absyn.DIV_EW()
    else
      break
    end
    advance!(p)
    local e2::Absyn.Exp = factor(p)
    ast = Absyn.BINARY(ast, op, e2)
  end
  return ast
end

"""
    factor(p::ParserState)::Absyn.Exp

`factor`: `primary ((^|.^) primary)?`.
"""
function factor(p::ParserState)::Absyn.Exp
  local e1::Absyn.Exp = primary(p)
  local k::TokenKind = la(p)
  if k == TK_POWER || k == TK_POWER_EW
    advance!(p)
    local e2::Absyn.Exp = primary(p)
    return Absyn.BINARY(e1, k == TK_POWER ? Absyn.POW() : Absyn.POW_EW(), e2)
  end
  return e1
end

"""
    integerValue(s::String)::Int64

The value of an integer literal as the C actions compute it: `strtol` (saturating at the `long`
range), then truncated to a C `int`.
"""
function integerValue(s::String)::Int64
  local v::Int64 = 0
  for b::UInt8 in codeunits(s)
    local d::Int64 = Int64(b - 0x30)
    if v > (typemax(Int64) - d) ÷ 10
      v = typemax(Int64)
      break
    end
    v = 10 * v + d
  end
  return Int64(v % Int32)
end

"""
    realRepresentable(s::String)::Bool

`strtod` reads all of `s` without a range error (the check of the C action).
"""
function realRepresentable(s::String)::Bool
  local endPtr::Base.RefValue{Ptr{UInt8}} = Ref{Ptr{UInt8}}(C_NULL)
  Libc.errno(0)
  GC.@preserve s begin
    ccall(:strtod, Cdouble, (Cstring, Ptr{Ptr{UInt8}}), s, endPtr)
    local consumed::Int = Int(endPtr[] - pointer(s))
    return consumed == ncodeunits(s) && Libc.errno() == 0
  end
end

"""
    primary(p::ParserState)::Absyn.Exp

`primary`: a literal, a component reference or call, `der(...)`, `pure(...)`, a parenthesized
expression or tuple, a matrix, an array constructor, or `end`.
"""
function primary(p::ParserState)::Absyn.Exp
  local start::Int = p.pos
  local k::TokenKind = la(p)
  if k == TK_UNSIGNED_INTEGER
    return Absyn.INTEGER(integerValue(text(p, advance!(p))))
  elseif k == TK_UNSIGNED_REAL
    local chars::String = text(p, advance!(p))
    realRepresentable(chars) || errorAt(p, start, chars * " cannot be represented by a double on this machine")
    return Absyn.REAL(chars)
  elseif k == TK_STRING
    return Absyn.STRING(text(p, advance!(p)))
  elseif k == TK_FALSE
    advance!(p); return Absyn.BOOL(false)
  elseif k == TK_TRUE
    advance!(p); return Absyn.BOOL(true)
  elseif k == TK_DOT || k == TK_IDENT || k == TK_OPERATOR || k == TK_ALLWILD || k == TK_WILD || k == TK_INITIAL
    return componentReferenceFunctionCall(p)
  elseif k == TK_DER
    advance!(p)
    local derArgs::Absyn.FunctionArgs = functionCall(p)
    return Absyn.CALL(Absyn.CREF_IDENT("der", NIL), derArgs, NIL)
  elseif k == TK_PURE
    advance!(p)
    local pureArgs::Absyn.FunctionArgs = functionCall(p)
    return Absyn.CALL(Absyn.CREF_IDENT("pure", NIL), pureArgs, NIL)
  elseif k == TK_LPAR
    advance!(p)
    local isTuple::Base.RefValue{Bool} = Ref(false)
    local inner::Any = outputExpressionList(p, isTuple)
    if la(p) == TK_LBRACK
      local subs::ImmutableList.List{Absyn.Subscript} = arraySubscripts(p)
      isTuple[] && errorAt(p, start, "Tuple expression can not be subscripted.")
      return Absyn.SUBSCRIPTED_EXP(inner, subs)
    end
    return isTuple[] ? Absyn.TUPLE(inner) : inner
  elseif k == TK_LBRACK
    advance!(p)
    local rows::Vector{ImmutableList.List{Absyn.Exp}} = ImmutableList.List{Absyn.Exp}[expressionList(p)]
    while accept!(p, TK_SEMICOLON) != 0
      push!(rows, expressionList(p))
    end
    expect!(p, TK_RBRACK, "at the end of the matrix")
    local m::ImmutableList.List{ImmutableList.List{Absyn.Exp}} = NIL
    for i::Int in length(rows):-1:1
      m = consT(ImmutableList.List{Absyn.Exp}, rows[i], m)
    end
    return Absyn.MATRIX(m)
  elseif k == TK_LBRACE
    advance!(p)
    local (arrEl::Any, isFor::Bool) = forOrExpressionList(p)
    expect!(p, TK_RBRACE, "at the end of the array")
    if !isFor
      (!(arrEl isa ImmutableList.Nil) || p.metaModelica) ||
        errorAt(p, start, "Empty array constructors are not valid in Modelica.")
      return Absyn.ARRAY(arrEl)
    end
    return Absyn.CALL(Absyn.CREF_IDENT(ARRAY_REDUCTION_NAME, NIL), arrEl, NIL)
  elseif k == TK_END
    advance!(p); return Absyn.END()
  end
  expectedError(p, "an expression")
end

"""
    componentReferenceFunctionCall(p::ParserState)::Absyn.Exp

`component_reference__function_call`: `cref '<' names '>' function_call` (MetaModelica), `cref
(function_call ('.' expression)?)?`, or `initial()`.
"""
function componentReferenceFunctionCall(p::ParserState)::Absyn.Exp
  local start::Int = p.pos
  if la(p) == TK_INITIAL
    advance!(p)
    expect!(p, TK_LPAR, "after 'initial'")
    expect!(p, TK_RPAR, "after 'initial('")
    return Absyn.CALL(Absyn.CREF_IDENT("initial", NIL), Absyn.FUNCTIONARGS(NIL, NIL), NIL)
  end
  local cr::Absyn.ComponentRef = componentReference(p)
  if la(p) == TK_LESS && looksLikeTypeArguments(p)
    advance!(p)
    local ids::ImmutableList.List{Absyn.Path} = nameList(p)
    expect!(p, TK_GREATER)
    local polyArgs::Absyn.FunctionArgs = functionCall(p)
    p.metaModelica || errorAt(p, start, "Polymorphic type specifiers are only available in MetaModelica")
    return Absyn.CALL(cr, polyArgs, ids)
  end
  if la(p) == TK_LPAR
    local fc::Absyn.FunctionArgs = functionCall(p)
    local call::Absyn.Exp = Absyn.CALL(cr, fc, NIL)
    if la(p) == TK_DOT
      advance!(p)
      local e::Absyn.Exp = expression(p, p.metaModelica)
      p.dialect.langStd >= 1000 || errorAt(p, start, "Dot operator is not allowed in function calls in current Modelica standards.")
      return Absyn.DOT(call, e)
    end
    return call
  end
  return Absyn.CREF(cr)
end

"""
    looksLikeTypeArguments(p::ParserState)::Bool

The syntactic predicate `cref '<' name_list '>' function_call`: at `<`, the tokens are names
separated by commas, then `>` and `(`.
"""
function looksLikeTypeArguments(p::ParserState)::Bool
  local i::Int = p.pos + 1
  local kinds::Vector{TokenKind} = p.kinds
  local n::Int = length(kinds)
  while true
    i <= n && kinds[i] == TK_DOT && (i += 1)
    (i <= n && (kinds[i] == TK_IDENT || kinds[i] == TK_CODE)) || return false
    i += 1
    while i + 1 <= n && kinds[i] == TK_DOT && (kinds[i + 1] == TK_IDENT || kinds[i + 1] == TK_CODE)
      i += 2
    end
    (i <= n && kinds[i] == TK_COMMA) || break
    i += 1
  end
  return i + 1 <= n && kinds[i] == TK_GREATER && kinds[i + 1] == TK_LPAR
end

"""
    namePath(p::ParserState)::Absyn.Path

`name_path`: `'.'? name_path2`.
"""
function namePath(p::ParserState)::Absyn.Path
  if la(p) == TK_DOT
    advance!(p)
    return Absyn.FULLYQUALIFIED(namePath2(p))
  end
  return namePath2(p)
end

"""
    namePath2(p::ParserState)::Absyn.Path

`name_path2`: `(IDENT | \$Code) ('.' (IDENT | \$Code))*`.
"""
function namePath2(p::ParserState)::Absyn.Path
  local first::Int = p.pos
  local k::TokenKind = la(p)
  (k == TK_IDENT || k == TK_CODE) || expectedError(p, "a name")
  advance!(p)
  local count::Int = 1
  while la(p) == TK_DOT
    advance!(p)
    k = la(p)
    (k == TK_IDENT || k == TK_CODE) || expectedError(p, "a name after '.'")
    advance!(p)
    count += 1
  end
  #= The identifiers are the tokens first, first+2, ... =#
  local path::Absyn.Path = Absyn.IDENT(text(p, first + 2 * (count - 1)))
  for j::Int in (count - 1):-1:1
    path = Absyn.QUALIFIED(text(p, first + 2 * (j - 1)), path)
  end
  return path
end

"""
    namePathStar(p::ParserState)::Tuple{Absyn.Path, Bool, Union{Nothing, ImmutableList.List{Absyn.GroupImport}}}

`name_path_star`: an import name, `name.*` or `name.{a, b = c}`.
"""
function namePathStar(p::ParserState)::Tuple{Absyn.Path, Bool, Union{Nothing, ImmutableList.List{Absyn.GroupImport}}}
  local k::TokenKind = la(p)
  (k == TK_IDENT || k == TK_CODE) || expectedError(p, "a name to import")
  if la(p, 2) != TK_DOT || la(p, 3) == TK_LBRACE
    local id::String = text(p, advance!(p))
    local unqual::Bool = false
    local lst::Union{Nothing, ImmutableList.List{Absyn.GroupImport}} = nothing
    if la(p) == TK_STAR_EW
      advance!(p)
      unqual = true
    elseif la(p) == TK_DOT
      advance!(p)
      expect!(p, TK_LBRACE)
      lst = namePathGroup(p)
      expect!(p, TK_RBRACE)
    end
    return (Absyn.IDENT(id), unqual, lst)
  end
  local qid::String = text(p, advance!(p))
  expect!(p, TK_DOT)
  local (rest::Absyn.Path, qunqual::Bool, qlst::Union{Nothing, ImmutableList.List{Absyn.GroupImport}}) = namePathStar(p)
  return (Absyn.QUALIFIED(qid, rest), qunqual, qlst)
end

"""
    namePathGroup(p::ParserState)::ImmutableList.List{Absyn.GroupImport}

`name_path_group`: `name ('=' name)? (',' ...)*` inside `import A.{...}`.
"""
function namePathGroup(p::ParserState)::ImmutableList.List{Absyn.GroupImport}
  local k::TokenKind = la(p)
  (k == TK_IDENT || k == TK_CODE) || expectedError(p, "a name")
  local id1::String = text(p, advance!(p))
  local id2::Union{Nothing, String} = nothing
  if accept!(p, TK_EQUALS) != 0
    k = la(p)
    (k == TK_IDENT || k == TK_CODE) || expectedError(p, "a name")
    id2 = text(p, advance!(p))
  end
  local rest::Union{Nothing, ImmutableList.List{Absyn.GroupImport}} = nothing
  if accept!(p, TK_COMMA) != 0
    rest = namePathGroup(p)
  end
  local g::Absyn.GroupImport = id2 !== nothing ? Absyn.GROUP_IMPORT_RENAME(id1, id2) : Absyn.GROUP_IMPORT_NAME(id1)
  return consT(Absyn.GroupImport, g, orNil(rest))
end

"""
    componentReference(p::ParserState)::Absyn.ComponentRef

`component_reference`: `'.'? component_reference2`, `__` or `_`.
"""
function componentReference(p::ParserState)::Absyn.ComponentRef
  local k::TokenKind = la(p)
  if k == TK_DOT
    advance!(p)
    return Absyn.CREF_FULLYQUALIFIED(componentReference2(p))
  elseif k == TK_ALLWILD
    advance!(p); return Absyn.ALLWILD()
  elseif k == TK_WILD
    advance!(p); return Absyn.WILD()
  end
  return componentReference2(p)
end

"""
    componentReference2(p::ParserState)::Absyn.ComponentRef

`component_reference2`: `(IDENT | operator) array_subscripts? ('.' component_reference2)?`.
"""
function componentReference2(p::ParserState)::Absyn.ComponentRef
  local names::Vector{String} = String[]
  local subs::Vector{ImmutableList.List{Absyn.Subscript}} = ImmutableList.List{Absyn.Subscript}[]
  while true
    local k::TokenKind = la(p)
    (k == TK_IDENT || k == TK_OPERATOR) || expectedError(p, "a component name")
    push!(names, text(p, advance!(p)))
    push!(subs, la(p) == TK_LBRACK ? arraySubscripts(p) : NIL)
    la(p) == TK_DOT || break
    advance!(p)
  end
  local n::Int = length(names)
  local cr::Absyn.ComponentRef = Absyn.CREF_IDENT(names[n], subs[n])
  for i::Int in (n - 1):-1:1
    cr = Absyn.CREF_QUAL(names[i], subs[i], cr)
  end
  return cr
end

"""
    functionCall(p::ParserState)::Absyn.FunctionArgs

`function_call`: `'(' function_arguments ')'`.
"""
function functionCall(p::ParserState)::Absyn.FunctionArgs
  expect!(p, TK_LPAR)
  local fa::Absyn.FunctionArgs = functionArguments(p)
  expect!(p, TK_RPAR, "at the end of the function arguments")
  return fa
end

"""
    functionArguments(p::ParserState)::Absyn.FunctionArgs

`function_arguments`: `for_or_expression_list named_arguments?`.
"""
function functionArguments(p::ParserState)::Absyn.FunctionArgs
  local (el::Any, isFor::Bool) = forOrExpressionList(p)
  local namel::Union{Nothing, ImmutableList.List{Absyn.NamedArg}} = nothing
  local k::TokenKind = la(p)
  if k == TK_IDENT || k == TK_OPERATOR
    namel = namedArguments(p)
  end
  if isFor
    return el
  end
  return Absyn.FUNCTIONARGS(el, orNil(namel))
end

"""
    forOrExpressionList(p::ParserState)::Tuple{Any, Bool}

`for_or_expression_list`: the positional arguments (a list), or `e for iterators` (a
`FOR_ITER_FARG`, second result `true`).
"""
function forOrExpressionList(p::ParserState)::Tuple{Any, Bool}
  local k::TokenKind = la(p)
  if ((k == TK_IDENT || k == TK_OPERATOR) && la(p, 2) == TK_EQUALS) || k == TK_RPAR || k == TK_RBRACE
    return (NIL, false)
  end
  local e::Absyn.Exp = expression(p, true)
  k = la(p)
  if k == TK_COMMA
    local el::ImmutableList.List{Absyn.Exp} = forOrExpressionList2(p)
    return (consT(Absyn.Exp, e, el), false)
  elseif k == TK_THREADED || k == TK_FOR
    local threaded::Bool = accept!(p, TK_THREADED) != 0
    expect!(p, TK_FOR)
    local forind::ImmutableList.List{Absyn.ForIterator} = forIndices(p)
    return (Absyn.FOR_ITER_FARG(e, threaded ? Absyn.THREAD() : Absyn.COMBINE(), forind), true)
  end
  return (consT(Absyn.Exp, e, NIL), false)
end

"""
    forOrExpressionList2(p::ParserState)::ImmutableList.List{Absyn.Exp}

`for_or_expression_list2`: `(',' expression)*`, stopping before the named arguments.
"""
function forOrExpressionList2(p::ParserState)::ImmutableList.List{Absyn.Exp}
  local ast::ImmutableList.List{Absyn.Exp} = NIL
  while la(p) == TK_COMMA
    advance!(p)
    if la(p) != TK_COMMA && la(p, 2) == TK_EQUALS
      continue
    end
    local e::Absyn.Exp = expression(p, true)
    ast = consT(Absyn.Exp, e, ast)
  end
  return listRev(ast)
end

"""
    namedArguments(p::ParserState)::ImmutableList.List{Absyn.NamedArg}

`named_arguments`: `named_argument (',' named_argument)*`.
"""
function namedArguments(p::ParserState)::ImmutableList.List{Absyn.NamedArg}
  local args::Vector{Absyn.NamedArg} = Absyn.NamedArg[]
  while true
    local k::TokenKind = la(p)
    (k == TK_IDENT || k == TK_OPERATOR) || expectedError(p, "a named argument")
    local id::String = text(p, advance!(p))
    expect!(p, TK_EQUALS, "after the argument name")
    local e::Absyn.Exp = expression(p, true)
    push!(args, Absyn.NAMEDARG(id, e))
    accept!(p, TK_COMMA) != 0 || break
  end
  local ast::ImmutableList.List{Absyn.NamedArg} = NIL
  for i::Int in length(args):-1:1
    ast = consT(Absyn.NamedArg, args[i], ast)
  end
  return ast
end

"""
    outputExpressionList(p::ParserState, isTuple::Base.RefValue{Bool})::Any

`output_expression_list`: the inside of `( ... )` up to and including `)`: one expression, or
(setting `isTuple`) the tuple elements, empty positions as `_`.
"""
function outputExpressionList(p::ParserState, isTuple::Base.RefValue{Bool})::Any
  local k::TokenKind = la(p)
  if k == TK_RPAR
    advance!(p)
    isTuple[] = true
    return NIL
  elseif k == TK_COMMA
    advance!(p)
    isTuple[] = true
    local rest1::ImmutableList.List{Absyn.Exp} = outputExpressionList(p, isTuple)
    return consT(Absyn.Exp, Absyn.CREF(Absyn.WILD()), rest1)
  end
  local e1::Absyn.Exp = expression(p, p.metaModelica)
  if la(p) == TK_COMMA
    advance!(p)
    isTuple[] = true
    local el::ImmutableList.List{Absyn.Exp} = outputExpressionList(p, isTuple)
    if !(el isa ImmutableList.Nil)
      return consT(Absyn.Exp, e1, el)
    end
    return consT(Absyn.Exp, e1, consT(Absyn.Exp, Absyn.CREF(Absyn.WILD()), el))
  end
  expect!(p, TK_RPAR, "at the end of the parenthesized expression")
  return isTuple[] ? consT(Absyn.Exp, e1, NIL) : e1
end

"""
    expressionList(p::ParserState)::ImmutableList.List{Absyn.Exp}

`expression_list`: `expression (',' expression)*`.
"""
function expressionList(p::ParserState)::ImmutableList.List{Absyn.Exp}
  local exps::Vector{Absyn.Exp} = Absyn.Exp[expression(p, p.metaModelica)]
  while accept!(p, TK_COMMA) != 0
    push!(exps, expression(p, p.metaModelica))
  end
  local ast::ImmutableList.List{Absyn.Exp} = NIL
  for i::Int in length(exps):-1:1
    ast = consT(Absyn.Exp, exps[i], ast)
  end
  return ast
end

"""
    arraySubscripts(p::ParserState)::ImmutableList.List{Absyn.Subscript}

`array_subscripts`: `'[' subscript (',' subscript)* ']'`, a subscript an expression or `:`.
"""
function arraySubscripts(p::ParserState)::ImmutableList.List{Absyn.Subscript}
  expect!(p, TK_LBRACK)
  local subs::Vector{Absyn.Subscript} = Absyn.Subscript[]
  while true
    if accept!(p, TK_COLON) != 0
      push!(subs, Absyn.NOSUB())
    else
      push!(subs, Absyn.SUBSCRIPT(expression(p, p.metaModelica)))
    end
    accept!(p, TK_COMMA) != 0 || break
  end
  expect!(p, TK_RBRACK, "at the end of the subscripts")
  local ast::ImmutableList.List{Absyn.Subscript} = NIL
  for i::Int in length(subs):-1:1
    ast = consT(Absyn.Subscript, subs[i], ast)
  end
  return ast
end

"""
    comment(p::ParserState)::Union{Nothing, Absyn.Comment}

`comment`: `string_comment annotation?` (`nothing` when neither is there).
"""
function comment(p::ParserState)::Union{Nothing, Absyn.Comment}
  local cmt::Union{Nothing, String} = stringComment(p)
  local ann::Union{Nothing, Absyn.Annotation} = la(p) == TK_ANNOTATION ? annotation(p) : nothing
  if cmt !== nothing || ann !== nothing
    local annOpt::Union{Nothing, SOME{Absyn.Annotation}} = someOrNone(ann)
    local cmtOpt::Union{Nothing, SOME{String}} = someOrNone(cmt)
    return Absyn.COMMENT(annOpt, cmtOpt)
  end
  return nothing
end

"""
    stringComment(p::ParserState)::Union{Nothing, String}

`string_comment`: `(STRING ('+' STRING)*)?`, the strings concatenated as written.
"""
function stringComment(p::ParserState)::Union{Nothing, String}
  la(p) == TK_STRING || return nothing
  local s::String = text(p, advance!(p))
  while la(p) == TK_PLUS
    advance!(p)
    s = s * text(p, expect!(p, TK_STRING, "after '+' in a description string"))
  end
  return s
end

"""
    annotation(p::ParserState)::Absyn.Annotation

`annotation`: `annotation class_modification`.
"""
function annotation(p::ParserState)::Absyn.Annotation
  expect!(p, TK_ANNOTATION)
  return Absyn.ANNOTATION(classModification(p))
end

#= Code quotation =#

"""
    codeExpression(p::ParserState)::Absyn.Exp

`code_expression`: `\$Code(...)`, `\$TypeName(...)`, `\$annotation(...)`, `\$Var(...)`.
"""
function codeExpression(p::ParserState)::Absyn.Exp
  local k::TokenKind = la(p)
  if k == TK_CODE_NAME
    advance!(p)
    expect!(p, TK_LPAR)
    local name::Absyn.Path = namePath(p)
    expect!(p, TK_RPAR)
    return Absyn.CODE(Absyn.C_TYPENAME(name))
  elseif k == TK_CODE_ANNOTATION
    advance!(p)
    local cmod::ImmutableList.List{Absyn.ElementArg} = classModification(p)
    return Absyn.CODE(Absyn.C_MODIFICATION(Absyn.CLASSMOD(cmod, Absyn.NOMOD())))
  elseif k == TK_CODE_VAR
    advance!(p)
    expect!(p, TK_LPAR)
    local cr::Absyn.ComponentRef = componentReference(p)
    expect!(p, TK_RPAR)
    return Absyn.CODE(Absyn.C_VARIABLENAME(cr))
  end
  expect!(p, TK_CODE)
  expect!(p, TK_LPAR)
  local ast::Absyn.Exp
  k = la(p)
  local k2::TokenKind = la(p, 2)
  if k == TK_EQUATION || k == TK_CONSTRAINT || k == TK_ALGORITHM ||
     (k == TK_INITIAL && (k2 == TK_EQUATION || k2 == TK_CONSTRAINT || k2 == TK_ALGORITHM))
    local initial::Bool = accept!(p, TK_INITIAL) != 0
    local section::TokenKind = la(p)
    advance!(p)
    if section == TK_ALGORITHM
      local algs::Vector{Absyn.AlgorithmItem} = Absyn.AlgorithmItem[]
      while true
        push!(algs, algorithm(p))
        expect!(p, TK_SEMICOLON)
        startsAlgorithm(la(p)) || break
      end
      local al::ImmutableList.List{Absyn.AlgorithmItem} = NIL
      for i::Int in length(algs):-1:1
        al = consT(Absyn.AlgorithmItem, algs[i], al)
      end
      ast = Absyn.CODE(Absyn.C_ALGORITHMSECTION(initial, al))
    else
      local eqs::Vector{Absyn.EquationItem} = Absyn.EquationItem[]
      while true
        push!(eqs, equation(p))
        expect!(p, TK_SEMICOLON)
        startsEquation(la(p)) || break
      end
      local eqList::ImmutableList.List{Absyn.EquationItem} = NIL
      for i::Int in length(eqs):-1:1
        eqList = consT(Absyn.EquationItem, eqs[i], eqList)
      end
      ast = section == TK_EQUATION ? Absyn.CODE(Absyn.C_EQUATIONSECTION(initial, eqList)) :
                                     Absyn.CODE(Absyn.C_CONSTRAINTSECTION(initial, eqList))
    end
  elseif k == TK_LPAR && speculateExpressionThen(p, TK_RPAR, true)
    ast = Absyn.CODE(Absyn.C_EXPRESSION(expression(p, p.metaModelica)))
  elseif k == TK_LPAR || k == TK_EQUALS || k == TK_ASSIGN
    ast = Absyn.CODE(Absyn.C_MODIFICATION(modification(p)))
  elseif speculateExpressionThen(p, TK_RPAR, false)
    ast = Absyn.CODE(Absyn.C_EXPRESSION(expression(p, p.metaModelica)))
  else
    local codeElement::Absyn.Element = element(p)
    accept!(p, TK_SEMICOLON)
    ast = Absyn.CODE(Absyn.C_ELEMENT(codeElement))
  end
  expect!(p, TK_RPAR, "at the end of the code expression")
  return ast
end

"""
    speculateExpressionThen(p::ParserState, k::TokenKind, parenthesized::Bool)::Bool

The syntactic predicates of `code_expression`: `('(' expression ')') =>` when `parenthesized`,
else `(expression k) =>`. Parses ahead and restores the position.
"""
function speculateExpressionThen(p::ParserState, k::TokenKind, parenthesized::Bool)::Bool
  local pos::Int = p.pos
  local firstComment::Int = p.firstComment
  local ok::Bool = false
  try
    if parenthesized
      expect!(p, TK_LPAR)
      expression(p, p.metaModelica)
      expect!(p, TK_RPAR)
      ok = true
    else
      expression(p, p.metaModelica)
      ok = la(p) == k
    end
  catch err
    err isa ParseError || rethrow()
    ok = false
  end
  p.pos = pos
  p.firstComment = firstComment
  return ok
end

#= MetaModelica =#

"""
    matchExpression(p::ParserState)::Absyn.Exp

`match_expression`: `(match | matchcontinue) e string_comment local_clause cases end ...`.
"""
function matchExpression(p::ParserState)::Absyn.Exp
  local ty::TokenKind = la(p)
  advance!(p)
  local exp::Absyn.Exp = expression(p, p.metaModelica)
  local cmt::Union{Nothing, String} = stringComment(p)
  local es::Union{Nothing, ImmutableList.List{Absyn.ElementItem}} = localClause(p)
  local cs::ImmutableList.List{Absyn.Case} = cases(p)
  expect!(p, ty == TK_MATCHCONTINUE ? TK_END_MATCHCONTINUE : TK_END_MATCH, "at the end of the match expression")
  return Absyn.MATCHEXP(ty == TK_MATCHCONTINUE ? Absyn.MATCHCONTINUE() : Absyn.MATCH(), exp, orNil(es), cs, someOrNone(cmt))
end

"""
    localClause(p::ParserState)::Union{Nothing, ImmutableList.List{Absyn.ElementItem}}

`local_clause`: `(local element_list)?`.
"""
function localClause(p::ParserState)::Union{Nothing, ImmutableList.List{Absyn.ElementItem}}
  accept!(p, TK_LOCAL) != 0 || return nothing
  return elementList(p, nothing)
end

"""
    caseBody(p::ParserState)::Absyn.ClassPart

The `equation ...` or `algorithm ...` part of a case (`EQUATIONS(nil)` when there is none).
"""
function caseBody(p::ParserState)::Absyn.ClassPart
  if accept!(p, TK_EQUATION) != 0
    return Absyn.EQUATIONS(equationListThen(p))
  elseif accept!(p, TK_ALGORITHM) != 0
    return Absyn.ALGORITHMS(algorithmAnnotationList(p, nothing, true))
  end
  return Absyn.EQUATIONS(NIL)
end

"""
    cases(p::ParserState)::ImmutableList.List{Absyn.Case}

`cases` and `cases2`: `onecase+ (else ...)?`.
"""
function cases(p::ParserState)::ImmutableList.List{Absyn.Case}
  local cs::Vector{Absyn.Case} = Absyn.Case[]
  la(p) == TK_CASE || expectedError(p, "'case'")
  while la(p) == TK_CASE
    push!(cs, onecase(p))
  end
  local tail::ImmutableList.List{Absyn.Case} = NIL
  if la(p) == TK_ELSE
    tail = elseCase(p)
  end
  local ast::ImmutableList.List{Absyn.Case} = tail
  for i::Int in length(cs):-1:1
    ast = consT(Absyn.Case, cs[i], ast)
  end
  return ast
end

"""
    elseCaseHasBody(p::ParserState)::Bool

After `else`: the optional `string_comment local_clause (equation|algorithm ...)? then` comes
(not just the result expression).
"""
function elseCaseHasBody(p::ParserState)::Bool
  local i::Int = p.pos
  local kinds::Vector{TokenKind} = p.kinds
  local n::Int = length(kinds)
  if i <= n && kinds[i] == TK_STRING
    i += 1
    while i + 1 <= n && kinds[i] == TK_PLUS && kinds[i + 1] == TK_STRING
      i += 2
    end
  end
  i <= n || return false
  local k::TokenKind = kinds[i]
  return k == TK_LOCAL || k == TK_EQUATION || k == TK_ALGORITHM || k == TK_THEN
end

"""
    elseCase(p::ParserState)::ImmutableList.List{Absyn.Case}

The `else` case of `cases2`.
"""
function elseCase(p::ParserState)::ImmutableList.List{Absyn.Case}
  local start::Int = expect!(p, TK_ELSE)
  local el::Int = start
  local cmt::Union{Nothing, String} = nothing
  local es::Union{Nothing, ImmutableList.List{Absyn.ElementItem}} = nothing
  local body::Absyn.ClassPart = Absyn.EQUATIONS(NIL)
  if elseCaseHasBody(p)
    cmt = stringComment(p)
    es = localClause(p)
    body = caseBody(p)
    el = expect!(p, TK_THEN, "before the result of the else case")
  end
  local exp::Absyn.Exp = expression(p, p.metaModelica)
  expect!(p, TK_SEMICOLON, "after the result of the else case")
  local c::Absyn.Case = Absyn.ELSE(orNil(es), body, exp, info(p, el), someOrNone(cmt), info(p, start))
  return consT(Absyn.Case, c, NIL)
end

"""
    onecase(p::ParserState)::Absyn.Case

`onecase`: `case pattern ((if|guard) e)? string_comment local_clause (equation ...|algorithm ...)?
then e ';'`.
"""
function onecase(p::ParserState)::Absyn.Case
  local start::Int = expect!(p, TK_CASE)
  local patStart::Int = p.pos
  local pat::Absyn.Exp = expression(p, false)
  local patInfo::MetaModelica.SourceInfo = info(p, patStart)
  local guard::Union{Nothing, Absyn.Exp} = nothing
  if la(p) == TK_IF || la(p) == TK_GUARD
    advance!(p)
    guard = expression(p, p.metaModelica)
  end
  local cmt::Union{Nothing, String} = stringComment(p)
  local es::Union{Nothing, ImmutableList.List{Absyn.ElementItem}} = localClause(p)
  local body::Absyn.ClassPart = caseBody(p)
  local th::Int = expect!(p, TK_THEN, "before the result of the case")
  local exp::Absyn.Exp = expression(p, p.metaModelica)
  expect!(p, TK_SEMICOLON, "after the result of the case")
  return Absyn.CASE(pat, someOf(Absyn.Exp, guard), patInfo, orNil(es), body, exp, info(p, th), someOrNone(cmt), info(p, start))
end

#= Entry =#

"""
    parseSource(source::String, fileName::String, acceptedGram::Int, langStd::Int, readOnly::Bool)::Absyn.Program

Tokenize and parse a Modelica (or MetaModelica, ...) source. Throws a `ParseError`.
"""
function parseSource(source::String, fileName::String, acceptedGram::Int, langStd::Int, readOnly::Bool)::Absyn.Program
  local dialect::Dialect = Dialect(acceptedGram, langStd)
  local ts::Tokens = tokenize(source, fileName, dialect)
  local p::ParserState = ParserState(ts, dialect, readOnly)
  return storedDefinition(p)
end
