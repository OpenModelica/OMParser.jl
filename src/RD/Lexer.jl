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

"""
    Dialect

The grammar flags of one parse: MetaModelica (lexer and grammar), Optimica and PDEModelica
(keywords and grammar), and the language standard (`langStd`, 1000 = latest).
`keywords` and `endWords` are the keyword tables of the lexer for these flags.
"""
struct Dialect
  metaModelica::Bool
  optimica::Bool
  pdeModelica::Bool
  langStd::Int
  keywords::Dict{UInt128, TokenKind}
  endWords::Dict{UInt128, TokenKind}
end

"""
    keywordTable(metaModelica::Bool, optimica::Bool, pdeModelica::Bool)::Dict{UInt128, TokenKind}

The keywords of the lexer selected by the flags: the base keywords, `pure` (Modelica 3 lexer) or
the MetaModelica keywords, and the Optimica and PDEModelica keywords when on.
"""
function keywordTable(metaModelica::Bool, optimica::Bool, pdeModelica::Bool)::Dict{UInt128, TokenKind}
  local table::Dict{UInt128, TokenKind} = copy(BASE_KEYWORDS)
  merge!(table, metaModelica ? METAMODELICA_KEYWORDS : MODELICA_KEYWORDS)
  optimica && merge!(table, OPTIMICA_KEYWORDS)
  pdeModelica && merge!(table, PDEMODELICA_KEYWORDS)
  return table
end

"""
The keyword tables for the eight flag combinations, index `1 + mm + 2 opt + 4 pde`.
"""
const KEYWORD_TABLES = Dict{UInt128, TokenKind}[keywordTable(isodd(i), isodd(i >> 1), isodd(i >> 2)) for i in 0:7]

"""
The composite `end` words of the Modelica 3 lexer and of the MetaModelica lexer.
"""
const END_WORD_TABLES = Dict{UInt128, TokenKind}[END_WORDS, merge(END_WORDS, METAMODELICA_END_WORDS)]

"""
    Dialect(acceptedGram::Int, langStd::Int)

The dialect of the `acceptedGram` argument of `parseFile`/`parseString`: 1 Modelica,
2 MetaModelica, 3 ParModelica (the Modelica grammar), 4 Optimica, 5 PDEModelica.
"""
function Dialect(acceptedGram::Int, langStd::Int)
  local mm::Bool = acceptedGram == 2
  local opt::Bool = acceptedGram == 4
  local pde::Bool = acceptedGram == 5
  local index::Int = 1 + Int(mm) + 2 * Int(opt) + 4 * Int(pde)
  return Dialect(mm, opt, pde, langStd, KEYWORD_TABLES[index], END_WORD_TABLES[1 + Int(mm)])
end

"""
    SyntaxError <: Exception

A lexical or syntax error: where it is (file, line, column of the first character, 1-based) and
what is wrong. `sourceLine` is the text of the line, shown with a caret under the column.
"""
struct SyntaxError <: Exception
  fileName::String
  line::Int
  column::Int
  message::String
  sourceLine::String
end

function Base.showerror(io::IO, err::SyntaxError)
  print(io, err.fileName, ":", err.line, ":", err.column, ": ", err.message)
  if !isempty(err.sourceLine)
    local shown::String = replace(err.sourceLine, '\t' => ' ')
    print(io, "\n  ", shown, "\n  ", " "^max(0, err.column - 1), "^")
  end
end

"""
    Tokens

The tokens of one source, as parallel arrays (one entry per token, the last one `TK_EOF`), and its
comments. Positions are byte offsets into `source` (1-based). `line` and `rawColumn` are the
token's line and ANTLR character position (see `rawColumn`), which `SourceInfo`s are made from.
The text of a token is `source[textStart:textStop]`: the identifier, the literal, the name after
`end` of `TK_END_IDENT`, the contents of a string literal without the quotes.
Comment `c` (`//` with its newline, or `/* */`) is before token `commentNext[c]`.
"""
struct Tokens
  source::String
  fileName::String
  kind::Vector{TokenKind}
  start::Vector{Int32}
  textStart::Vector{Int32}
  textStop::Vector{Int32}
  line::Vector{Int32}
  rawColumn::Vector{Int32}
  commentStart::Vector{Int32}
  commentStop::Vector{Int32}
  commentNext::Vector{Int32}
end

"""
    tokenText(ts::Tokens, i::Int)::String

The text of token `i` (see `Tokens`).
"""
function tokenText(ts::Tokens, i::Int)::String
  return substringOf(ts.source, Int(@inbounds ts.textStart[i]), Int(@inbounds ts.textStop[i]))
end

"""
    commentText(ts::Tokens, c::Int)::String

The text of comment `c`, delimiters and the newline ending a `//` comment included.
"""
function commentText(ts::Tokens, c::Int)::String
  return substringOf(ts.source, Int(@inbounds ts.commentStart[c]), Int(@inbounds ts.commentStop[c]))
end

"""
    substringOf(s::String, a::Int, b::Int)::String

The bytes `a:b` of `s` as a new `String` (the bytes as they are, valid UTF-8 or not).
"""
function substringOf(s::String, a::Int, b::Int)::String
  local n::Int = b - a + 1
  n <= 0 && return ""
  return GC.@preserve s unsafe_string(pointer(s, a), n)
end

@inline isDigit(b::UInt8)::Bool = 0x30 <= b <= 0x39
@inline isIdentStart(b::UInt8)::Bool = (0x61 <= b <= 0x7a) || (0x41 <= b <= 0x5a) || b == 0x5f
@inline isIdentChar(b::UInt8)::Bool = isIdentStart(b) || isDigit(b)
@inline isSpace(b::UInt8)::Bool = b == 0x20 || b == 0x09 || b == 0x0a || b == 0x0d

"""
    isQChar(b::UInt8)::Bool

A character of a quoted identifier (`QCHAR`): printable ASCII except `"`, `'`, `\\` and `` ` ``.
"""
@inline isQChar(b::UInt8)::Bool = 0x20 <= b <= 0x7e && b != 0x22 && b != 0x27 && b != 0x5c && b != 0x60

"""
    isEscapeChar(b::UInt8)::Bool

A character after `\\` that forms an escape sequence (`SESCAPE`): `\\ " ' ? a b f n r t v`.
"""
@inline function isEscapeChar(b::UInt8)::Bool
  return b == UInt8('\\') || b == UInt8('"') || b == UInt8('\'') || b == UInt8('?') || b == UInt8('a') ||
         b == UInt8('b') || b == UInt8('f') || b == UInt8('n') || b == UInt8('r') || b == UInt8('t') ||
         b == UInt8('v')
end

"""
    packBytes(cu::Base.CodeUnits{UInt8, String}, a::Int, b::Int)::UInt128

The bytes `a:b` packed as `packWord` does, or zero when there are more than 16 (no keyword).
"""
@inline function packBytes(cu::Base.CodeUnits{UInt8, String}, a::Int, b::Int)::UInt128
  b - a + 1 > 16 && return UInt128(0)
  local k::UInt128 = UInt128(0)
  local shift::Int = 0
  for j::Int in a:b
    k |= UInt128(@inbounds cu[j]) << shift
    shift += 8
  end
  return k
end

"""
    sourceLineAt(source::String, pos::Int)::String

The line of `source` that byte `pos` is on, without its newline.
"""
function sourceLineAt(source::String, pos::Int)::String
  local cu::Base.CodeUnits{UInt8, String} = codeunits(source)
  local n::Int = length(cu)
  pos = clamp(pos, 1, max(n, 1))
  n == 0 && return ""
  local a::Int = pos
  while a > 1 && cu[a - 1] != 0x0a
    a -= 1
  end
  local b::Int = pos
  while b <= n && cu[b] != 0x0a && cu[b] != 0x0d
    b += 1
  end
  return substringOf(source, a, b - 1)
end

"""
    displayColumn(source::String, lineStart::Int, pos::Int)::Int

The 1-based column of byte `pos` for error messages: characters (not bytes) since the line start.
"""
function displayColumn(source::String, lineStart::Int, pos::Int)::Int
  local col::Int = 1
  local cu::Base.CodeUnits{UInt8, String} = codeunits(source)
  for j::Int in lineStart:(min(pos, length(cu) + 1) - 1)
    #= Count the bytes that start a UTF-8 character. =#
    (cu[j] & 0xc0) != 0x80 && (col += 1)
  end
  return col
end

"""
    lexError(source::String, fileName::String, line::Int, lineStart::Int, pos::Int, message::String)

Throw the `SyntaxError` of a lexical error at byte `pos` on `line` (which starts at `lineStart`).
"""
function lexError(source::String, fileName::String, line::Int, lineStart::Int, pos::Int, message::String)
  throw(SyntaxError(fileName, line, displayColumn(source, lineStart, pos), message, sourceLineAt(source, pos)))
end

"""
    describeByte(cu::Base.CodeUnits{UInt8, String}, i::Int)::String

The character at byte `i` for an error message.
"""
function describeByte(cu::Base.CodeUnits{UInt8, String}, i::Int)::String
  local b::UInt8 = cu[i]
  if b < 0x80
    return b < 0x20 || b == 0x7f ? "byte 0x" * string(b; base = 16, pad = 2) : "'" * Char(b) * "'"
  end
  return "byte 0x" * string(b; base = 16, pad = 2) * " (non-ASCII characters are only allowed in strings, quoted names and comments)"
end

"""
    tokenize(source::String, fileName::String, dialect::Dialect)::Tokens

Split `source` into tokens as the ANTLR lexers do (`Modelica_3_Lexer`, or `MetaModelica_Lexer`
for MetaModelica). Whitespace is skipped, comments are kept apart. Throws a `SyntaxError` for
input the lexers reject (an unknown character, an unterminated string or comment, `&&`, `||`,
`!`, an exponent without digits).
"""
function tokenize(source::String, fileName::String, dialect::Dialect)::Tokens
  local cu::Base.CodeUnits{UInt8, String} = codeunits(source)
  local n::Int = length(cu)
  local guess::Int = n ÷ 5 + 16
  local kinds::Vector{TokenKind} = TokenKind[]
  local starts::Vector{Int32} = Int32[]
  local textStarts::Vector{Int32} = Int32[]
  local textStops::Vector{Int32} = Int32[]
  local lines::Vector{Int32} = Int32[]
  local columns::Vector{Int32} = Int32[]
  sizehint!(kinds, guess); sizehint!(starts, guess); sizehint!(textStarts, guess)
  sizehint!(textStops, guess); sizehint!(lines, guess); sizehint!(columns, guess)
  local commentStarts::Vector{Int32} = Int32[]
  local commentStops::Vector{Int32} = Int32[]
  local commentNexts::Vector{Int32} = Int32[]
  local keywords::Dict{UInt128, TokenKind} = dialect.keywords
  local endWords::Dict{UInt128, TokenKind} = dialect.endWords
  local mm::Bool = dialect.metaModelica
  local i::Int = 1
  local line::Int = 1
  local lineStart::Int = 1
  #= Token fields of the token being scanned. =#
  local kind::TokenKind = TK_EOF
  local tokStart::Int = 1
  local tokLine::Int = 1
  local tokColumn::Int = 0
  local textStart::Int = 1
  local textStop::Int = 0
  local j::Int = 0
  local k::Int = 0
  local m::Int = 0
  local kLine::Int = 0
  local kLineStart::Int = 0
  local word::Int = 0
  local closed::Bool = false
  local c::UInt8 = 0x00
  while true
    #= Whitespace =#
    while i <= n
      local w::UInt8 = @inbounds cu[i]
      if w == 0x0a
        line += 1
        lineStart = i + 1
      elseif !(w == 0x20 || w == 0x09 || w == 0x0d)
        break
      end
      i += 1
    end
    tokStart = i
    tokLine = line
    tokColumn = (i - lineStart) - (line == 1 ? 1 : 0)
    if i > n
      push!(kinds, TK_EOF); push!(starts, Int32(i)); push!(textStarts, Int32(i)); push!(textStops, Int32(i - 1))
      push!(lines, Int32(tokLine)); push!(columns, Int32(tokColumn))
      break
    end
    local b::UInt8 = @inbounds cu[i]
    textStart = i
    if isIdentStart(b)
      j = i + 1
      while j <= n && isIdentChar(@inbounds cu[j])
        j += 1
      end
      textStop = j - 1
      kind = get(keywords, packBytes(cu, i, j - 1), TK_IDENT)
      if kind == TK_IDENT && j - i == 3 && b == UInt8('e') && cu[i + 1] == UInt8('n') && cu[i + 2] == UInt8('d')
        #= `end`, `end <name>`, `end if`, ... (whitespace only between the words) =#
        kind = TK_END
        k = j
        kLine = line
        kLineStart = lineStart
        while k <= n && isSpace(@inbounds cu[k])
          if cu[k] == 0x0a
            kLine += 1
            kLineStart = k + 1
          end
          k += 1
        end
        if k > j && k <= n
          c = @inbounds cu[k]
          m = 0
          if isIdentStart(c)
            m = k + 1
            while m <= n && isIdentChar(@inbounds cu[m])
              m += 1
            end
            kind = get(endWords, packBytes(cu, k, m - 1), TK_END_IDENT)
          elseif c == UInt8('\'')
            m = scanQuotedIdent(source, fileName, cu, k, kLine, kLineStart)
            kind = TK_END_IDENT
          elseif c == UInt8('$')
            word = dollarWord(cu, k)
            if word == 1 || word == 7
              #= `$Code` and `$cpuTime` =#
              m = k + (word == 1 ? 5 : 8)
              kind = TK_END_IDENT
            end
          end
          if kind != TK_END
            textStart = k
            textStop = m - 1
            j = m
          end
        end
        if kind == TK_END
          #= `end` takes the whitespace after it. =#
          j = k
        end
        line = kLine
        lineStart = kLineStart
      elseif kind == TK_IDENT && j - i == 5 && packBytes(cu, i, j - 1) == BEGIN_WORD
        #= `begin modification` =#
        k = j
        kLine = line
        kLineStart = lineStart
        while k <= n && isSpace(@inbounds cu[k])
          if cu[k] == 0x0a
            kLine += 1
            kLineStart = k + 1
          end
          k += 1
        end
        if k > j && k + 11 <= n && packBytes(cu, k, k + 11) == MODIFICATION_WORD
          kind = TK_BEGIN_MODIFICATION
          j = k + 12
          line = kLine
          lineStart = kLineStart
        end
      end
      i = j
    elseif isDigit(b)
      kind = TK_UNSIGNED_INTEGER
      j = i + 1
      while j <= n && isDigit(@inbounds cu[j])
        j += 1
      end
      if j <= n && cu[j] == UInt8('.')
        kind = TK_UNSIGNED_REAL
        j += 1
        while j <= n && isDigit(@inbounds cu[j])
          j += 1
        end
      end
      if j <= n && (cu[j] == UInt8('e') || cu[j] == UInt8('E'))
        kind = TK_UNSIGNED_REAL
        j = scanExponent(source, fileName, cu, j, line, lineStart)
      end
      textStop = j - 1
      i = j
    else
      i += 1
      if b == UInt8('.')
        kind = TK_DOT
        if i <= n
          c = @inbounds cu[i]
          if isDigit(c)
            kind = TK_UNSIGNED_REAL
            while i <= n && isDigit(@inbounds cu[i])
              i += 1
            end
            if i <= n && (cu[i] == UInt8('e') || cu[i] == UInt8('E'))
              i = scanExponent(source, fileName, cu, i, line, lineStart)
            end
          elseif c == UInt8('+')
            kind = TK_PLUS_EW; i += 1
          elseif c == UInt8('-')
            kind = TK_MINUS_EW; i += 1
          elseif c == UInt8('*')
            kind = TK_STAR_EW; i += 1
          elseif c == UInt8('/')
            kind = TK_SLASH_EW; i += 1
          elseif c == UInt8('^')
            kind = TK_POWER_EW; i += 1
          end
        end
      elseif b == UInt8('(')
        kind = TK_LPAR
      elseif b == UInt8(')')
        kind = TK_RPAR
      elseif b == UInt8('[')
        kind = TK_LBRACK
      elseif b == UInt8(']')
        kind = TK_RBRACK
      elseif b == UInt8('{')
        kind = TK_LBRACE
      elseif b == UInt8('}')
        kind = TK_RBRACE
      elseif b == UInt8(',')
        kind = TK_COMMA
      elseif b == UInt8(';')
        kind = TK_SEMICOLON
      elseif b == UInt8('+')
        kind = TK_PLUS
      elseif b == UInt8('-')
        kind = TK_MINUS
      elseif b == UInt8('*')
        kind = TK_STAR
      elseif b == UInt8('^')
        kind = TK_POWER
      elseif b == UInt8('=')
        kind = TK_EQUALS
        if i <= n && cu[i] == UInt8('=')
          kind = TK_EQEQ; i += 1
        elseif i <= n && cu[i] == UInt8('>')
          kind = TK_IMPLIES; i += 1
        end
      elseif b == UInt8(':')
        kind = TK_COLON
        if i <= n && cu[i] == UInt8('=')
          kind = TK_ASSIGN; i += 1
        elseif mm && i <= n && cu[i] == UInt8(':')
          kind = TK_COLONCOLON; i += 1
        end
      elseif b == UInt8('<')
        kind = TK_LESS
        if i <= n && cu[i] == UInt8('=')
          kind = TK_LESSEQ; i += 1
        elseif i <= n && cu[i] == UInt8('>')
          kind = TK_LESSGT; i += 1
        end
      elseif b == UInt8('>')
        kind = TK_GREATER
        if i <= n && cu[i] == UInt8('=')
          kind = TK_GREATEREQ; i += 1
        end
      elseif b == UInt8('/')
        kind = TK_SLASH
        if i <= n && cu[i] == UInt8('/')
          #= `//` comment, up to and including the newline =#
          j = i + 1
          while j <= n && cu[j] != 0x0a && cu[j] != 0x0d
            j += 1
          end
          if j <= n
            if cu[j] == 0x0d && j + 1 <= n && cu[j + 1] == 0x0a
              j += 1
            end
            if cu[j] == 0x0a
              line += 1
              lineStart = j + 1
            end
            j += 1
          end
          push!(commentStarts, Int32(tokStart)); push!(commentStops, Int32(j - 1))
          push!(commentNexts, Int32(length(kinds) + 1))
          i = j
          continue
        elseif i <= n && cu[i] == UInt8('*')
          j = i + 1
          closed = false
          while j <= n
            c = @inbounds cu[j]
            if c == UInt8('*') && j + 1 <= n && cu[j + 1] == UInt8('/')
              closed = true
              j += 2
              break
            elseif c == 0x0a
              line += 1
              lineStart = j + 1
            end
            j += 1
          end
          closed || lexError(source, fileName, tokLine, tokStart - tokColumn - (tokLine == 1 ? 1 : 0), tokStart,
                             "Unterminated comment: '/*' without '*/'")
          push!(commentStarts, Int32(tokStart)); push!(commentStops, Int32(j - 1))
          push!(commentNexts, Int32(length(kinds) + 1))
          i = j
          continue
        end
      elseif b == UInt8('"')
        kind = TK_STRING
        textStart = i
        closed = false
        while i <= n
          c = @inbounds cu[i]
          if c == UInt8('"')
            closed = true
            break
          elseif c == UInt8('\\')
            if i + 1 <= n && isEscapeChar(cu[i + 1])
              i += 1
            end
          elseif c == 0x0a
            line += 1
            lineStart = i + 1
          end
          i += 1
        end
        closed || lexError(source, fileName, tokLine, tokStart - tokColumn - (tokLine == 1 ? 1 : 0), tokStart,
                           "Unterminated string: '\"' without a closing '\"'")
        textStop = i - 1
        i += 1
        textStart = tokStart + 1
      elseif b == UInt8('\'')
        kind = TK_IDENT
        i = scanQuotedIdent(source, fileName, cu, tokStart, line, lineStart)
      elseif b == UInt8('$')
        word = dollarWord(cu, tokStart)
        word == 0 && lexError(source, fileName, line, lineStart, tokStart, "Unknown token starting with '\$'")
        kind = DOLLAR_KINDS[word]
        i = tokStart + length(DOLLAR_WORDS[word])
      elseif b == 0xef && i + 1 <= n && cu[i] == 0xbb && cu[i + 1] == 0xbf
        kind = TK_BOM
        i += 2
      elseif b == UInt8('%') && mm
        kind = TK_MOD
      elseif b == UInt8('&') && i <= n && cu[i] == UInt8('&')
        lexError(source, fileName, line, lineStart, tokStart, "Please use 'and' for logical and since '&&' is not a valid Modelica construct.")
      elseif b == UInt8('|') && i <= n && cu[i] == UInt8('|')
        lexError(source, fileName, line, lineStart, tokStart, "Please use 'or' for logical or since '||' is not a valid Modelica construct.")
      elseif b == UInt8('!')
        lexError(source, fileName, line, lineStart, tokStart, "Please use 'not' for logical not since '!' is not a valid Modelica construct.")
      else
        lexError(source, fileName, line, lineStart, tokStart, "Unexpected character " * describeByte(cu, tokStart))
      end
      if kind != TK_STRING
        textStop = i - 1
      end
    end
    push!(kinds, kind); push!(starts, Int32(tokStart)); push!(textStarts, Int32(textStart))
    push!(textStops, Int32(textStop)); push!(lines, Int32(tokLine)); push!(columns, Int32(tokColumn))
  end
  return Tokens(source, fileName, kinds, starts, textStarts, textStops, lines, columns,
                commentStarts, commentStops, commentNexts)
end

const BEGIN_WORD = packWord("begin")
const MODIFICATION_WORD = packWord("modification")

"""
The words starting with `\$` and their tokens (`\$cpuTime` is an identifier).
"""
const DOLLAR_WORDS = String["\$Code", "\$TypeName", "\$Exp", "\$annotation", "\$Var", "\$overload", "\$cpuTime"]
const DOLLAR_KINDS = TokenKind[TK_CODE, TK_CODE_NAME, TK_CODE_EXP, TK_CODE_ANNOTATION, TK_CODE_VAR, TK_OVERLOAD, TK_IDENT]

"""
    dollarWord(cu::Base.CodeUnits{UInt8, String}, i::Int)::Int

The index in `DOLLAR_WORDS` of the word starting at byte `i`, or 0.
"""
function dollarWord(cu::Base.CodeUnits{UInt8, String}, i::Int)::Int
  local n::Int = length(cu)
  for w::Int in eachindex(DOLLAR_WORDS)
    local word::String = DOLLAR_WORDS[w]
    local m::Int = ncodeunits(word)
    if i + m - 1 <= n
      local same::Bool = true
      for j::Int in 1:m
        if cu[i + j - 1] != codeunit(word, j)
          same = false
          break
        end
      end
      same && return w
    end
  end
  return 0
end

"""
    scanExponent(source, fileName, cu, j, line, lineStart)::Int

Scan the exponent starting at `e`/`E` at byte `j` (the lexers require digits after it) and return
the byte after it.
"""
function scanExponent(source::String, fileName::String, cu::Base.CodeUnits{UInt8, String}, j::Int,
                      line::Int, lineStart::Int)::Int
  local n::Int = length(cu)
  local k::Int = j + 1
  if k <= n && (cu[k] == UInt8('+') || cu[k] == UInt8('-'))
    k += 1
  end
  (k <= n && isDigit(cu[k])) || lexError(source, fileName, line, lineStart, j, "Expected digits in the exponent of a number")
  while k <= n && isDigit(@inbounds cu[k])
    k += 1
  end
  return k
end

"""
    scanQuotedIdent(source, fileName, cu, i, line, lineStart)::Int

Scan the quoted identifier starting at `'` at byte `i` and return the byte after the closing `'`.
"""
function scanQuotedIdent(source::String, fileName::String, cu::Base.CodeUnits{UInt8, String}, i::Int,
                         line::Int, lineStart::Int)::Int
  local n::Int = length(cu)
  local k::Int = i + 1
  while k <= n
    local c::UInt8 = @inbounds cu[k]
    if c == UInt8('\'')
      k == i + 1 && lexError(source, fileName, line, lineStart, i, "Empty quoted identifier ''")
      return k + 1
    elseif c == UInt8('\\')
      if k + 1 <= n && isEscapeChar(cu[k + 1])
        k += 1
      end
    elseif !isQChar(c)
      lexError(source, fileName, line, lineStart, k, "Unexpected " * describeByte(cu, k) * " in a quoted identifier")
    end
    k += 1
  end
  lexError(source, fileName, line, lineStart, i, "Unterminated quoted identifier: ' without a closing '")
end
