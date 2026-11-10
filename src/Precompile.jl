#=
Precompile workload: sources that use the rules of every grammar, so the first parse in a session
runs compiled code.
=#

import PrecompileTools

"""
Modelica source for the precompile workload: classes of every kind, modifications, imports,
equations, algorithms and expressions.
"""
const WORKLOAD_MODELICA = """
within Lib.Sub;
encapsulated package P "A package" // comment
  import Modelica.Units.SI;
  import SI2 = Modelica.Units.SI;
  import Modelica.Math.*;
  import Modelica.Math.{sin, cos};
  type Voltage = Real(unit = "V", min = -1e3, max = 1.0E+3) "voltage";
  type E = enumeration(a "first", b, c) annotation(Evaluate = true);
  type E2 = enumeration(:);
  type A3 = Real[3];
  connector Pin
    Voltage v;
    flow Real i;
    stream Real h;
  end Pin;
  expandable connector Bus end Bus;
  record R
    parameter Real a = 1;
    constant Integer n(min = 0) = 2;
    discrete Boolean b;
  end R;
  operator record Complex
    Real re, im;
    encapsulated operator '+'
      function add input Complex a; input Complex b; output Complex c; algorithm c := Complex(a.re + b.re, a.im + b.im); end add;
    end '+';
  end Complex;
  partial model Base
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium constrainedby Modelica.Media.Interfaces.PartialMedium(nX = 2) "medium" annotation(choicesAllMatching = true);
    replaceable model M = Base;
    input Real u;
    output Real y;
    Pin p, n;
  protected
    Real z;
  public
    annotation(Icon(graphics = {Line(points = {{-100, 0}, {100, 0}}, color = {0, 0, 255})}));
  end Base;
  model M2 "a model"
    extends Base(redeclare package Medium = Medium2, final u = 1, y(start = 0, fixed = true)) annotation(Dialog);
    extends Base2(break x, break connect(a.p, b.n));
    redeclare model extends M end M;
    inner outer Real io;
    parameter Real k[2, 3] = [1, 2, 3; 4, 5, 6];
    parameter Integer m = if k[1, 1] > 0 then 1 elseif k[1, 2] < 0 then 2 else 3;
    Real x(start = 1.5, each fixed = false) = 2 if m == 1;
    Real v[3] = {i ^ 2 for i in 1:3};
    Real w[:] = cat(1, v, {1, 2}) annotation(HideResult = true);
    final parameter String s = "a \\"quoted\\" string" + "\\n";
    Boolean bo = not true and false or x <= 2 and x >= 1 and x <> 3 and x == 3 and x < 4 and x > 0;
    replaceable Pin pin constrainedby Pin;
    Pin pins[2](each v = 0);
    Real 'quoted name' = -x .* 2 ./ 3 .+ 1 .- 2 .^ 2;
    Real r = sum(v[i] for i in 1:3) + pure(f(time)) + ({1, 2, 3})[2] + v[end] + v[2:end - 1] * v[1];
    Real fc = g(1, function h(a = 2), named = 3);
  initial equation
    x = 1;
  equation
    der(x) = -x + u;
    connect(p, n) annotation(Line(points = {{0, 0}, {1, 1}}));
    connect(pins[1], pin);
    if x > 0 then
      y = 1;
    elseif x < 0 then
      y = -1;
    else
      y = 0;
    end if;
    for i in 1:2, j in 1:3 loop
      pins[i].i = 0;
    end for;
    when {sample(0, 0.1), initial()} then
      reinit(x, 0);
    elsewhen x > 2 then
      assert(x < 3, "too large", AssertionLevel.warning);
    end when;
    (a, b) = f2(x);
    terminate("done");
  algorithm
    z := x;
    (z, _) := f2(x);
    for i in 1:3 loop
      if i == 2 then
        break;
      elseif i > 2 then
        return;
      end if;
    end for;
    while z > 0 loop
      z := z - 1;
    end while;
    when sample(0, 1) then
      z := pre(z);
    end when;
  annotation(experiment(StopTime = 1, Tolerance = 1e-6), Documentation(info = "<html></html>"));
  end M2;
  block B = M2(x = 3) "short";
  function F "a function"
    input Real a[:];
    input Real b = 2;
    output Real c;
    output Real d;
  protected
    Real t;
  algorithm
    c := a[1] * b;
    d := size(a, 1);
    annotation(derivative = F_der, Inline = true);
  end F;
  pure function G
    input Real x;
    output Real y;
  external "C" y = ext_g(x) annotation(Library = "g", Include = "#include \\"g.h\\"");
  end G;
  impure function H external "C"; end H;
  function D = der(F, a) "derivative";
  model Cond
    parameter Boolean use_p = false;
    Pin p if use_p;
  end Cond;
  class Cl end Cl;
  optional_name_test X;
end P;
"""

"""
MetaModelica source for the precompile workload: uniontypes, match expressions, patterns, lists,
tuples, try, polymorphic types.
"""
const WORKLOAD_METAMODELICA = """
encapsulated package Q
  import List;
  protected import Util;
  uniontype U "u"
    record A Integer i; end A;
    record B list<U> l; Option<String> o; tuple<Integer, Real> t; end B;
  end U;
  type T = list<Integer>;
  function f<T> "polymorphic"
    input list<T> l;
    input U u;
    output Integer n;
  protected
    Integer i;
  algorithm
    n := match (l, u)
      local Integer k; T h; list<T> rest;
      case ({}, _) then 0;
      case (h :: rest, A(i = k)) guard k > 0 then k + f(rest, u);
      case (_ :: _, B(l = {A(k)})) equation k = 1; then k;
      case (_, b as B()) algorithm i := 2; then i;
      else 3;
    end match;
    n := matchcontinue l
      case {} then fail();
      else 1;
    end matchcontinue;
    try
      i := listLength(l);
    else
      i := 0;
    end try;
    (n, i) := (i, n);
    n := if true then 1 else 2;
    _ := SOME(1);
    _ := NONE();
    _ := {1, 2};
    _ := (1, "s");
    _ := Code(x + 1);
  end f;
  function g
    input Integer x;
    output Integer y = x;
  algorithm
    for e in {1, 2} loop y := y + e; end for;
  end g;
end Q;
"""

"""
Optimica source for the precompile workload (class attributes, constraints).
"""
const WORKLOAD_OPTIMICA = """
optimization Opt(objective = cost(finalTime), startTime = 0, finalTime = 1)
  Real cost;
  input Real u;
equation
  der(cost) = u ^ 2;
constraint
  u <= 1;
  u >= -1;
end Opt;
"""

"""
PDEModelica source for the precompile workload (fields, `pder`, `indomain`).
"""
const WORKLOAD_PDEMODELICA = """
model Heat
  parameter DomainLineSegment1D omega;
  field Real T(domain = omega);
equation
  pder(T, time) = pder(T, x) indomain omega.interior;
  T = 0 indomain omega.left;
end Heat;
"""

PrecompileTools.@compile_workload begin
  parseString(WORKLOAD_MODELICA, "<precompile>", 1, 1000)
  parseString(WORKLOAD_METAMODELICA, "<precompile>", 2, 9999)
  parseString(WORKLOAD_OPTIMICA, "<precompile>", 4, 1000)
  parseString(WORKLOAD_PDEMODELICA, "<precompile>", 5, 1000)
  for bad::String in ("model M\n  Real x\nend M;\n", "model M Real x = ; end M;", "model M \"open")
    try
      parseString(bad, "<precompile>")
    catch err
      err isa ParseError && sprint(showerror, err)
    end
  end
  #= @Modelica: its two expansions, and the parse of a text from a line of a file on. =#
  modelicaLiteral("model M\n  Real x;\nend M;\n", LineNumberNode(1, Symbol("<precompile>")))
  modelicaInterpolated(Any["model ", :M, " end ", :M, ";"], LineNumberNode(1, Symbol("<precompile>")))
  modelicaProgram("model M end M;", "<precompile>", 2)
  precompile(parseFile, (String,))
  precompile(parseFile, (String, Int64))
  precompile(parseFile, (String, Int64, Int64))
end
