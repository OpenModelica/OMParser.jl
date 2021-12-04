#=/*
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-CurrentYear, Linkoping University,
 * Department of Computer and Information Science,
 * SE-58183 Linkoping, Sweden.
 *
 * All rights reserved.
 *
 * THIS PROGRAM IS PROVIDED UNDER THE TERMS OF GPL VERSION 3
 * AND THIS OSMC PUBLIC LICENSE (OSMC-PL).
 * ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES RECIPIENT'S
 * ACCEPTANCE OF THE OSMC PUBLIC LICENSE.
 *
 * The OpenModelica software and the Open Source Modelica
 * Consortium (OSMC) Public License (OSMC-PL) are obtained
 * from Linkoping University, either from the above address,
 * from the URLs: http://www.ida.liu.se/projects/OpenModelica or
 * http://www.openmodelica.org, and in the OpenModelica distribution.
 * GNU version 3 is obtained from: http://www.gnu.org/copyleft/gpl.html.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without
 * even the implied warranty of  MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE, EXCEPT AS EXPRESSLY SET FORTH
 * IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE CONDITIONS
 * OF OSMC-PL.
 *
 * See the full OSMC Public License conditions for more details.
 *
 */
=#

using Revise
import Absyn

COPYRIGHT_HEADER = "/*
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-CurrentYear, Linkoping University,
 * Department of Computer and Information Science,
 * SE-58183 Linkoping, Sweden.
 *
 * All rights reserved.
 *
 * THIS PROGRAM IS PROVIDED UNDER THE TERMS OF GPL VERSION 3
 * AND THIS OSMC PUBLIC LICENSE (OSMC-PL).
 * ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES RECIPIENT'S
 * ACCEPTANCE OF THE OSMC PUBLIC LICENSE.
 *
 * The OpenModelica software and the Open Source Modelica
 * Consortium (OSMC) Public License (OSMC-PL) are obtained
 * from Linkoping University, either from the above address,
 * from the URLs: http://www.ida.liu.se/projects/OpenModelica or
 * http://www.openmodelica.org, and in the OpenModelica distribution.
 * GNU version 3 is obtained from: http://www.gnu.org/copyleft/gpl.html.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without
 * even the implied warranty of  MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE, EXCEPT AS EXPRESSLY SET FORTH
 * IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE CONDITIONS
 * OF OSMC-PL.
 *
 * See the full OSMC Public License conditions for more details.
 *
 */"

"""
  Generate C Headers
"""
function generateC_Headers(allDataTypes)
  return programExternalHeaderJulia(allDataTypes)
end


"""
  function getTypes(m)
"""
function getTypes(m)
  local types = DataType[]
  for name in names(m)
    res = getfield(m, name)
    if res isa DataType
      push!(types, res)
    end
  end
  return types
end

function getQualifiedName(components::Vector)
  local buffer = IOBuffer()
  for i in 1:length(components)
    print(buffer, components[i])
    if i != length(components)
      print(buffer, "_")
    end
  end
  return String(take!(buffer))
end

"""
  Get the qualified supertype path.
  The argument to this function should be a base type.
"""
function getSuperTypePath(baseType::DataType)
  @assert !isabstracttype(baseType)
  local components = split(string(baseType), ".")
  @info components
  local basePart = last(components) #= Get the concrete base type as a string=#
  components = split(string(supertype(baseType)), ".") #= Get all components for the supertype=#
  #= Get the qualified name for the supertype =#
  local supertypeQualifiedNameStr = getQualifiedName(components)
  local buffer = IOBuffer()
  print(buffer, supertypeQualifiedNameStr)
  @info basePart
  #= Add the base name to this path=#
  print(buffer, "_" * basePart)
  return String(take!(buffer))
end

"""
  Generate the program external header for Julia.
  @author johti17, based on code by adrpo.
"""
function programExternalHeaderJulia(allDataTypes, moduleName)
  
  local buffer = IOBuffer()
  println(buffer, COPYRIGHT_HEADER)
  println(buffer, "/* Automatically generated header for external MetaModelica functions */")
  println(buffer, "#include <julia.h>")
  println(buffer, "#include <assert.h>")
  println(buffer, "#ifdef __cplusplus")
  println(buffer, "extern \"C\" {")
  println(buffer, "#endif")
  println(buffer, "#ifdef ADD_METARECORD_DEFINITIONS")
  #= Generate the Julia pointers =#
  local jlValues::String = generateJL_Values(allDataTypes)
  #= Generate all JL values=#
  println(buffer, jlValues)
  println(buffer, "void OpenModelica_initAbsynReferences() {")
  #= Get the code in the body of initAbsynReferences =#
  local jlAsserts = generateJL_Asserts(allDataTypes, moduleName)
  println(buffer, jlAsserts)
  println(buffer, "}")
  #= Done with the sanity check=#
  println(buffer, "#else")
  println(buffer, "void OpenModelica_initAbsynReferences();")
  println(buffer, "#endif")
  #= Generate the extern definitions =#
  allSuperTypes = filter(isabstracttype, allDataTypes)
  #= Get the super types so we can get a nice grouping =#
  local externalDeclarations = generateExternalDeclarations(allSuperTypes)
  println(buffer, externalDeclarations)
  println(buffer, "/* End external declarations */")
  #= End extern definitions =#
  println(buffer, "#ifdef __cplusplus")
  println(buffer, "}")
  println(buffer, "#endif")
  #= adrpo: leave a newline at the end of file to get rid of the C warnings =#
  println(buffer, "")
  return String(take!(buffer))
end



function generateJL_Values(allDataTypes)
  local buffer = IOBuffer()
  #= Start by init all abstract types =#
  println(buffer, "/* Init abstract types */")
  for dataType in allDataTypes
    if isabstracttype(dataType)
      local components = split(string(dataType), ".")
      local qualifiedName = getQualifiedName(components)
      local baseTypeStr = components[2] #= In this case the base type should be the type without the absyn prefix=#
      @info qualifiedName
      local typeStr = string("jl_value_t *", qualifiedName, " = ", "NULL;")
      println(buffer, typeStr)
    end
  end
  #= All the base types =#
  for dataType in allDataTypes
    if !isabstracttype(dataType)
      local components = split(string(dataType), ".")
      #= Some elements from base might occur. The length of these elements are strictly less than 2.=#
      if length(components) < 2
        continue
      end
      local qualifiedName = getSuperTypePath(dataType)
      local baseTypeStr = components[2] #= In this case the base type should be the type without the absyn prefix=#
      @info qualifiedName
      local funcStr = string("jl_function_t *", qualifiedName, " = ", "NULL;")
      local valueStr = string("jl_value_t *", qualifiedName, " = ", "NULL;")
      println(buffer, funcStr)
      println(buffer, valueStr)
    end
  end    
  String(take!(buffer))
end


function generateJL_Asserts(allDataTypes, moduleName)
  local buffer = IOBuffer()
  local preamble = "
      jl_eval_string(\"using $(moduleName)\");
      jl_module_t* <%c.name%> = (jl_module_t *) jl_eval_string(\"$(moduleName)\");
      if (!$(moduleName)) {
        fprintf(stderr, \"module $(moduleName) not loaded, load it via \"using $(moduleName)\".);
        fflush(NULL);
      }
      assert(jl_is_module($(moduleName)));"
  println(buffer, preamble)
  #=replace(string(allDataTypes[1]), "." => "_")=#
  println(buffer, "/* All abstract types */")
  for dataType in allDataTypes
    if isabstracttype(dataType)
      local components = split(string(dataType), ".")
      local qualifiedName = getQualifiedName(components)
      local baseTypeStr = components[2] #= In this case the base type should be the type without the absyn prefix=#
      @info qualifiedName
      local assertStr = "assert(($qualifiedName = jl_get_global($(moduleName), jl_symbol(\" $(baseTypeStr) \")));"
      println(buffer, assertStr)
    end
  end
  println(buffer, "/* All sub types */")
  for dataType in allDataTypes
    if !isabstracttype(dataType)
      local components = split(string(dataType), ".")
      #= Some elements from base might occur. The length of these elements are strictly less than 2.=#
      if length(components) < 2
        continue
      end
      #= Get <Module>_<Uniontype>_<Record> =#
      local qualifiedName = getSuperTypePath(dataType)
      #= Get qualified path for basic datatype =#
      local baseTypeStr = components[2]        
      local assertStr1 = "assert(($qualifiedName = jl_get_function($(moduleName), jl_symbol(\" $(baseTypeStr) \")));"
      local assertStr2 = "assert(($qualifiedName = jl_get_global($(moduleName), jl_symbol(\" $(baseTypeStr) \")));"
      println(buffer, assertStr1)
      println(buffer, assertStr2)
      #=TODO is the double underscore important?=#
    end
  end  
  return String(take!(buffer))
end

"""
  Generate the extern declarations
  extern <Supertype declaration>
  extern <Subtype declaration 1>
  ...
  extern <Subtype declaration N>
This is followed by a function definition
  static inline jl_value_t* <Subtype path>
"""
function generateExternalDeclarations(allSuperTypes)
  local buffer = IOBuffer()
  println(buffer, "/* Extern declarations */")  
  for superType in allSuperTypes
    local subTypes = subtypes(superType) 
    local components = split(string(superType), ".")
    local qualifiedName = getQualifiedName(components)
    if length(components) < 2 #= Some components are to small to include=#      
      continue
    end
    local baseTypeStr = components[2] #= In this case the base type should be the type without the absyn prefix=#
    @info qualifiedName
    local superTypeStr = string("extern jl_value_t *", qualifiedName, ";")
    println(buffer, "/* External declarations for the uniontype: " * string(superType) * "*/")
    println(buffer, superTypeStr)
    #= Generate extern declarations for the subtypes=#
    for subType in subTypes
      local components = split(string(subType), ".")
      local qualifiedName = getSuperTypePath(subType)
      local baseTypeStr = components[2]        
      local functionName = string("extern jl_function_t *", qualifiedName, ";")
      local typeName = string("extern jl_function_t *", qualifiedName, "_type", ";")
      println(buffer, functionName)
      println(buffer, typeName)
      #= Find out the amount of function arguments to create these types =#
      local fieldNames = fieldnames(subType)
      local fieldNameLength = length(fieldNames)
      local fullName = string("Absyn__", baseTypeStr) #Why two underscores.. Ask Adrian about the scheme
      if fieldNameLength  == 0
        println(buffer, "#define $(fullName) jl_call0($(qualifiedName))")
      elseif fieldNameLength <= 3
        local fieldNamesAsStrWithType = join(map((x) -> string("jl_value_t *", x), fieldNames), ", ")
        local fieldNamesAsStrWithoutType = join(map(string, fieldNames), ", ")
        local arguments = fieldNamesAsStrWithType
        local staticFuncHeader = string("static inline jl_value_t *", "$(baseTypeStr)", "(", "$(arguments)", ")", " {")
        local body = string("return ","jl_call", string(fieldNameLength), "(", qualifiedName, ", " ,fieldNamesAsStrWithoutType, ")", ";")
        local staticFuncEpilog = "}"
        println(buffer, staticFuncHeader)
        println(buffer, body)
        println(buffer, staticFuncEpilog)
      else
        local fieldNamesAsStrWithType = join(map((x) -> string("jl_value_t *", x), fieldNames), ", ")
        local arguments = fieldNamesAsStrWithType
        local fieldNamesAsStrWithoutType = join(map(string, fieldNames), ", ")
        local staticFuncHeader = string("static inline jl_value_t *", "$(baseTypeStr)", "(", "$(arguments)", ")", " {")
        local arrayDecl = "jl_value_t *values[$(fieldNameLength)] = {$(fieldNamesAsStrWithoutType)};"
        local returnStmt = string("return ","jl_call", "(", qualifiedName, ", " ,"values", "$(fieldNameLength)" ,")", ";")
        local staticFuncEpilog = "}"
        println(buffer, staticFuncHeader)
        println(buffer, arrayDecl)
        println(buffer, returnStmt)
        println(buffer, staticFuncEpilog)
      end        
    end
    println(buffer, "/* End External declarations for the uniontype" * string(superType) * " */")
  end
  return String(take!(buffer))
end


#= Generate C-Code from the headers =#
#= Split the types into base types and abstract types (supertypes) =#
allDataTypes = getTypes(Absyn)
#= fin =#

res = programExternalHeaderJulia(allDataTypes, "Absyn")
println(res)
