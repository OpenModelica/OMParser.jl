using Test
using MetaModelica
import Absyn
import OMParser

#= Helper: parse a MetaModelica string.
   acceptedGram=2 selects MetaModelica, languageStandard=9999 is experimental. =#
function mmParse(code::String)::Absyn.Program
  OMParser.parseString(code, "<test>", 2, 9999)
end

#= Helper: extract the first class from a parsed program =#
function firstClass(prog::Absyn.Program)::Absyn.Class
  @match Absyn.PROGRAM(classes, _) = prog
  @match cls <| _ = classes
  cls
end

#= Helper: extract the body of the first class =#
function firstClassBody(prog::Absyn.Program)::Absyn.ClassDef
  cls = firstClass(prog)
  @match Absyn.CLASS(_, _, _, _, _, body, _) = cls
  body
end

@testset "MetaModelica: Uniontype" begin
  prog = mmParse("""
    uniontype MyOption
      record SOME
        Real value;
      end SOME;
      record NONE
      end NONE;
    end MyOption;
  """)
  cls = firstClass(prog)
  @match Absyn.CLASS(name, _, _, _, restriction, body, _) = cls
  @test name == "MyOption"
  @test restriction isa Absyn.R_UNIONTYPE
  @match Absyn.PARTS(_, _, classParts, _, _) = body
  #= Should have a PUBLIC section with two record definitions =#
  @match pub <| _ = classParts
  @match Absyn.PUBLIC(contents) = pub
  #= Two records: SOME and NONE =#
  @match item1 <| (item2 <| _) = contents
  @match Absyn.ELEMENTITEM(Absyn.ELEMENT(_, _, _, Absyn.CLASSDEF(_, someClass), _, _)) = item1
  @match Absyn.CLASS("SOME", _, _, _, Absyn.R_RECORD(), _, _) = someClass
  @match Absyn.ELEMENTITEM(Absyn.ELEMENT(_, _, _, Absyn.CLASSDEF(_, noneClass), _, _)) = item2
  @match Absyn.CLASS("NONE", _, _, _, Absyn.R_RECORD(), _, _) = noneClass
  @test true
end

@testset "MetaModelica: Match expression" begin
  prog = mmParse("""
    function testMatch
      input Integer x;
      output Integer y;
    algorithm
      y := match x
        case 1 then 10;
        case 2 then 20;
        else 0;
      end match;
    end testMatch;
  """)
  cls = firstClass(prog)
  @match Absyn.CLASS("testMatch", _, _, _, Absyn.R_FUNCTION(Absyn.FR_NORMAL_FUNCTION(Absyn.NO_PURITY())), body, _) = cls
  @match Absyn.PARTS(_, _, classParts, _, _) = body
  #= Find the algorithm section =#
  algSection = nothing
  for part in classParts
    if part isa Absyn.ALGORITHMS
      algSection = part
    end
  end
  @test algSection !== nothing
  @match Absyn.ALGORITHMS(algItems) = algSection
  @match algItem <| _ = algItems
  @match Absyn.ALGORITHMITEM(Absyn.ALG_ASSIGN(_, matchExp), _, _) = algItem
  @match Absyn.MATCHEXP(Absyn.MATCH(), _, _, cases, _) = matchExp
  #= Should have 3 cases: case 1, case 2, else =#
  @match c1 <| (c2 <| (c3 <| _)) = cases
  @test c1 isa Absyn.CASE
  @test c2 isa Absyn.CASE
  @test c3 isa Absyn.ELSE
  #= Check case 1 pattern and result =#
  @match Absyn.CASE(Absyn.INTEGER(1), _, _, _, _, Absyn.INTEGER(10), _, _, _) = c1
  @match Absyn.CASE(Absyn.INTEGER(2), _, _, _, _, Absyn.INTEGER(20), _, _, _) = c2
  @match Absyn.ELSE(_, _, Absyn.INTEGER(0), _, _, _) = c3
  @test true
end

@testset "MetaModelica: Matchcontinue expression" begin
  prog = mmParse("""
    function testMC
      input Integer x;
      output Integer y;
    algorithm
      y := matchcontinue x
        case 1 then 42;
        else 0;
      end matchcontinue;
    end testMC;
  """)
  cls = firstClass(prog)
  @match Absyn.PARTS(_, _, classParts, _, _) = firstClassBody(prog)
  algSection = nothing
  for part in classParts
    if part isa Absyn.ALGORITHMS
      algSection = part
    end
  end
  @test algSection !== nothing
  @match Absyn.ALGORITHMS(algItems) = algSection
  @match algItem <| _ = algItems
  @match Absyn.ALGORITHMITEM(Absyn.ALG_ASSIGN(_, matchExp), _, _) = algItem
  @match Absyn.MATCHEXP(Absyn.MATCHCONTINUE(), _, _, cases, _) = matchExp
  @match c1 <| (c2 <| _) = cases
  @test c1 isa Absyn.CASE
  @test c2 isa Absyn.ELSE
end

@testset "MetaModelica: List cons operator (::)" begin
  prog = mmParse("""
    function testCons
      input Integer h;
      input list<Integer> t;
      output list<Integer> result;
    algorithm
      result := h :: t;
    end testCons;
  """)
  @match Absyn.PARTS(_, _, classParts, _, _) = firstClassBody(prog)
  algSection = nothing
  for part in classParts
    if part isa Absyn.ALGORITHMS
      algSection = part
    end
  end
  @test algSection !== nothing
  @match Absyn.ALGORITHMS(algItems) = algSection
  @match algItem <| _ = algItems
  @match Absyn.ALGORITHMITEM(Absyn.ALG_ASSIGN(_, consExp), _, _) = algItem
  @match Absyn.CONS(head, rest) = consExp
  @match Absyn.CREF(Absyn.CREF_IDENT("h", _)) = head
  @match Absyn.CREF(Absyn.CREF_IDENT("t", _)) = rest
  @test true
end

@testset "MetaModelica: Empty list {}" begin
  prog = mmParse("""
    function testEmpty
      output list<Integer> result;
    algorithm
      result := {};
    end testEmpty;
  """)
  @match Absyn.PARTS(_, _, classParts, _, _) = firstClassBody(prog)
  algSection = nothing
  for part in classParts
    if part isa Absyn.ALGORITHMS
      algSection = part
    end
  end
  @test algSection !== nothing
  @match Absyn.ALGORITHMS(algItems) = algSection
  @match algItem <| _ = algItems
  @match Absyn.ALGORITHMITEM(Absyn.ALG_ASSIGN(_, arrayExp), _, _) = algItem
  #= Empty {} parses as ARRAY with empty list =#
  @match Absyn.ARRAY(exps) = arrayExp
  @test listEmpty(exps)
end

@testset "MetaModelica: Wildcard pattern (_)" begin
  prog = mmParse("""
    function testWild
      input Integer x;
      output Integer y;
    algorithm
      y := match x
        case _ then 99;
      end match;
    end testWild;
  """)
  @match Absyn.PARTS(_, _, classParts, _, _) = firstClassBody(prog)
  algSection = nothing
  for part in classParts
    if part isa Absyn.ALGORITHMS
      algSection = part
    end
  end
  @match Absyn.ALGORITHMS(algItems) = algSection
  @match algItem <| _ = algItems
  @match Absyn.ALGORITHMITEM(Absyn.ALG_ASSIGN(_, matchExp), _, _) = algItem
  @match Absyn.MATCHEXP(_, _, _, cases, _) = matchExp
  @match c1 <| _ = cases
  @match Absyn.CASE(pattern, _, _, _, _, Absyn.INTEGER(99), _, _, _) = c1
  @test pattern isa Absyn.CREF
  #= The wildcard _ parses as CREF(WILD()) =#
  @match Absyn.CREF(Absyn.WILD()) = pattern
  @test true
end

@testset "MetaModelica: As-pattern binding" begin
  prog = mmParse("""
    function testAs
      input list<Integer> lst;
      output Integer h;
      output list<Integer> all;
    algorithm
      (h, all) := match lst
        case all as h :: _ then (h, all);
      end match;
    end testAs;
  """)
  @match Absyn.PARTS(_, _, classParts, _, _) = firstClassBody(prog)
  algSection = nothing
  for part in classParts
    if part isa Absyn.ALGORITHMS
      algSection = part
    end
  end
  @match Absyn.ALGORITHMS(algItems) = algSection
  @match algItem <| _ = algItems
  @match Absyn.ALGORITHMITEM(Absyn.ALG_ASSIGN(_, matchExp), _, _) = algItem
  @match Absyn.MATCHEXP(_, _, _, cases, _) = matchExp
  @match c1 <| _ = cases
  @match Absyn.CASE(pattern, _, _, _, _, _, _, _, _) = c1
  #= Should be AS("all", CONS(CREF("h"), CREF(WILD()))) =#
  @match Absyn.AS("all", Absyn.CONS(head, rest)) = pattern
  @match Absyn.CREF(Absyn.CREF_IDENT("h", _)) = head
  @match Absyn.CREF(Absyn.WILD()) = rest
  @test true
end

@testset "MetaModelica: Try-catch in algorithm" begin
  prog = mmParse("""
    function testTry
      input Integer x;
      output Integer y;
    algorithm
      try
        y := x + 1;
      else
        y := 0;
      end try;
    end testTry;
  """)
  @match Absyn.PARTS(_, _, classParts, _, _) = firstClassBody(prog)
  algSection = nothing
  for part in classParts
    if part isa Absyn.ALGORITHMS
      algSection = part
    end
  end
  @test algSection !== nothing
  @match Absyn.ALGORITHMS(algItems) = algSection
  @match algItem <| _ = algItems
  @match Absyn.ALGORITHMITEM(alg, _, _) = algItem
  @test alg isa Absyn.ALG_TRY
  @match Absyn.ALG_TRY(tryBody, elseBody) = alg
  #= Both branches should have one assignment =#
  @match tryItem <| _ = tryBody
  @match Absyn.ALGORITHMITEM(Absyn.ALG_ASSIGN(_, _), _, _) = tryItem
  @match elseItem <| _ = elseBody
  @match Absyn.ALGORITHMITEM(Absyn.ALG_ASSIGN(_, _), _, _) = elseItem
  @test true
end

@testset "MetaModelica: Match with local declarations" begin
  prog = mmParse("""
    function testLocal
      input Integer x;
      output String s;
    algorithm
      s := match x
        local Integer tmp;
        case 1
          algorithm
            tmp := x + 1;
          then "one";
        else "other";
      end match;
    end testLocal;
  """)
  @match Absyn.PARTS(_, _, classParts, _, _) = firstClassBody(prog)
  algSection = nothing
  for part in classParts
    if part isa Absyn.ALGORITHMS
      algSection = part
    end
  end
  @match Absyn.ALGORITHMS(algItems) = algSection
  @match algItem <| _ = algItems
  @match Absyn.ALGORITHMITEM(Absyn.ALG_ASSIGN(_, matchExp), _, _) = algItem
  @match Absyn.MATCHEXP(Absyn.MATCH(), _, localDecls, cases, _) = matchExp
  #= Should have local declarations =#
  @test !listEmpty(localDecls)
  #= Should have 2 cases =#
  @match c1 <| (c2 <| _) = cases
  @test c1 isa Absyn.CASE
  @test c2 isa Absyn.ELSE
  #= Case 1 result should be string "one" =#
  @match Absyn.CASE(Absyn.INTEGER(1), _, _, _, _, Absyn.STRING("one"), _, _, _) = c1
  @match Absyn.ELSE(_, _, Absyn.STRING("other"), _, _, _) = c2
  @test true
end

@testset "MetaModelica: Match with guard condition" begin
  prog = mmParse("""
    function testGuard
      input Integer x;
      output Integer y;
    algorithm
      y := match x
        case 1 guard x > 0 then 10;
        else 0;
      end match;
    end testGuard;
  """)
  @match Absyn.PARTS(_, _, classParts, _, _) = firstClassBody(prog)
  algSection = nothing
  for part in classParts
    if part isa Absyn.ALGORITHMS
      algSection = part
    end
  end
  @match Absyn.ALGORITHMS(algItems) = algSection
  @match algItem <| _ = algItems
  @match Absyn.ALGORITHMITEM(Absyn.ALG_ASSIGN(_, matchExp), _, _) = algItem
  @match Absyn.MATCHEXP(_, _, _, cases, _) = matchExp
  @match c1 <| _ = cases
  @match Absyn.CASE(Absyn.INTEGER(1), guardExp, _, _, _, Absyn.INTEGER(10), _, _, _) = c1
  #= Guard should be SOME(x > 0) =#
  @test guardExp isa SOME
  @match SOME(Absyn.RELATION(_, Absyn.GREATER(), _)) = guardExp
  @test true
end

@testset "MetaModelica: Nested cons builds list" begin
  prog = mmParse("""
    function testNestedCons
      output list<Integer> result;
    algorithm
      result := 1 :: 2 :: 3 :: {};
    end testNestedCons;
  """)
  @match Absyn.PARTS(_, _, classParts, _, _) = firstClassBody(prog)
  algSection = nothing
  for part in classParts
    if part isa Absyn.ALGORITHMS
      algSection = part
    end
  end
  @match Absyn.ALGORITHMS(algItems) = algSection
  @match algItem <| _ = algItems
  @match Absyn.ALGORITHMITEM(Absyn.ALG_ASSIGN(_, consExp), _, _) = algItem
  #= Should be CONS(1, CONS(2, CONS(3, ARRAY({})))) =#
  @match Absyn.CONS(Absyn.INTEGER(1), rest1) = consExp
  @match Absyn.CONS(Absyn.INTEGER(2), rest2) = rest1
  @match Absyn.CONS(Absyn.INTEGER(3), rest3) = rest2
  @match Absyn.ARRAY(emptyList) = rest3
  @test listEmpty(emptyList)
end
