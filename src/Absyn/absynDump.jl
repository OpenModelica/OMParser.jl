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
  Modelica pretty-printing for Absyn types.
  Used by the Dump module for error messages in NFFrontEnd.
  Reference: AbsynDumpTpl.tpl from OMCompiler/Compiler/Template/
=#

# --- Path ---

function dumpPath(p::Path)::String
  @match p begin
    FULLYQUALIFIED(__) => "." * dumpPath(p.path)
    QUALIFIED(__) => p.name * "." * dumpPath(p.path)
    IDENT(__) => p.name
    _ => "<unknown path>"
  end
end

# --- ComponentRef ---

function dumpCref(cr::ComponentRef)::String
  @match cr begin
    CREF_QUAL(__) => cr.name * dumpSubscripts(cr.subscripts) * "." * dumpCref(cr.componentRef)
    CREF_IDENT(__) => cr.name * dumpSubscripts(cr.subscripts)
    CREF_FULLYQUALIFIED(__) => "." * dumpCref(cr.componentRef)
    WILD(__) => "_"
    ALLWILD(__) => "__"
    _ => "<unknown cref>"
  end
end

# --- Subscripts ---

function dumpSubscripts(subs)::String
  local lst = collect(subs)
  isempty(lst) && return ""
  "[" * join((dumpSubscript(s) for s in lst), ", ") * "]"
end

function dumpSubscript(sub::Subscript)::String
  @match sub begin
    NOSUB(__) => ":"
    SUBSCRIPT(__) => dumpExp(sub.subscript)
    _ => "<unknown subscript>"
  end
end

# --- Expression ---

function dumpExp(exp::Exp)::String
  @match exp begin
    INTEGER(__) => string(exp.value)
    REAL(__) => exp.value
    STRING(__) => "\"" * exp.value * "\""
    BOOL(__) => exp.value ? "true" : "false"
    CREF(__) => dumpCref(exp.componentRef)
    BINARY(__) => dumpBinary(exp.exp1, exp.op, exp.exp2, dumpPrecedence(exp))
    UNARY(__) => dumpOperator(exp.op) * dumpOperand(exp.exp, dumpPrecedence(exp), true)
    LBINARY(__) => dumpBinary(exp.exp1, exp.op, exp.exp2, dumpPrecedence(exp))
    LUNARY(__) => dumpOperator(exp.op) * dumpOperand(exp.exp, dumpPrecedence(exp), true)
    RELATION(__) => dumpOperand(exp.exp1, dumpPrecedence(exp), true) * dumpOperator(exp.op) *
                    dumpOperand(exp.exp2, dumpPrecedence(exp), true)
    IFEXP(__) => begin
      local s = "if " * dumpExp(exp.ifExp) * " then " * dumpExp(exp.trueBranch)
      for (c, b) in exp.elseIfBranch
        s = s * " elseif " * dumpExp(c) * " then " * dumpExp(b)
      end
      s * " else " * dumpExp(exp.elseBranch)
    end
    CALL(__) => begin
      local fn = dumpCref(exp.function_)
      local args = dumpFunctionArgs(exp.functionArgs)
      fn * "(" * args * ")"
    end
    PARTEVALFUNCTION(__) => "function " * dumpCref(exp.function_) * "(" * dumpFunctionArgs(exp.functionArgs) * ")"
    ARRAY(__) => "{" * join((dumpExp(e) for e in exp.arrayExp), ", ") * "}"
    MATRIX(__) => "[" * join((join((dumpExp(e) for e in row), ", ") for row in exp.matrix), "; ") * "]"
    RANGE(__) => begin
      local s = dumpExp(exp.start)
      if !isnothing(exp.step)
        s = s * ":" * dumpExp(exp.step.data)
      end
      s * ":" * dumpExp(exp.stop)
    end
    TUPLE(__) => "(" * join((dumpExp(e) for e in exp.expressions), ", ") * ")"
    END(__) => "end"
    CODE(__) => "\$Code(...)"
    AS(__) => exp.id * " as " * dumpExp(exp.exp)
    CONS(__) => dumpExp(exp.head) * " :: " * dumpExp(exp.rest)
    LIST(__) => "{" * join((dumpExp(e) for e in exp.exps), ", ") * "}"
    DOT(__) => dumpExp(exp.exp) * "." * dumpExp(exp.index)
    SUBSCRIPTED_EXP(__) => "(" * dumpExp(exp.exp) * ")" * dumpSubscripts(exp.subscripts)
    EXPRESSIONCOMMENT(__) => dumpExp(exp.exp)
    _ => "<unknown exp>"
  end
end

# --- Precedence: parentheses where Modelica needs them ---

"""
How tightly an expression binds, higher is tighter: if-expressions and ranges, `or`, `and`, `not`, relations,
`+ -`, `* /`, unary `+ -`, `^`, then primaries. Unary minus binds tighter than `*` (`-a*x`, as omc prints it) and
looser than `^` (`(-a)^2`).
"""
function dumpPrecedence(exp::Exp)::Int
  if exp isa IFEXP || exp isa RANGE
    return 0
  elseif exp isa LBINARY
    return exp.op isa OR ? 1 : 2
  elseif exp isa LUNARY
    return 3
  elseif exp isa RELATION
    return 4
  elseif exp isa BINARY
    return exp.op isa Union{POW, POW_EW} ? 8 : exp.op isa Union{MUL, DIV, MUL_EW, DIV_EW} ? 6 : 5
  elseif exp isa UNARY
    return 7
  end
  return 10
end

"""An operand in parentheses when it binds looser than its operator, or as tightly with `tight`."""
function dumpOperand(exp::Exp, precedence::Int, tight::Bool)::String
  local p::Int = dumpPrecedence(exp)
  local s::String = dumpExp(exp)
  return (p < precedence || (tight && p == precedence)) ? "(" * s * ")" : s
end

"""
A binary or logical operation: the right operand in parentheses also when it binds as tightly (`a - (b - c)`) or is
a unary operation (`a + (-b)`: Modelica allows a unary operator only at the start); `^` takes no operator
expression unparenthesised on either side.
"""
function dumpBinary(exp1::Exp, op::Operator, exp2::Exp, precedence::Int)::String
  local right::String = exp2 isa UNARY ? "(" * dumpExp(exp2) * ")" : dumpOperand(exp2, precedence, true)
  return dumpOperand(exp1, precedence, precedence == 8) * dumpOperator(op) * right
end

# --- Operator ---

function dumpOperator(op::Operator)::String
  @match op begin
    ADD(__) => " + "
    SUB(__) => " - "
    MUL(__) => "*"
    DIV(__) => "/"
    POW(__) => "^"
    UPLUS(__) => "+"
    UMINUS(__) => "-"
    ADD_EW(__) => " .+ "
    SUB_EW(__) => " .- "
    MUL_EW(__) => ".*"
    DIV_EW(__) => "./"
    POW_EW(__) => ".^"
    UPLUS_EW(__) => ".+"
    UMINUS_EW(__) => ".-"
    AND(__) => " and "
    OR(__) => " or "
    NOT(__) => "not "
    LESS(__) => " < "
    LESSEQ(__) => " <= "
    GREATER(__) => " > "
    GREATEREQ(__) => " >= "
    EQUAL(__) => " == "
    NEQUAL(__) => " <> "
    _ => " <unknown op> "
  end
end

# --- FunctionArgs ---

function dumpFunctionArgs(args::FunctionArgs)::String
  @match args begin
    FUNCTIONARGS(__) => begin
      local pos = join((dumpExp(a) for a in args.args), ", ")
      local named = join((dumpNamedArg(na) for na in args.argNames), ", ")
      if !isempty(pos) && !isempty(named)
        pos * ", " * named
      elseif !isempty(pos)
        pos
      else
        named
      end
    end
    FOR_ITER_FARG(__) => begin
      local e = dumpExp(args.exp)
      local iters = join((dumpForIterator(i) for i in args.iterators), ", ")
      local thread = isa(args.iterType, THREAD) ? "threaded " : ""
      e * " " * thread * "for " * iters
    end
    _ => "<unknown args>"
  end
end

function dumpNamedArg(na::NamedArg)::String
  @match na begin
    NAMEDARG(__) => na.argName * " = " * dumpExp(na.argValue)
    _ => "<unknown named arg>"
  end
end

function dumpForIterator(it)::String
  @match it begin
    ITERATOR(__) => begin
      local s = it.name
      if !isnothing(it.guardExp)
        s = s * " guard " * dumpExp(it.guardExp.data)
      end
      if !isnothing(it.range)
        s = s * " in " * dumpExp(it.range.data)
      end
      s
    end
    _ => "<unknown iterator>"
  end
end

# --- TypeSpec ---

function dumpTypeSpec(ts::TypeSpec)::String
  @match ts begin
    TPATH(__) => begin
      local s = dumpPath(ts.path)
      if !isnothing(ts.arrayDim)
        s = s * dumpSubscripts(collect(ts.arrayDim.data))
      end
      s
    end
    TCOMPLEX(__) => begin
      local p = dumpPath(ts.path)
      local tys = join((dumpTypeSpec(t) for t in ts.typeSpecs), ", ")
      local s = p * "<" * tys * ">"
      if !isnothing(ts.arrayDim)
        s = s * dumpSubscripts(collect(ts.arrayDim.data))
      end
      s
    end
    _ => "<unknown typespec>"
  end
end

# --- Direction ---

function dumpDirection(dir::Direction)::String
  @match dir begin
    BIDIR(__) => ""
    INPUT(__) => "input "
    OUTPUT(__) => "output "
    _ => ""
  end
end
