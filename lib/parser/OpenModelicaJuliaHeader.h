/*
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
/* Automatically generated header for external MetaModelica functions */
#include <julia.h>
#include <assert.h>
#ifdef __cplusplus
extern "C" {
#endif
#ifdef ADD_METARECORD_DEFINITIONS
/* Init abstract types */
jl_value_t *Absyn_Algorithm = NULL;
jl_value_t *Absyn_AlgorithmItem = NULL;
jl_value_t *Absyn_Annotation = NULL;
jl_value_t *Absyn_Case = NULL;
jl_value_t *Absyn_Class = NULL;
jl_value_t *Absyn_ClassDef = NULL;
jl_value_t *Absyn_ClassPart = NULL;
jl_value_t *Absyn_CodeNode = NULL;
jl_value_t *Absyn_Comment = NULL;
jl_value_t *Absyn_Component = NULL;
jl_value_t *Absyn_Exp = NULL;
jl_value_t *Absyn_ComponentItem = NULL;
jl_value_t *Absyn_ComponentRef = NULL;
jl_value_t *Absyn_ConstrainClass = NULL;
jl_value_t *Absyn_Direction = NULL;
jl_value_t *Absyn_Each = NULL;
jl_value_t *Absyn_Element = NULL;
jl_value_t *Absyn_ElementArg = NULL;
jl_value_t *Absyn_ElementAttributes = NULL;
jl_value_t *Absyn_ElementItem = NULL;
jl_value_t *Absyn_ElementSpec = NULL;
jl_value_t *Absyn_EnumDef = NULL;
jl_value_t *Absyn_EnumLiteral = NULL;
jl_value_t *Absyn_EqMod = NULL;
jl_value_t *Absyn_Equation = NULL;
jl_value_t *Absyn_EquationItem = NULL;
jl_value_t *Absyn_ExternalDecl = NULL;
jl_value_t *Absyn_FlowStream = NULL;
jl_value_t *Absyn_ForIterator = NULL;
jl_value_t *Absyn_FunctionArgs = NULL;
jl_value_t *Absyn_FunctionPurity = NULL;
jl_value_t *Absyn_FunctionRestriction = NULL;
jl_value_t *Absyn_GroupImport = NULL;
jl_value_t *Absyn_Import = NULL;
jl_value_t *MetaModelica_SourceInfo = NULL;
jl_value_t *Absyn_InnerOuter = NULL;
jl_value_t *Absyn_IsField = NULL;
jl_value_t *Absyn_MatchType = NULL;
jl_value_t *Absyn_Modification = NULL;
jl_value_t *Absyn_Msg = NULL;
jl_value_t *Absyn_NamedArg = NULL;
jl_value_t *Absyn_Operator = NULL;
jl_value_t *Absyn_Parallelism = NULL;
jl_value_t *Absyn_Path = NULL;
jl_value_t *Absyn_Program = NULL;
jl_value_t *Absyn_RedeclareKeywords = NULL;
jl_value_t *Absyn_ReductionIterType = NULL;
jl_value_t *Absyn_Restriction = NULL;
jl_value_t *Absyn_Subscript = NULL;
jl_value_t *Absyn_TypeSpec = NULL;
jl_value_t *Absyn_Variability = NULL;
jl_value_t *Absyn_Within = NULL;
jl_function_t *Absyn_Operator_ADD = NULL;
jl_value_t *Absyn_Operator_ADD_type = NULL;
jl_function_t *Absyn_Operator_ADD_EW = NULL;
jl_value_t *Absyn_Operator_ADD_EW_type = NULL;
jl_function_t *Absyn_AlgorithmItem_ALGORITHMITEM = NULL;
jl_value_t *Absyn_AlgorithmItem_ALGORITHMITEM_type = NULL;
jl_function_t *Absyn_AlgorithmItem_ALGORITHMITEMCOMMENT = NULL;
jl_value_t *Absyn_AlgorithmItem_ALGORITHMITEMCOMMENT_type = NULL;
jl_function_t *Absyn_ClassPart_ALGORITHMS = NULL;
jl_value_t *Absyn_ClassPart_ALGORITHMS_type = NULL;
jl_function_t *Absyn_Algorithm_ALG_ASSIGN = NULL;
jl_value_t *Absyn_Algorithm_ALG_ASSIGN_type = NULL;
jl_function_t *Absyn_Algorithm_ALG_BREAK = NULL;
jl_value_t *Absyn_Algorithm_ALG_BREAK_type = NULL;
jl_function_t *Absyn_Algorithm_ALG_CONTINUE = NULL;
jl_value_t *Absyn_Algorithm_ALG_CONTINUE_type = NULL;
jl_function_t *Absyn_Algorithm_ALG_FAILURE = NULL;
jl_value_t *Absyn_Algorithm_ALG_FAILURE_type = NULL;
jl_function_t *Absyn_Algorithm_ALG_FOR = NULL;
jl_value_t *Absyn_Algorithm_ALG_FOR_type = NULL;
jl_function_t *Absyn_Algorithm_ALG_IF = NULL;
jl_value_t *Absyn_Algorithm_ALG_IF_type = NULL;
jl_function_t *Absyn_Algorithm_ALG_NORETCALL = NULL;
jl_value_t *Absyn_Algorithm_ALG_NORETCALL_type = NULL;
jl_function_t *Absyn_Algorithm_ALG_PARFOR = NULL;
jl_value_t *Absyn_Algorithm_ALG_PARFOR_type = NULL;
jl_function_t *Absyn_Algorithm_ALG_RETURN = NULL;
jl_value_t *Absyn_Algorithm_ALG_RETURN_type = NULL;
jl_function_t *Absyn_Algorithm_ALG_TRY = NULL;
jl_value_t *Absyn_Algorithm_ALG_TRY_type = NULL;
jl_function_t *Absyn_Algorithm_ALG_WHEN_A = NULL;
jl_value_t *Absyn_Algorithm_ALG_WHEN_A_type = NULL;
jl_function_t *Absyn_Algorithm_ALG_WHILE = NULL;
jl_value_t *Absyn_Algorithm_ALG_WHILE_type = NULL;
jl_function_t *Absyn_ComponentRef_ALLWILD = NULL;
jl_value_t *Absyn_ComponentRef_ALLWILD_type = NULL;
jl_function_t *Absyn_Operator_AND = NULL;
jl_value_t *Absyn_Operator_AND_type = NULL;
jl_function_t *Absyn_Annotation_ANNOTATION = NULL;
jl_value_t *Absyn_Annotation_ANNOTATION_type = NULL;
jl_function_t *Absyn_Exp_ARRAY = NULL;
jl_value_t *Absyn_Exp_ARRAY_type = NULL;
jl_function_t *Absyn_Exp_AS = NULL;
jl_value_t *Absyn_Exp_AS_type = NULL;
jl_function_t *Absyn_ElementAttributes_ATTR = NULL;
jl_value_t *Absyn_ElementAttributes_ATTR_type = NULL;
jl_function_t *Absyn_Direction_BIDIR = NULL;
jl_value_t *Absyn_Direction_BIDIR_type = NULL;
jl_function_t *Absyn_Exp_BINARY = NULL;
jl_value_t *Absyn_Exp_BINARY_type = NULL;
jl_function_t *Absyn_Exp_BOOL = NULL;
jl_value_t *Absyn_Exp_BOOL_type = NULL;
jl_function_t *Absyn_Exp_CALL = NULL;
jl_value_t *Absyn_Exp_CALL_type = NULL;
jl_function_t *Absyn_Case_CASE = NULL;
jl_value_t *Absyn_Case_CASE_type = NULL;
jl_function_t *Absyn_Class_CLASS = NULL;
jl_value_t *Absyn_Class_CLASS_type = NULL;
jl_function_t *Absyn_ElementSpec_CLASSDEF = NULL;
jl_value_t *Absyn_ElementSpec_CLASSDEF_type = NULL;
jl_function_t *Absyn_Modification_CLASSMOD = NULL;
jl_value_t *Absyn_Modification_CLASSMOD_type = NULL;
jl_function_t *Absyn_ClassDef_CLASS_EXTENDS = NULL;
jl_value_t *Absyn_ClassDef_CLASS_EXTENDS_type = NULL;
jl_function_t *Absyn_Exp_CODE = NULL;
jl_value_t *Absyn_Exp_CODE_type = NULL;
jl_function_t *Absyn_ReductionIterType_COMBINE = NULL;
jl_value_t *Absyn_ReductionIterType_COMBINE_type = NULL;
jl_function_t *Absyn_Comment_COMMENT = NULL;
jl_value_t *Absyn_Comment_COMMENT_type = NULL;
jl_function_t *Absyn_Component_COMPONENT = NULL;
jl_value_t *Absyn_Component_COMPONENT_type = NULL;
jl_function_t *Absyn_ComponentItem_COMPONENTITEM = NULL;
jl_value_t *Absyn_ComponentItem_COMPONENTITEM_type = NULL;
jl_function_t *Absyn_ElementSpec_COMPONENTS = NULL;
jl_value_t *Absyn_ElementSpec_COMPONENTS_type = NULL;
jl_function_t *Absyn_Exp_CONS = NULL;
jl_value_t *Absyn_Exp_CONS_type = NULL;
jl_function_t *Absyn_Variability_CONST = NULL;
jl_value_t *Absyn_Variability_CONST_type = NULL;
jl_function_t *Absyn_ConstrainClass_CONSTRAINCLASS = NULL;
jl_value_t *Absyn_ConstrainClass_CONSTRAINCLASS_type = NULL;
jl_function_t *Absyn_ClassPart_CONSTRAINTS = NULL;
jl_value_t *Absyn_ClassPart_CONSTRAINTS_type = NULL;
jl_function_t *Absyn_Exp_CREF = NULL;
jl_value_t *Absyn_Exp_CREF_type = NULL;
jl_function_t *Absyn_ComponentRef_CREF_FULLYQUALIFIED = NULL;
jl_value_t *Absyn_ComponentRef_CREF_FULLYQUALIFIED_type = NULL;
jl_function_t *Absyn_ComponentRef_CREF_IDENT = NULL;
jl_value_t *Absyn_ComponentRef_CREF_IDENT_type = NULL;
jl_function_t *Absyn_ComponentRef_CREF_QUAL = NULL;
jl_value_t *Absyn_ComponentRef_CREF_QUAL_type = NULL;
jl_function_t *Absyn_CodeNode_C_ALGORITHMSECTION = NULL;
jl_value_t *Absyn_CodeNode_C_ALGORITHMSECTION_type = NULL;
jl_function_t *Absyn_CodeNode_C_CONSTRAINTSECTION = NULL;
jl_value_t *Absyn_CodeNode_C_CONSTRAINTSECTION_type = NULL;
jl_function_t *Absyn_CodeNode_C_ELEMENT = NULL;
jl_value_t *Absyn_CodeNode_C_ELEMENT_type = NULL;
jl_function_t *Absyn_CodeNode_C_EQUATIONSECTION = NULL;
jl_value_t *Absyn_CodeNode_C_EQUATIONSECTION_type = NULL;
jl_function_t *Absyn_CodeNode_C_EXPRESSION = NULL;
jl_value_t *Absyn_CodeNode_C_EXPRESSION_type = NULL;
jl_function_t *Absyn_CodeNode_C_MODIFICATION = NULL;
jl_value_t *Absyn_CodeNode_C_MODIFICATION_type = NULL;
jl_function_t *Absyn_CodeNode_C_TYPENAME = NULL;
jl_value_t *Absyn_CodeNode_C_TYPENAME_type = NULL;
jl_function_t *Absyn_CodeNode_C_VARIABLENAME = NULL;
jl_value_t *Absyn_CodeNode_C_VARIABLENAME_type = NULL;
jl_function_t *Absyn_Element_DEFINEUNIT = NULL;
jl_value_t *Absyn_Element_DEFINEUNIT_type = NULL;
jl_function_t *Absyn_ClassDef_DERIVED = NULL;
jl_value_t *Absyn_ClassDef_DERIVED_type = NULL;
jl_function_t *Absyn_Variability_DISCRETE = NULL;
jl_value_t *Absyn_Variability_DISCRETE_type = NULL;
jl_function_t *Absyn_Operator_DIV = NULL;
jl_value_t *Absyn_Operator_DIV_type = NULL;
jl_function_t *Absyn_Operator_DIV_EW = NULL;
jl_value_t *Absyn_Operator_DIV_EW_type = NULL;
jl_function_t *Absyn_Exp_DOT = NULL;
jl_value_t *Absyn_Exp_DOT_type = NULL;
jl_function_t *Absyn_Each_EACH = NULL;
jl_value_t *Absyn_Each_EACH_type = NULL;
jl_function_t *Absyn_Element_ELEMENT = NULL;
jl_value_t *Absyn_Element_ELEMENT_type = NULL;
jl_function_t *Absyn_ElementItem_ELEMENTITEM = NULL;
jl_value_t *Absyn_ElementItem_ELEMENTITEM_type = NULL;
jl_function_t *Absyn_Case_ELSE = NULL;
jl_value_t *Absyn_Case_ELSE_type = NULL;
jl_function_t *Absyn_Exp_END = NULL;
jl_value_t *Absyn_Exp_END_type = NULL;
jl_function_t *Absyn_ClassDef_ENUMERATION = NULL;
jl_value_t *Absyn_ClassDef_ENUMERATION_type = NULL;
jl_function_t *Absyn_EnumLiteral_ENUMLITERAL = NULL;
jl_value_t *Absyn_EnumLiteral_ENUMLITERAL_type = NULL;
jl_function_t *Absyn_EnumDef_ENUMLITERALS = NULL;
jl_value_t *Absyn_EnumDef_ENUMLITERALS_type = NULL;
jl_function_t *Absyn_EnumDef_ENUM_COLON = NULL;
jl_value_t *Absyn_EnumDef_ENUM_COLON_type = NULL;
jl_function_t *Absyn_EqMod_EQMOD = NULL;
jl_value_t *Absyn_EqMod_EQMOD_type = NULL;
jl_function_t *Absyn_Operator_EQUAL = NULL;
jl_value_t *Absyn_Operator_EQUAL_type = NULL;
jl_function_t *Absyn_EquationItem_EQUATIONITEM = NULL;
jl_value_t *Absyn_EquationItem_EQUATIONITEM_type = NULL;
jl_function_t *Absyn_EquationItem_EQUATIONITEMCOMMENT = NULL;
jl_value_t *Absyn_EquationItem_EQUATIONITEMCOMMENT_type = NULL;
jl_function_t *Absyn_ClassPart_EQUATIONS = NULL;
jl_value_t *Absyn_ClassPart_EQUATIONS_type = NULL;
jl_function_t *Absyn_Equation_EQ_CONNECT = NULL;
jl_value_t *Absyn_Equation_EQ_CONNECT_type = NULL;
jl_function_t *Absyn_Equation_EQ_EQUALS = NULL;
jl_value_t *Absyn_Equation_EQ_EQUALS_type = NULL;
jl_function_t *Absyn_Equation_EQ_FAILURE = NULL;
jl_value_t *Absyn_Equation_EQ_FAILURE_type = NULL;
jl_function_t *Absyn_Equation_EQ_FOR = NULL;
jl_value_t *Absyn_Equation_EQ_FOR_type = NULL;
jl_function_t *Absyn_Equation_EQ_IF = NULL;
jl_value_t *Absyn_Equation_EQ_IF_type = NULL;
jl_function_t *Absyn_Equation_EQ_NORETCALL = NULL;
jl_value_t *Absyn_Equation_EQ_NORETCALL_type = NULL;
jl_function_t *Absyn_Equation_EQ_PDE = NULL;
jl_value_t *Absyn_Equation_EQ_PDE_type = NULL;
jl_function_t *Absyn_Equation_EQ_WHEN_E = NULL;
jl_value_t *Absyn_Equation_EQ_WHEN_E_type = NULL;
jl_function_t *Absyn_ElementSpec_EXTENDS = NULL;
jl_value_t *Absyn_ElementSpec_EXTENDS_type = NULL;
jl_function_t *Absyn_ClassPart_EXTERNAL = NULL;
jl_value_t *Absyn_ClassPart_EXTERNAL_type = NULL;
jl_function_t *Absyn_ExternalDecl_EXTERNALDECL = NULL;
jl_value_t *Absyn_ExternalDecl_EXTERNALDECL_type = NULL;
jl_function_t *Absyn_IsField_FIELD = NULL;
jl_value_t *Absyn_IsField_FIELD_type = NULL;
jl_function_t *Absyn_FlowStream_FLOW = NULL;
jl_value_t *Absyn_FlowStream_FLOW_type = NULL;
jl_function_t *Absyn_FunctionArgs_FOR_ITER_FARG = NULL;
jl_value_t *Absyn_FunctionArgs_FOR_ITER_FARG_type = NULL;
jl_function_t *Absyn_FunctionRestriction_FR_KERNEL_FUNCTION = NULL;
jl_value_t *Absyn_FunctionRestriction_FR_KERNEL_FUNCTION_type = NULL;
jl_function_t *Absyn_FunctionRestriction_FR_NORMAL_FUNCTION = NULL;
jl_value_t *Absyn_FunctionRestriction_FR_NORMAL_FUNCTION_type = NULL;
jl_function_t *Absyn_FunctionRestriction_FR_OPERATOR_FUNCTION = NULL;
jl_value_t *Absyn_FunctionRestriction_FR_OPERATOR_FUNCTION_type = NULL;
jl_function_t *Absyn_FunctionRestriction_FR_PARALLEL_FUNCTION = NULL;
jl_value_t *Absyn_FunctionRestriction_FR_PARALLEL_FUNCTION_type = NULL;
jl_function_t *Absyn_Path_FULLYQUALIFIED = NULL;
jl_value_t *Absyn_Path_FULLYQUALIFIED_type = NULL;
jl_function_t *Absyn_FunctionArgs_FUNCTIONARGS = NULL;
jl_value_t *Absyn_FunctionArgs_FUNCTIONARGS_type = NULL;
jl_function_t *Absyn_Operator_GREATER = NULL;
jl_value_t *Absyn_Operator_GREATER_type = NULL;
jl_function_t *Absyn_Operator_GREATEREQ = NULL;
jl_value_t *Absyn_Operator_GREATEREQ_type = NULL;
jl_function_t *Absyn_Import_GROUP_IMPORT = NULL;
jl_value_t *Absyn_Import_GROUP_IMPORT_type = NULL;
jl_function_t *Absyn_GroupImport_GROUP_IMPORT_NAME = NULL;
jl_value_t *Absyn_GroupImport_GROUP_IMPORT_NAME_type = NULL;
jl_function_t *Absyn_GroupImport_GROUP_IMPORT_RENAME = NULL;
jl_value_t *Absyn_GroupImport_GROUP_IMPORT_RENAME_type = NULL;
jl_function_t *Absyn_Path_IDENT = NULL;
jl_value_t *Absyn_Path_IDENT_type = NULL;
jl_function_t *Absyn_Exp_IFEXP = NULL;
jl_value_t *Absyn_Exp_IFEXP_type = NULL;
jl_function_t *Absyn_ElementSpec_IMPORT = NULL;
jl_value_t *Absyn_ElementSpec_IMPORT_type = NULL;
jl_function_t *Absyn_FunctionPurity_IMPURE = NULL;
jl_value_t *Absyn_FunctionPurity_IMPURE_type = NULL;
jl_function_t *Absyn_ClassPart_INITIALALGORITHMS = NULL;
jl_value_t *Absyn_ClassPart_INITIALALGORITHMS_type = NULL;
jl_function_t *Absyn_ClassPart_INITIALEQUATIONS = NULL;
jl_value_t *Absyn_ClassPart_INITIALEQUATIONS_type = NULL;
jl_function_t *Absyn_InnerOuter_INNER = NULL;
jl_value_t *Absyn_InnerOuter_INNER_type = NULL;
jl_function_t *Absyn_InnerOuter_INNER_OUTER = NULL;
jl_value_t *Absyn_InnerOuter_INNER_OUTER_type = NULL;
jl_function_t *Absyn_Direction_INPUT = NULL;
jl_value_t *Absyn_Direction_INPUT_type = NULL;
jl_function_t *Absyn_Direction_INPUT_OUTPUT = NULL;
jl_value_t *Absyn_Direction_INPUT_OUTPUT_type = NULL;
jl_function_t *Absyn_Exp_INTEGER = NULL;
jl_value_t *Absyn_Exp_INTEGER_type = NULL;
jl_function_t *Absyn_ForIterator_ITERATOR = NULL;
jl_value_t *Absyn_ForIterator_ITERATOR_type = NULL;
jl_function_t *Absyn_Exp_LBINARY = NULL;
jl_value_t *Absyn_Exp_LBINARY_type = NULL;
jl_function_t *Absyn_Operator_LESS = NULL;
jl_value_t *Absyn_Operator_LESS_type = NULL;
jl_function_t *Absyn_Operator_LESSEQ = NULL;
jl_value_t *Absyn_Operator_LESSEQ_type = NULL;
jl_function_t *Absyn_ElementItem_LEXER_COMMENT = NULL;
jl_value_t *Absyn_ElementItem_LEXER_COMMENT_type = NULL;
jl_function_t *Absyn_Exp_LIST = NULL;
jl_value_t *Absyn_Exp_LIST_type = NULL;
jl_function_t *Absyn_Exp_LUNARY = NULL;
jl_value_t *Absyn_Exp_LUNARY_type = NULL;
jl_function_t *Absyn_MatchType_MATCH = NULL;
jl_value_t *Absyn_MatchType_MATCH_type = NULL;
jl_function_t *Absyn_MatchType_MATCHCONTINUE = NULL;
jl_value_t *Absyn_MatchType_MATCHCONTINUE_type = NULL;
jl_function_t *Absyn_Exp_MATCHEXP = NULL;
jl_value_t *Absyn_Exp_MATCHEXP_type = NULL;
jl_function_t *Absyn_Exp_MATRIX = NULL;
jl_value_t *Absyn_Exp_MATRIX_type = NULL;
jl_function_t *Absyn_ElementArg_MODIFICATION = NULL;
jl_value_t *Absyn_ElementArg_MODIFICATION_type = NULL;
jl_function_t *Absyn_Msg_MSG = NULL;
jl_value_t *Absyn_Msg_MSG_type = NULL;
jl_function_t *Absyn_Operator_MUL = NULL;
jl_value_t *Absyn_Operator_MUL_type = NULL;
jl_function_t *Absyn_Operator_MUL_EW = NULL;
jl_value_t *Absyn_Operator_MUL_EW_type = NULL;
jl_function_t *Absyn_NamedArg_NAMEDARG = NULL;
jl_value_t *Absyn_NamedArg_NAMEDARG_type = NULL;
jl_function_t *Absyn_Import_NAMED_IMPORT = NULL;
jl_value_t *Absyn_Import_NAMED_IMPORT_type = NULL;
jl_function_t *Absyn_Operator_NEQUAL = NULL;
jl_value_t *Absyn_Operator_NEQUAL_type = NULL;
jl_function_t *Absyn_EqMod_NOMOD = NULL;
jl_value_t *Absyn_EqMod_NOMOD_type = NULL;
jl_function_t *Absyn_IsField_NONFIELD = NULL;
jl_value_t *Absyn_IsField_NONFIELD_type = NULL;
jl_function_t *Absyn_Each_NON_EACH = NULL;
jl_value_t *Absyn_Each_NON_EACH_type = NULL;
jl_function_t *Absyn_Parallelism_NON_PARALLEL = NULL;
jl_value_t *Absyn_Parallelism_NON_PARALLEL_type = NULL;
jl_function_t *Absyn_Subscript_NOSUB = NULL;
jl_value_t *Absyn_Subscript_NOSUB_type = NULL;
jl_function_t *Absyn_Operator_NOT = NULL;
jl_value_t *Absyn_Operator_NOT_type = NULL;
jl_function_t *Absyn_FlowStream_NOT_FLOW_STREAM = NULL;
jl_value_t *Absyn_FlowStream_NOT_FLOW_STREAM_type = NULL;
jl_function_t *Absyn_InnerOuter_NOT_INNER_OUTER = NULL;
jl_value_t *Absyn_InnerOuter_NOT_INNER_OUTER_type = NULL;
jl_function_t *Absyn_Msg_NO_MSG = NULL;
jl_value_t *Absyn_Msg_NO_MSG_type = NULL;
jl_function_t *Absyn_FunctionPurity_NO_PURITY = NULL;
jl_value_t *Absyn_FunctionPurity_NO_PURITY_type = NULL;
jl_function_t *Absyn_Operator_OR = NULL;
jl_value_t *Absyn_Operator_OR_type = NULL;
jl_function_t *Absyn_InnerOuter_OUTER = NULL;
jl_value_t *Absyn_InnerOuter_OUTER_type = NULL;
jl_function_t *Absyn_Direction_OUTPUT = NULL;
jl_value_t *Absyn_Direction_OUTPUT_type = NULL;
jl_function_t *Absyn_ClassDef_OVERLOAD = NULL;
jl_value_t *Absyn_ClassDef_OVERLOAD_type = NULL;
jl_function_t *Absyn_Variability_PARAM = NULL;
jl_value_t *Absyn_Variability_PARAM_type = NULL;
jl_function_t *Absyn_Parallelism_PARGLOBAL = NULL;
jl_value_t *Absyn_Parallelism_PARGLOBAL_type = NULL;
jl_function_t *Absyn_Parallelism_PARLOCAL = NULL;
jl_value_t *Absyn_Parallelism_PARLOCAL_type = NULL;
jl_function_t *Absyn_Exp_PARTEVALFUNCTION = NULL;
jl_value_t *Absyn_Exp_PARTEVALFUNCTION_type = NULL;
jl_function_t *Absyn_ClassDef_PARTS = NULL;
jl_value_t *Absyn_ClassDef_PARTS_type = NULL;
jl_function_t *Absyn_ClassDef_PDER = NULL;
jl_value_t *Absyn_ClassDef_PDER_type = NULL;
jl_function_t *Absyn_Operator_POW = NULL;
jl_value_t *Absyn_Operator_POW_type = NULL;
jl_function_t *Absyn_Operator_POW_EW = NULL;
jl_value_t *Absyn_Operator_POW_EW_type = NULL;
jl_function_t *Absyn_Program_PROGRAM = NULL;
jl_value_t *Absyn_Program_PROGRAM_type = NULL;
jl_function_t *Absyn_ClassPart_PROTECTED = NULL;
jl_value_t *Absyn_ClassPart_PROTECTED_type = NULL;
jl_function_t *Absyn_ClassPart_PUBLIC = NULL;
jl_value_t *Absyn_ClassPart_PUBLIC_type = NULL;
jl_function_t *Absyn_FunctionPurity_PURE = NULL;
jl_value_t *Absyn_FunctionPurity_PURE_type = NULL;
jl_function_t *Absyn_Path_QUALIFIED = NULL;
jl_value_t *Absyn_Path_QUALIFIED_type = NULL;
jl_function_t *Absyn_Import_QUAL_IMPORT = NULL;
jl_value_t *Absyn_Import_QUAL_IMPORT_type = NULL;
jl_function_t *Absyn_Exp_RANGE = NULL;
jl_value_t *Absyn_Exp_RANGE_type = NULL;
jl_function_t *Absyn_Ref_RCR = NULL;
jl_value_t *Absyn_Ref_RCR_type = NULL;
jl_function_t *Absyn_Exp_REAL = NULL;
jl_value_t *Absyn_Exp_REAL_type = NULL;
jl_function_t *Absyn_ElementArg_REDECLARATION = NULL;
jl_value_t *Absyn_ElementArg_REDECLARATION_type = NULL;
jl_function_t *Absyn_RedeclareKeywords_REDECLARE = NULL;
jl_value_t *Absyn_RedeclareKeywords_REDECLARE_type = NULL;
jl_function_t *Absyn_RedeclareKeywords_REDECLARE_REPLACEABLE = NULL;
jl_value_t *Absyn_RedeclareKeywords_REDECLARE_REPLACEABLE_type = NULL;
jl_function_t *Absyn_Exp_RELATION = NULL;
jl_value_t *Absyn_Exp_RELATION_type = NULL;
jl_function_t *Absyn_RedeclareKeywords_REPLACEABLE = NULL;
jl_value_t *Absyn_RedeclareKeywords_REPLACEABLE_type = NULL;
jl_function_t *Absyn_Ref_RIM = NULL;
jl_value_t *Absyn_Ref_RIM_type = NULL;
jl_function_t *Absyn_Ref_RTS = NULL;
jl_value_t *Absyn_Ref_RTS_type = NULL;
jl_function_t *Absyn_Restriction_R_BLOCK = NULL;
jl_value_t *Absyn_Restriction_R_BLOCK_type = NULL;
jl_function_t *Absyn_Restriction_R_CLASS = NULL;
jl_value_t *Absyn_Restriction_R_CLASS_type = NULL;
jl_function_t *Absyn_Restriction_R_CONNECTOR = NULL;
jl_value_t *Absyn_Restriction_R_CONNECTOR_type = NULL;
jl_function_t *Absyn_Restriction_R_ENUMERATION = NULL;
jl_value_t *Absyn_Restriction_R_ENUMERATION_type = NULL;
jl_function_t *Absyn_Restriction_R_EXP_CONNECTOR = NULL;
jl_value_t *Absyn_Restriction_R_EXP_CONNECTOR_type = NULL;
jl_function_t *Absyn_Restriction_R_FUNCTION = NULL;
jl_value_t *Absyn_Restriction_R_FUNCTION_type = NULL;
jl_function_t *Absyn_Restriction_R_METARECORD = NULL;
jl_value_t *Absyn_Restriction_R_METARECORD_type = NULL;
jl_function_t *Absyn_Restriction_R_MODEL = NULL;
jl_value_t *Absyn_Restriction_R_MODEL_type = NULL;
jl_function_t *Absyn_Restriction_R_OPERATOR = NULL;
jl_value_t *Absyn_Restriction_R_OPERATOR_type = NULL;
jl_function_t *Absyn_Restriction_R_OPERATOR_RECORD = NULL;
jl_value_t *Absyn_Restriction_R_OPERATOR_RECORD_type = NULL;
jl_function_t *Absyn_Restriction_R_OPTIMIZATION = NULL;
jl_value_t *Absyn_Restriction_R_OPTIMIZATION_type = NULL;
jl_function_t *Absyn_Restriction_R_PACKAGE = NULL;
jl_value_t *Absyn_Restriction_R_PACKAGE_type = NULL;
jl_function_t *Absyn_Restriction_R_PREDEFINED_BOOLEAN = NULL;
jl_value_t *Absyn_Restriction_R_PREDEFINED_BOOLEAN_type = NULL;
jl_function_t *Absyn_Restriction_R_PREDEFINED_CLOCK = NULL;
jl_value_t *Absyn_Restriction_R_PREDEFINED_CLOCK_type = NULL;
jl_function_t *Absyn_Restriction_R_PREDEFINED_ENUMERATION = NULL;
jl_value_t *Absyn_Restriction_R_PREDEFINED_ENUMERATION_type = NULL;
jl_function_t *Absyn_Restriction_R_PREDEFINED_INTEGER = NULL;
jl_value_t *Absyn_Restriction_R_PREDEFINED_INTEGER_type = NULL;
jl_function_t *Absyn_Restriction_R_PREDEFINED_REAL = NULL;
jl_value_t *Absyn_Restriction_R_PREDEFINED_REAL_type = NULL;
jl_function_t *Absyn_Restriction_R_PREDEFINED_STRING = NULL;
jl_value_t *Absyn_Restriction_R_PREDEFINED_STRING_type = NULL;
jl_function_t *Absyn_Restriction_R_RECORD = NULL;
jl_value_t *Absyn_Restriction_R_RECORD_type = NULL;
jl_function_t *Absyn_Restriction_R_TYPE = NULL;
jl_value_t *Absyn_Restriction_R_TYPE_type = NULL;
jl_function_t *Absyn_Restriction_R_UNIONTYPE = NULL;
jl_value_t *Absyn_Restriction_R_UNIONTYPE_type = NULL;
jl_function_t *Absyn_Restriction_R_UNKNOWN = NULL;
jl_value_t *Absyn_Restriction_R_UNKNOWN_type = NULL;
jl_function_t *Absyn_FlowStream_STREAM = NULL;
jl_value_t *Absyn_FlowStream_STREAM_type = NULL;
jl_function_t *Absyn_Exp_STRING = NULL;
jl_value_t *Absyn_Exp_STRING_type = NULL;
jl_function_t *Absyn_Operator_SUB = NULL;
jl_value_t *Absyn_Operator_SUB_type = NULL;
jl_function_t *Absyn_Subscript_SUBSCRIPT = NULL;
jl_value_t *Absyn_Subscript_SUBSCRIPT_type = NULL;
jl_function_t *Absyn_Operator_SUB_EW = NULL;
jl_value_t *Absyn_Operator_SUB_EW_type = NULL;
jl_function_t *Absyn_TypeSpec_TCOMPLEX = NULL;
jl_value_t *Absyn_TypeSpec_TCOMPLEX_type = NULL;
jl_function_t *Absyn_Element_TEXT = NULL;
jl_value_t *Absyn_Element_TEXT_type = NULL;
jl_function_t *Absyn_ReductionIterType_THREAD = NULL;
jl_value_t *Absyn_ReductionIterType_THREAD_type = NULL;
jl_function_t *Absyn_Within_TOP = NULL;
jl_value_t *Absyn_Within_TOP_type = NULL;
jl_function_t *Absyn_TypeSpec_TPATH = NULL;
jl_value_t *Absyn_TypeSpec_TPATH_type = NULL;
jl_function_t *Absyn_Exp_TUPLE = NULL;
jl_value_t *Absyn_Exp_TUPLE_type = NULL;
jl_function_t *Absyn_Operator_UMINUS = NULL;
jl_value_t *Absyn_Operator_UMINUS_type = NULL;
jl_function_t *Absyn_Operator_UMINUS_EW = NULL;
jl_value_t *Absyn_Operator_UMINUS_EW_type = NULL;
jl_function_t *Absyn_Exp_UNARY = NULL;
jl_value_t *Absyn_Exp_UNARY_type = NULL;
jl_function_t *Absyn_Import_UNQUAL_IMPORT = NULL;
jl_value_t *Absyn_Import_UNQUAL_IMPORT_type = NULL;
jl_function_t *Absyn_Operator_UPLUS = NULL;
jl_value_t *Absyn_Operator_UPLUS_type = NULL;
jl_function_t *Absyn_Operator_UPLUS_EW = NULL;
jl_value_t *Absyn_Operator_UPLUS_EW_type = NULL;
jl_function_t *Absyn_Variability_VAR = NULL;
jl_value_t *Absyn_Variability_VAR_type = NULL;
jl_function_t *Absyn_ComponentRef_WILD = NULL;
jl_value_t *Absyn_ComponentRef_WILD_type = NULL;
jl_function_t *Absyn_Within_WITHIN = NULL;
jl_value_t *Absyn_Within_WITHIN_type = NULL;

void OpenModelica_initAbsynReferences() {

      jl_eval_string("using Absyn");
      jl_module_t* Absyn = (jl_module_t *) jl_eval_string("Absyn");
      if (!Absyn) {
        fprintf(stderr, "module Absyn not loaded, load it via using Absyn.");
        fflush(NULL);
      }
      assert(jl_is_module(Absyn));
/* All abstract types */
assert((Absyn_Algorithm = jl_get_global(Absyn, jl_symbol("Algorithm"))));
assert((Absyn_AlgorithmItem = jl_get_global(Absyn, jl_symbol("AlgorithmItem"))));
assert((Absyn_Annotation = jl_get_global(Absyn, jl_symbol("Annotation"))));
assert((Absyn_Case = jl_get_global(Absyn, jl_symbol("Case"))));
assert((Absyn_Class = jl_get_global(Absyn, jl_symbol("Class"))));
assert((Absyn_ClassDef = jl_get_global(Absyn, jl_symbol("ClassDef"))));
assert((Absyn_ClassPart = jl_get_global(Absyn, jl_symbol("ClassPart"))));
assert((Absyn_CodeNode = jl_get_global(Absyn, jl_symbol("CodeNode"))));
assert((Absyn_Comment = jl_get_global(Absyn, jl_symbol("Comment"))));
assert((Absyn_Component = jl_get_global(Absyn, jl_symbol("Component"))));
assert((Absyn_Exp = jl_get_global(Absyn, jl_symbol("Exp"))));
assert((Absyn_ComponentItem = jl_get_global(Absyn, jl_symbol("ComponentItem"))));
assert((Absyn_ComponentRef = jl_get_global(Absyn, jl_symbol("ComponentRef"))));
assert((Absyn_ConstrainClass = jl_get_global(Absyn, jl_symbol("ConstrainClass"))));
assert((Absyn_Direction = jl_get_global(Absyn, jl_symbol("Direction"))));
assert((Absyn_Each = jl_get_global(Absyn, jl_symbol("Each"))));
assert((Absyn_Element = jl_get_global(Absyn, jl_symbol("Element"))));
assert((Absyn_ElementArg = jl_get_global(Absyn, jl_symbol("ElementArg"))));
assert((Absyn_ElementAttributes = jl_get_global(Absyn, jl_symbol("ElementAttributes"))));
assert((Absyn_ElementItem = jl_get_global(Absyn, jl_symbol("ElementItem"))));
assert((Absyn_ElementSpec = jl_get_global(Absyn, jl_symbol("ElementSpec"))));
assert((Absyn_EnumDef = jl_get_global(Absyn, jl_symbol("EnumDef"))));
assert((Absyn_EnumLiteral = jl_get_global(Absyn, jl_symbol("EnumLiteral"))));
assert((Absyn_EqMod = jl_get_global(Absyn, jl_symbol("EqMod"))));
assert((Absyn_Equation = jl_get_global(Absyn, jl_symbol("Equation"))));
assert((Absyn_EquationItem = jl_get_global(Absyn, jl_symbol("EquationItem"))));
assert((Absyn_ExternalDecl = jl_get_global(Absyn, jl_symbol("ExternalDecl"))));
assert((Absyn_FlowStream = jl_get_global(Absyn, jl_symbol("FlowStream"))));
assert((Absyn_ForIterator = jl_get_global(Absyn, jl_symbol("ForIterator"))));
assert((Absyn_FunctionArgs = jl_get_global(Absyn, jl_symbol("FunctionArgs"))));
assert((Absyn_FunctionPurity = jl_get_global(Absyn, jl_symbol("FunctionPurity"))));
assert((Absyn_FunctionRestriction = jl_get_global(Absyn, jl_symbol("FunctionRestriction"))));
assert((Absyn_GroupImport = jl_get_global(Absyn, jl_symbol("GroupImport"))));
assert((Absyn_Import = jl_get_global(Absyn, jl_symbol("Import"))));
assert((MetaModelica_SourceInfo = jl_get_global(Absyn, jl_symbol("SourceInfo"))));
assert((Absyn_InnerOuter = jl_get_global(Absyn, jl_symbol("InnerOuter"))));
assert((Absyn_IsField = jl_get_global(Absyn, jl_symbol("IsField"))));
assert((Absyn_MatchType = jl_get_global(Absyn, jl_symbol("MatchType"))));
assert((Absyn_Modification = jl_get_global(Absyn, jl_symbol("Modification"))));
assert((Absyn_Msg = jl_get_global(Absyn, jl_symbol("Msg"))));
assert((Absyn_NamedArg = jl_get_global(Absyn, jl_symbol("NamedArg"))));
assert((Absyn_Operator = jl_get_global(Absyn, jl_symbol("Operator"))));
assert((Absyn_Parallelism = jl_get_global(Absyn, jl_symbol("Parallelism"))));
assert((Absyn_Path = jl_get_global(Absyn, jl_symbol("Path"))));
assert((Absyn_Program = jl_get_global(Absyn, jl_symbol("Program"))));
assert((Absyn_RedeclareKeywords = jl_get_global(Absyn, jl_symbol("RedeclareKeywords"))));
assert((Absyn_ReductionIterType = jl_get_global(Absyn, jl_symbol("ReductionIterType"))));
assert((Absyn_Restriction = jl_get_global(Absyn, jl_symbol("Restriction"))));
assert((Absyn_Subscript = jl_get_global(Absyn, jl_symbol("Subscript"))));
assert((Absyn_TypeSpec = jl_get_global(Absyn, jl_symbol("TypeSpec"))));
assert((Absyn_Variability = jl_get_global(Absyn, jl_symbol("Variability"))));
assert((Absyn_Within = jl_get_global(Absyn, jl_symbol("Within"))));
/* All sub types */
assert((Absyn_Operator_ADD = jl_get_function(Absyn, "ADD")));
assert((Absyn_Operator_ADD = jl_get_global(Absyn, jl_symbol("ADD"))));
assert((Absyn_Operator_ADD_EW = jl_get_function(Absyn, "ADD_EW")));
assert((Absyn_Operator_ADD_EW = jl_get_global(Absyn, jl_symbol("ADD_EW"))));
assert((Absyn_AlgorithmItem_ALGORITHMITEM = jl_get_function(Absyn, "ALGORITHMITEM")));
assert((Absyn_AlgorithmItem_ALGORITHMITEM = jl_get_global(Absyn, jl_symbol("ALGORITHMITEM"))));
assert((Absyn_AlgorithmItem_ALGORITHMITEMCOMMENT = jl_get_function(Absyn, "ALGORITHMITEMCOMMENT")));
assert((Absyn_AlgorithmItem_ALGORITHMITEMCOMMENT = jl_get_global(Absyn, jl_symbol("ALGORITHMITEMCOMMENT"))));
assert((Absyn_ClassPart_ALGORITHMS = jl_get_function(Absyn, "ALGORITHMS")));
assert((Absyn_ClassPart_ALGORITHMS = jl_get_global(Absyn, jl_symbol("ALGORITHMS"))));
assert((Absyn_Algorithm_ALG_ASSIGN = jl_get_function(Absyn, "ALG_ASSIGN")));
assert((Absyn_Algorithm_ALG_ASSIGN = jl_get_global(Absyn, jl_symbol("ALG_ASSIGN"))));
assert((Absyn_Algorithm_ALG_BREAK = jl_get_function(Absyn, "ALG_BREAK")));
assert((Absyn_Algorithm_ALG_BREAK = jl_get_global(Absyn, jl_symbol("ALG_BREAK"))));
assert((Absyn_Algorithm_ALG_CONTINUE = jl_get_function(Absyn, "ALG_CONTINUE")));
assert((Absyn_Algorithm_ALG_CONTINUE = jl_get_global(Absyn, jl_symbol("ALG_CONTINUE"))));
assert((Absyn_Algorithm_ALG_FAILURE = jl_get_function(Absyn, "ALG_FAILURE")));
assert((Absyn_Algorithm_ALG_FAILURE = jl_get_global(Absyn, jl_symbol("ALG_FAILURE"))));
assert((Absyn_Algorithm_ALG_FOR = jl_get_function(Absyn, "ALG_FOR")));
assert((Absyn_Algorithm_ALG_FOR = jl_get_global(Absyn, jl_symbol("ALG_FOR"))));
assert((Absyn_Algorithm_ALG_IF = jl_get_function(Absyn, "ALG_IF")));
assert((Absyn_Algorithm_ALG_IF = jl_get_global(Absyn, jl_symbol("ALG_IF"))));
assert((Absyn_Algorithm_ALG_NORETCALL = jl_get_function(Absyn, "ALG_NORETCALL")));
assert((Absyn_Algorithm_ALG_NORETCALL = jl_get_global(Absyn, jl_symbol("ALG_NORETCALL"))));
assert((Absyn_Algorithm_ALG_PARFOR = jl_get_function(Absyn, "ALG_PARFOR")));
assert((Absyn_Algorithm_ALG_PARFOR = jl_get_global(Absyn, jl_symbol("ALG_PARFOR"))));
assert((Absyn_Algorithm_ALG_RETURN = jl_get_function(Absyn, "ALG_RETURN")));
assert((Absyn_Algorithm_ALG_RETURN = jl_get_global(Absyn, jl_symbol("ALG_RETURN"))));
assert((Absyn_Algorithm_ALG_TRY = jl_get_function(Absyn, "ALG_TRY")));
assert((Absyn_Algorithm_ALG_TRY = jl_get_global(Absyn, jl_symbol("ALG_TRY"))));
assert((Absyn_Algorithm_ALG_WHEN_A = jl_get_function(Absyn, "ALG_WHEN_A")));
assert((Absyn_Algorithm_ALG_WHEN_A = jl_get_global(Absyn, jl_symbol("ALG_WHEN_A"))));
assert((Absyn_Algorithm_ALG_WHILE = jl_get_function(Absyn, "ALG_WHILE")));
assert((Absyn_Algorithm_ALG_WHILE = jl_get_global(Absyn, jl_symbol("ALG_WHILE"))));
assert((Absyn_ComponentRef_ALLWILD = jl_get_function(Absyn, "ALLWILD")));
assert((Absyn_ComponentRef_ALLWILD = jl_get_global(Absyn, jl_symbol("ALLWILD"))));
assert((Absyn_Operator_AND = jl_get_function(Absyn, "AND")));
assert((Absyn_Operator_AND = jl_get_global(Absyn, jl_symbol("AND"))));
assert((Absyn_Annotation_ANNOTATION = jl_get_function(Absyn, "ANNOTATION")));
assert((Absyn_Annotation_ANNOTATION = jl_get_global(Absyn, jl_symbol("ANNOTATION"))));
assert((Absyn_Exp_ARRAY = jl_get_function(Absyn, "ARRAY")));
assert((Absyn_Exp_ARRAY = jl_get_global(Absyn, jl_symbol("ARRAY"))));
assert((Absyn_Exp_AS = jl_get_function(Absyn, "AS")));
assert((Absyn_Exp_AS = jl_get_global(Absyn, jl_symbol("AS"))));
assert((Absyn_ElementAttributes_ATTR = jl_get_function(Absyn, "ATTR")));
assert((Absyn_ElementAttributes_ATTR = jl_get_global(Absyn, jl_symbol("ATTR"))));
assert((Absyn_Direction_BIDIR = jl_get_function(Absyn, "BIDIR")));
assert((Absyn_Direction_BIDIR = jl_get_global(Absyn, jl_symbol("BIDIR"))));
assert((Absyn_Exp_BINARY = jl_get_function(Absyn, "BINARY")));
assert((Absyn_Exp_BINARY = jl_get_global(Absyn, jl_symbol("BINARY"))));
assert((Absyn_Exp_BOOL = jl_get_function(Absyn, "BOOL")));
assert((Absyn_Exp_BOOL = jl_get_global(Absyn, jl_symbol("BOOL"))));
assert((Absyn_Exp_CALL = jl_get_function(Absyn, "CALL")));
assert((Absyn_Exp_CALL = jl_get_global(Absyn, jl_symbol("CALL"))));
assert((Absyn_Case_CASE = jl_get_function(Absyn, "CASE")));
assert((Absyn_Case_CASE = jl_get_global(Absyn, jl_symbol("CASE"))));
assert((Absyn_Class_CLASS = jl_get_function(Absyn, "CLASS")));
assert((Absyn_Class_CLASS = jl_get_global(Absyn, jl_symbol("CLASS"))));
assert((Absyn_ElementSpec_CLASSDEF = jl_get_function(Absyn, "CLASSDEF")));
assert((Absyn_ElementSpec_CLASSDEF = jl_get_global(Absyn, jl_symbol("CLASSDEF"))));
assert((Absyn_Modification_CLASSMOD = jl_get_function(Absyn, "CLASSMOD")));
assert((Absyn_Modification_CLASSMOD = jl_get_global(Absyn, jl_symbol("CLASSMOD"))));
assert((Absyn_ClassDef_CLASS_EXTENDS = jl_get_function(Absyn, "CLASS_EXTENDS")));
assert((Absyn_ClassDef_CLASS_EXTENDS = jl_get_global(Absyn, jl_symbol("CLASS_EXTENDS"))));
assert((Absyn_Exp_CODE = jl_get_function(Absyn, "CODE")));
assert((Absyn_Exp_CODE = jl_get_global(Absyn, jl_symbol("CODE"))));
assert((Absyn_ReductionIterType_COMBINE = jl_get_function(Absyn, "COMBINE")));
assert((Absyn_ReductionIterType_COMBINE = jl_get_global(Absyn, jl_symbol("COMBINE"))));
assert((Absyn_Comment_COMMENT = jl_get_function(Absyn, "COMMENT")));
assert((Absyn_Comment_COMMENT = jl_get_global(Absyn, jl_symbol("COMMENT"))));
assert((Absyn_Component_COMPONENT = jl_get_function(Absyn, "COMPONENT")));
assert((Absyn_Component_COMPONENT = jl_get_global(Absyn, jl_symbol("COMPONENT"))));
assert((Absyn_ComponentItem_COMPONENTITEM = jl_get_function(Absyn, "COMPONENTITEM")));
assert((Absyn_ComponentItem_COMPONENTITEM = jl_get_global(Absyn, jl_symbol("COMPONENTITEM"))));
assert((Absyn_ElementSpec_COMPONENTS = jl_get_function(Absyn, "COMPONENTS")));
assert((Absyn_ElementSpec_COMPONENTS = jl_get_global(Absyn, jl_symbol("COMPONENTS"))));
assert((Absyn_Exp_CONS = jl_get_function(Absyn, "CONS")));
assert((Absyn_Exp_CONS = jl_get_global(Absyn, jl_symbol("CONS"))));
assert((Absyn_Variability_CONST = jl_get_function(Absyn, "CONST")));
assert((Absyn_Variability_CONST = jl_get_global(Absyn, jl_symbol("CONST"))));
assert((Absyn_ConstrainClass_CONSTRAINCLASS = jl_get_function(Absyn, "CONSTRAINCLASS")));
assert((Absyn_ConstrainClass_CONSTRAINCLASS = jl_get_global(Absyn, jl_symbol("CONSTRAINCLASS"))));
assert((Absyn_ClassPart_CONSTRAINTS = jl_get_function(Absyn, "CONSTRAINTS")));
assert((Absyn_ClassPart_CONSTRAINTS = jl_get_global(Absyn, jl_symbol("CONSTRAINTS"))));
assert((Absyn_Exp_CREF = jl_get_function(Absyn, "CREF")));
assert((Absyn_Exp_CREF = jl_get_global(Absyn, jl_symbol("CREF"))));
assert((Absyn_ComponentRef_CREF_FULLYQUALIFIED = jl_get_function(Absyn, "CREF_FULLYQUALIFIED")));
assert((Absyn_ComponentRef_CREF_FULLYQUALIFIED = jl_get_global(Absyn, jl_symbol("CREF_FULLYQUALIFIED"))));
assert((Absyn_ComponentRef_CREF_IDENT = jl_get_function(Absyn, "CREF_IDENT")));
assert((Absyn_ComponentRef_CREF_IDENT = jl_get_global(Absyn, jl_symbol("CREF_IDENT"))));
assert((Absyn_ComponentRef_CREF_QUAL = jl_get_function(Absyn, "CREF_QUAL")));
assert((Absyn_ComponentRef_CREF_QUAL = jl_get_global(Absyn, jl_symbol("CREF_QUAL"))));
assert((Absyn_CodeNode_C_ALGORITHMSECTION = jl_get_function(Absyn, "C_ALGORITHMSECTION")));
assert((Absyn_CodeNode_C_ALGORITHMSECTION = jl_get_global(Absyn, jl_symbol("C_ALGORITHMSECTION"))));
assert((Absyn_CodeNode_C_CONSTRAINTSECTION = jl_get_function(Absyn, "C_CONSTRAINTSECTION")));
assert((Absyn_CodeNode_C_CONSTRAINTSECTION = jl_get_global(Absyn, jl_symbol("C_CONSTRAINTSECTION"))));
assert((Absyn_CodeNode_C_ELEMENT = jl_get_function(Absyn, "C_ELEMENT")));
assert((Absyn_CodeNode_C_ELEMENT = jl_get_global(Absyn, jl_symbol("C_ELEMENT"))));
assert((Absyn_CodeNode_C_EQUATIONSECTION = jl_get_function(Absyn, "C_EQUATIONSECTION")));
assert((Absyn_CodeNode_C_EQUATIONSECTION = jl_get_global(Absyn, jl_symbol("C_EQUATIONSECTION"))));
assert((Absyn_CodeNode_C_EXPRESSION = jl_get_function(Absyn, "C_EXPRESSION")));
assert((Absyn_CodeNode_C_EXPRESSION = jl_get_global(Absyn, jl_symbol("C_EXPRESSION"))));
assert((Absyn_CodeNode_C_MODIFICATION = jl_get_function(Absyn, "C_MODIFICATION")));
assert((Absyn_CodeNode_C_MODIFICATION = jl_get_global(Absyn, jl_symbol("C_MODIFICATION"))));
assert((Absyn_CodeNode_C_TYPENAME = jl_get_function(Absyn, "C_TYPENAME")));
assert((Absyn_CodeNode_C_TYPENAME = jl_get_global(Absyn, jl_symbol("C_TYPENAME"))));
assert((Absyn_CodeNode_C_VARIABLENAME = jl_get_function(Absyn, "C_VARIABLENAME")));
assert((Absyn_CodeNode_C_VARIABLENAME = jl_get_global(Absyn, jl_symbol("C_VARIABLENAME"))));
assert((Absyn_Element_DEFINEUNIT = jl_get_function(Absyn, "DEFINEUNIT")));
assert((Absyn_Element_DEFINEUNIT = jl_get_global(Absyn, jl_symbol("DEFINEUNIT"))));
assert((Absyn_ClassDef_DERIVED = jl_get_function(Absyn, "DERIVED")));
assert((Absyn_ClassDef_DERIVED = jl_get_global(Absyn, jl_symbol("DERIVED"))));
assert((Absyn_Variability_DISCRETE = jl_get_function(Absyn, "DISCRETE")));
assert((Absyn_Variability_DISCRETE = jl_get_global(Absyn, jl_symbol("DISCRETE"))));
assert((Absyn_Operator_DIV = jl_get_function(Absyn, "DIV")));
assert((Absyn_Operator_DIV = jl_get_global(Absyn, jl_symbol("DIV"))));
assert((Absyn_Operator_DIV_EW = jl_get_function(Absyn, "DIV_EW")));
assert((Absyn_Operator_DIV_EW = jl_get_global(Absyn, jl_symbol("DIV_EW"))));
assert((Absyn_Exp_DOT = jl_get_function(Absyn, "DOT")));
assert((Absyn_Exp_DOT = jl_get_global(Absyn, jl_symbol("DOT"))));
assert((Absyn_Each_EACH = jl_get_function(Absyn, "EACH")));
assert((Absyn_Each_EACH = jl_get_global(Absyn, jl_symbol("EACH"))));
assert((Absyn_Element_ELEMENT = jl_get_function(Absyn, "ELEMENT")));
assert((Absyn_Element_ELEMENT = jl_get_global(Absyn, jl_symbol("ELEMENT"))));
assert((Absyn_ElementItem_ELEMENTITEM = jl_get_function(Absyn, "ELEMENTITEM")));
assert((Absyn_ElementItem_ELEMENTITEM = jl_get_global(Absyn, jl_symbol("ELEMENTITEM"))));
assert((Absyn_Case_ELSE = jl_get_function(Absyn, "ELSE")));
assert((Absyn_Case_ELSE = jl_get_global(Absyn, jl_symbol("ELSE"))));
assert((Absyn_Exp_END = jl_get_function(Absyn, "END")));
assert((Absyn_Exp_END = jl_get_global(Absyn, jl_symbol("END"))));
assert((Absyn_ClassDef_ENUMERATION = jl_get_function(Absyn, "ENUMERATION")));
assert((Absyn_ClassDef_ENUMERATION = jl_get_global(Absyn, jl_symbol("ENUMERATION"))));
assert((Absyn_EnumLiteral_ENUMLITERAL = jl_get_function(Absyn, "ENUMLITERAL")));
assert((Absyn_EnumLiteral_ENUMLITERAL = jl_get_global(Absyn, jl_symbol("ENUMLITERAL"))));
assert((Absyn_EnumDef_ENUMLITERALS = jl_get_function(Absyn, "ENUMLITERALS")));
assert((Absyn_EnumDef_ENUMLITERALS = jl_get_global(Absyn, jl_symbol("ENUMLITERALS"))));
assert((Absyn_EnumDef_ENUM_COLON = jl_get_function(Absyn, "ENUM_COLON")));
assert((Absyn_EnumDef_ENUM_COLON = jl_get_global(Absyn, jl_symbol("ENUM_COLON"))));
assert((Absyn_EqMod_EQMOD = jl_get_function(Absyn, "EQMOD")));
assert((Absyn_EqMod_EQMOD = jl_get_global(Absyn, jl_symbol("EQMOD"))));
assert((Absyn_Operator_EQUAL = jl_get_function(Absyn, "EQUAL")));
assert((Absyn_Operator_EQUAL = jl_get_global(Absyn, jl_symbol("EQUAL"))));
assert((Absyn_EquationItem_EQUATIONITEM = jl_get_function(Absyn, "EQUATIONITEM")));
assert((Absyn_EquationItem_EQUATIONITEM = jl_get_global(Absyn, jl_symbol("EQUATIONITEM"))));
assert((Absyn_EquationItem_EQUATIONITEMCOMMENT = jl_get_function(Absyn, "EQUATIONITEMCOMMENT")));
assert((Absyn_EquationItem_EQUATIONITEMCOMMENT = jl_get_global(Absyn, jl_symbol("EQUATIONITEMCOMMENT"))));
assert((Absyn_ClassPart_EQUATIONS = jl_get_function(Absyn, "EQUATIONS")));
assert((Absyn_ClassPart_EQUATIONS = jl_get_global(Absyn, jl_symbol("EQUATIONS"))));
assert((Absyn_Equation_EQ_CONNECT = jl_get_function(Absyn, "EQ_CONNECT")));
assert((Absyn_Equation_EQ_CONNECT = jl_get_global(Absyn, jl_symbol("EQ_CONNECT"))));
assert((Absyn_Equation_EQ_EQUALS = jl_get_function(Absyn, "EQ_EQUALS")));
assert((Absyn_Equation_EQ_EQUALS = jl_get_global(Absyn, jl_symbol("EQ_EQUALS"))));
assert((Absyn_Equation_EQ_FAILURE = jl_get_function(Absyn, "EQ_FAILURE")));
assert((Absyn_Equation_EQ_FAILURE = jl_get_global(Absyn, jl_symbol("EQ_FAILURE"))));
assert((Absyn_Equation_EQ_FOR = jl_get_function(Absyn, "EQ_FOR")));
assert((Absyn_Equation_EQ_FOR = jl_get_global(Absyn, jl_symbol("EQ_FOR"))));
assert((Absyn_Equation_EQ_IF = jl_get_function(Absyn, "EQ_IF")));
assert((Absyn_Equation_EQ_IF = jl_get_global(Absyn, jl_symbol("EQ_IF"))));
assert((Absyn_Equation_EQ_NORETCALL = jl_get_function(Absyn, "EQ_NORETCALL")));
assert((Absyn_Equation_EQ_NORETCALL = jl_get_global(Absyn, jl_symbol("EQ_NORETCALL"))));
assert((Absyn_Equation_EQ_PDE = jl_get_function(Absyn, "EQ_PDE")));
assert((Absyn_Equation_EQ_PDE = jl_get_global(Absyn, jl_symbol("EQ_PDE"))));
assert((Absyn_Equation_EQ_WHEN_E = jl_get_function(Absyn, "EQ_WHEN_E")));
assert((Absyn_Equation_EQ_WHEN_E = jl_get_global(Absyn, jl_symbol("EQ_WHEN_E"))));
assert((Absyn_ElementSpec_EXTENDS = jl_get_function(Absyn, "EXTENDS")));
assert((Absyn_ElementSpec_EXTENDS = jl_get_global(Absyn, jl_symbol("EXTENDS"))));
assert((Absyn_ClassPart_EXTERNAL = jl_get_function(Absyn, "EXTERNAL")));
assert((Absyn_ClassPart_EXTERNAL = jl_get_global(Absyn, jl_symbol("EXTERNAL"))));
assert((Absyn_ExternalDecl_EXTERNALDECL = jl_get_function(Absyn, "EXTERNALDECL")));
assert((Absyn_ExternalDecl_EXTERNALDECL = jl_get_global(Absyn, jl_symbol("EXTERNALDECL"))));
assert((Absyn_IsField_FIELD = jl_get_function(Absyn, "FIELD")));
assert((Absyn_IsField_FIELD = jl_get_global(Absyn, jl_symbol("FIELD"))));
assert((Absyn_FlowStream_FLOW = jl_get_function(Absyn, "FLOW")));
assert((Absyn_FlowStream_FLOW = jl_get_global(Absyn, jl_symbol("FLOW"))));
assert((Absyn_FunctionArgs_FOR_ITER_FARG = jl_get_function(Absyn, "FOR_ITER_FARG")));
assert((Absyn_FunctionArgs_FOR_ITER_FARG = jl_get_global(Absyn, jl_symbol("FOR_ITER_FARG"))));
assert((Absyn_FunctionRestriction_FR_KERNEL_FUNCTION = jl_get_function(Absyn, "FR_KERNEL_FUNCTION")));
assert((Absyn_FunctionRestriction_FR_KERNEL_FUNCTION = jl_get_global(Absyn, jl_symbol("FR_KERNEL_FUNCTION"))));
assert((Absyn_FunctionRestriction_FR_NORMAL_FUNCTION = jl_get_function(Absyn, "FR_NORMAL_FUNCTION")));
assert((Absyn_FunctionRestriction_FR_NORMAL_FUNCTION = jl_get_global(Absyn, jl_symbol("FR_NORMAL_FUNCTION"))));
assert((Absyn_FunctionRestriction_FR_OPERATOR_FUNCTION = jl_get_function(Absyn, "FR_OPERATOR_FUNCTION")));
assert((Absyn_FunctionRestriction_FR_OPERATOR_FUNCTION = jl_get_global(Absyn, jl_symbol("FR_OPERATOR_FUNCTION"))));
assert((Absyn_FunctionRestriction_FR_PARALLEL_FUNCTION = jl_get_function(Absyn, "FR_PARALLEL_FUNCTION")));
assert((Absyn_FunctionRestriction_FR_PARALLEL_FUNCTION = jl_get_global(Absyn, jl_symbol("FR_PARALLEL_FUNCTION"))));
assert((Absyn_Path_FULLYQUALIFIED = jl_get_function(Absyn, "FULLYQUALIFIED")));
assert((Absyn_Path_FULLYQUALIFIED = jl_get_global(Absyn, jl_symbol("FULLYQUALIFIED"))));
assert((Absyn_FunctionArgs_FUNCTIONARGS = jl_get_function(Absyn, "FUNCTIONARGS")));
assert((Absyn_FunctionArgs_FUNCTIONARGS = jl_get_global(Absyn, jl_symbol("FUNCTIONARGS"))));
assert((Absyn_Operator_GREATER = jl_get_function(Absyn, "GREATER")));
assert((Absyn_Operator_GREATER = jl_get_global(Absyn, jl_symbol("GREATER"))));
assert((Absyn_Operator_GREATEREQ = jl_get_function(Absyn, "GREATEREQ")));
assert((Absyn_Operator_GREATEREQ = jl_get_global(Absyn, jl_symbol("GREATEREQ"))));
assert((Absyn_Import_GROUP_IMPORT = jl_get_function(Absyn, "GROUP_IMPORT")));
assert((Absyn_Import_GROUP_IMPORT = jl_get_global(Absyn, jl_symbol("GROUP_IMPORT"))));
assert((Absyn_GroupImport_GROUP_IMPORT_NAME = jl_get_function(Absyn, "GROUP_IMPORT_NAME")));
assert((Absyn_GroupImport_GROUP_IMPORT_NAME = jl_get_global(Absyn, jl_symbol("GROUP_IMPORT_NAME"))));
assert((Absyn_GroupImport_GROUP_IMPORT_RENAME = jl_get_function(Absyn, "GROUP_IMPORT_RENAME")));
assert((Absyn_GroupImport_GROUP_IMPORT_RENAME = jl_get_global(Absyn, jl_symbol("GROUP_IMPORT_RENAME"))));
assert((Absyn_Path_IDENT = jl_get_function(Absyn, "IDENT")));
assert((Absyn_Path_IDENT = jl_get_global(Absyn, jl_symbol("IDENT"))));
assert((Absyn_Exp_IFEXP = jl_get_function(Absyn, "IFEXP")));
assert((Absyn_Exp_IFEXP = jl_get_global(Absyn, jl_symbol("IFEXP"))));
assert((Absyn_ElementSpec_IMPORT = jl_get_function(Absyn, "IMPORT")));
assert((Absyn_ElementSpec_IMPORT = jl_get_global(Absyn, jl_symbol("IMPORT"))));
assert((Absyn_FunctionPurity_IMPURE = jl_get_function(Absyn, "IMPURE")));
assert((Absyn_FunctionPurity_IMPURE = jl_get_global(Absyn, jl_symbol("IMPURE"))));
assert((Absyn_ClassPart_INITIALALGORITHMS = jl_get_function(Absyn, "INITIALALGORITHMS")));
assert((Absyn_ClassPart_INITIALALGORITHMS = jl_get_global(Absyn, jl_symbol("INITIALALGORITHMS"))));
assert((Absyn_ClassPart_INITIALEQUATIONS = jl_get_function(Absyn, "INITIALEQUATIONS")));
assert((Absyn_ClassPart_INITIALEQUATIONS = jl_get_global(Absyn, jl_symbol("INITIALEQUATIONS"))));
assert((Absyn_InnerOuter_INNER = jl_get_function(Absyn, "INNER")));
assert((Absyn_InnerOuter_INNER = jl_get_global(Absyn, jl_symbol("INNER"))));
assert((Absyn_InnerOuter_INNER_OUTER = jl_get_function(Absyn, "INNER_OUTER")));
assert((Absyn_InnerOuter_INNER_OUTER = jl_get_global(Absyn, jl_symbol("INNER_OUTER"))));
assert((Absyn_Direction_INPUT = jl_get_function(Absyn, "INPUT")));
assert((Absyn_Direction_INPUT = jl_get_global(Absyn, jl_symbol("INPUT"))));
assert((Absyn_Direction_INPUT_OUTPUT = jl_get_function(Absyn, "INPUT_OUTPUT")));
assert((Absyn_Direction_INPUT_OUTPUT = jl_get_global(Absyn, jl_symbol("INPUT_OUTPUT"))));
assert((Absyn_Exp_INTEGER = jl_get_function(Absyn, "INTEGER")));
assert((Absyn_Exp_INTEGER = jl_get_global(Absyn, jl_symbol("INTEGER"))));
assert((Absyn_ForIterator_ITERATOR = jl_get_function(Absyn, "ITERATOR")));
assert((Absyn_ForIterator_ITERATOR = jl_get_global(Absyn, jl_symbol("ITERATOR"))));
assert((Absyn_Exp_LBINARY = jl_get_function(Absyn, "LBINARY")));
assert((Absyn_Exp_LBINARY = jl_get_global(Absyn, jl_symbol("LBINARY"))));
assert((Absyn_Operator_LESS = jl_get_function(Absyn, "LESS")));
assert((Absyn_Operator_LESS = jl_get_global(Absyn, jl_symbol("LESS"))));
assert((Absyn_Operator_LESSEQ = jl_get_function(Absyn, "LESSEQ")));
assert((Absyn_Operator_LESSEQ = jl_get_global(Absyn, jl_symbol("LESSEQ"))));
assert((Absyn_ElementItem_LEXER_COMMENT = jl_get_function(Absyn, "LEXER_COMMENT")));
assert((Absyn_ElementItem_LEXER_COMMENT = jl_get_global(Absyn, jl_symbol("LEXER_COMMENT"))));
assert((Absyn_Exp_LIST = jl_get_function(Absyn, "LIST")));
assert((Absyn_Exp_LIST = jl_get_global(Absyn, jl_symbol("LIST"))));
assert((Absyn_Exp_LUNARY = jl_get_function(Absyn, "LUNARY")));
assert((Absyn_Exp_LUNARY = jl_get_global(Absyn, jl_symbol("LUNARY"))));
assert((Absyn_MatchType_MATCH = jl_get_function(Absyn, "MATCH")));
assert((Absyn_MatchType_MATCH = jl_get_global(Absyn, jl_symbol("MATCH"))));
assert((Absyn_MatchType_MATCHCONTINUE = jl_get_function(Absyn, "MATCHCONTINUE")));
assert((Absyn_MatchType_MATCHCONTINUE = jl_get_global(Absyn, jl_symbol("MATCHCONTINUE"))));
assert((Absyn_Exp_MATCHEXP = jl_get_function(Absyn, "MATCHEXP")));
assert((Absyn_Exp_MATCHEXP = jl_get_global(Absyn, jl_symbol("MATCHEXP"))));
assert((Absyn_Exp_MATRIX = jl_get_function(Absyn, "MATRIX")));
assert((Absyn_Exp_MATRIX = jl_get_global(Absyn, jl_symbol("MATRIX"))));
assert((Absyn_ElementArg_MODIFICATION = jl_get_function(Absyn, "MODIFICATION")));
assert((Absyn_ElementArg_MODIFICATION = jl_get_global(Absyn, jl_symbol("MODIFICATION"))));
assert((Absyn_Msg_MSG = jl_get_function(Absyn, "MSG")));
assert((Absyn_Msg_MSG = jl_get_global(Absyn, jl_symbol("MSG"))));
assert((Absyn_Operator_MUL = jl_get_function(Absyn, "MUL")));
assert((Absyn_Operator_MUL = jl_get_global(Absyn, jl_symbol("MUL"))));
assert((Absyn_Operator_MUL_EW = jl_get_function(Absyn, "MUL_EW")));
assert((Absyn_Operator_MUL_EW = jl_get_global(Absyn, jl_symbol("MUL_EW"))));
assert((Absyn_NamedArg_NAMEDARG = jl_get_function(Absyn, "NAMEDARG")));
assert((Absyn_NamedArg_NAMEDARG = jl_get_global(Absyn, jl_symbol("NAMEDARG"))));
assert((Absyn_Import_NAMED_IMPORT = jl_get_function(Absyn, "NAMED_IMPORT")));
assert((Absyn_Import_NAMED_IMPORT = jl_get_global(Absyn, jl_symbol("NAMED_IMPORT"))));
assert((Absyn_Operator_NEQUAL = jl_get_function(Absyn, "NEQUAL")));
assert((Absyn_Operator_NEQUAL = jl_get_global(Absyn, jl_symbol("NEQUAL"))));
assert((Absyn_EqMod_NOMOD = jl_get_function(Absyn, "NOMOD")));
assert((Absyn_EqMod_NOMOD = jl_get_global(Absyn, jl_symbol("NOMOD"))));
assert((Absyn_IsField_NONFIELD = jl_get_function(Absyn, "NONFIELD")));
assert((Absyn_IsField_NONFIELD = jl_get_global(Absyn, jl_symbol("NONFIELD"))));
assert((Absyn_Each_NON_EACH = jl_get_function(Absyn, "NON_EACH")));
assert((Absyn_Each_NON_EACH = jl_get_global(Absyn, jl_symbol("NON_EACH"))));
assert((Absyn_Parallelism_NON_PARALLEL = jl_get_function(Absyn, "NON_PARALLEL")));
assert((Absyn_Parallelism_NON_PARALLEL = jl_get_global(Absyn, jl_symbol("NON_PARALLEL"))));
assert((Absyn_Subscript_NOSUB = jl_get_function(Absyn, "NOSUB")));
assert((Absyn_Subscript_NOSUB = jl_get_global(Absyn, jl_symbol("NOSUB"))));
assert((Absyn_Operator_NOT = jl_get_function(Absyn, "NOT")));
assert((Absyn_Operator_NOT = jl_get_global(Absyn, jl_symbol("NOT"))));
assert((Absyn_FlowStream_NOT_FLOW_STREAM = jl_get_function(Absyn, "NOT_FLOW_STREAM")));
assert((Absyn_FlowStream_NOT_FLOW_STREAM = jl_get_global(Absyn, jl_symbol("NOT_FLOW_STREAM"))));
assert((Absyn_InnerOuter_NOT_INNER_OUTER = jl_get_function(Absyn, "NOT_INNER_OUTER")));
assert((Absyn_InnerOuter_NOT_INNER_OUTER = jl_get_global(Absyn, jl_symbol("NOT_INNER_OUTER"))));
assert((Absyn_Msg_NO_MSG = jl_get_function(Absyn, "NO_MSG")));
assert((Absyn_Msg_NO_MSG = jl_get_global(Absyn, jl_symbol("NO_MSG"))));
assert((Absyn_FunctionPurity_NO_PURITY = jl_get_function(Absyn, "NO_PURITY")));
assert((Absyn_FunctionPurity_NO_PURITY = jl_get_global(Absyn, jl_symbol("NO_PURITY"))));
assert((Absyn_Operator_OR = jl_get_function(Absyn, "OR")));
assert((Absyn_Operator_OR = jl_get_global(Absyn, jl_symbol("OR"))));
assert((Absyn_InnerOuter_OUTER = jl_get_function(Absyn, "OUTER")));
assert((Absyn_InnerOuter_OUTER = jl_get_global(Absyn, jl_symbol("OUTER"))));
assert((Absyn_Direction_OUTPUT = jl_get_function(Absyn, "OUTPUT")));
assert((Absyn_Direction_OUTPUT = jl_get_global(Absyn, jl_symbol("OUTPUT"))));
assert((Absyn_ClassDef_OVERLOAD = jl_get_function(Absyn, "OVERLOAD")));
assert((Absyn_ClassDef_OVERLOAD = jl_get_global(Absyn, jl_symbol("OVERLOAD"))));
assert((Absyn_Variability_PARAM = jl_get_function(Absyn, "PARAM")));
assert((Absyn_Variability_PARAM = jl_get_global(Absyn, jl_symbol("PARAM"))));
assert((Absyn_Parallelism_PARGLOBAL = jl_get_function(Absyn, "PARGLOBAL")));
assert((Absyn_Parallelism_PARGLOBAL = jl_get_global(Absyn, jl_symbol("PARGLOBAL"))));
assert((Absyn_Parallelism_PARLOCAL = jl_get_function(Absyn, "PARLOCAL")));
assert((Absyn_Parallelism_PARLOCAL = jl_get_global(Absyn, jl_symbol("PARLOCAL"))));
assert((Absyn_Exp_PARTEVALFUNCTION = jl_get_function(Absyn, "PARTEVALFUNCTION")));
assert((Absyn_Exp_PARTEVALFUNCTION = jl_get_global(Absyn, jl_symbol("PARTEVALFUNCTION"))));
assert((Absyn_ClassDef_PARTS = jl_get_function(Absyn, "PARTS")));
assert((Absyn_ClassDef_PARTS = jl_get_global(Absyn, jl_symbol("PARTS"))));
assert((Absyn_ClassDef_PDER = jl_get_function(Absyn, "PDER")));
assert((Absyn_ClassDef_PDER = jl_get_global(Absyn, jl_symbol("PDER"))));
assert((Absyn_Operator_POW = jl_get_function(Absyn, "POW")));
assert((Absyn_Operator_POW = jl_get_global(Absyn, jl_symbol("POW"))));
assert((Absyn_Operator_POW_EW = jl_get_function(Absyn, "POW_EW")));
assert((Absyn_Operator_POW_EW = jl_get_global(Absyn, jl_symbol("POW_EW"))));
assert((Absyn_Program_PROGRAM = jl_get_function(Absyn, "PROGRAM")));
assert((Absyn_Program_PROGRAM = jl_get_global(Absyn, jl_symbol("PROGRAM"))));
assert((Absyn_ClassPart_PROTECTED = jl_get_function(Absyn, "PROTECTED")));
assert((Absyn_ClassPart_PROTECTED = jl_get_global(Absyn, jl_symbol("PROTECTED"))));
assert((Absyn_ClassPart_PUBLIC = jl_get_function(Absyn, "PUBLIC")));
assert((Absyn_ClassPart_PUBLIC = jl_get_global(Absyn, jl_symbol("PUBLIC"))));
assert((Absyn_FunctionPurity_PURE = jl_get_function(Absyn, "PURE")));
assert((Absyn_FunctionPurity_PURE = jl_get_global(Absyn, jl_symbol("PURE"))));
assert((Absyn_Path_QUALIFIED = jl_get_function(Absyn, "QUALIFIED")));
assert((Absyn_Path_QUALIFIED = jl_get_global(Absyn, jl_symbol("QUALIFIED"))));
assert((Absyn_Import_QUAL_IMPORT = jl_get_function(Absyn, "QUAL_IMPORT")));
assert((Absyn_Import_QUAL_IMPORT = jl_get_global(Absyn, jl_symbol("QUAL_IMPORT"))));
assert((Absyn_Exp_RANGE = jl_get_function(Absyn, "RANGE")));
assert((Absyn_Exp_RANGE = jl_get_global(Absyn, jl_symbol("RANGE"))));
assert((Absyn_Ref_RCR = jl_get_function(Absyn, "RCR")));
assert((Absyn_Ref_RCR = jl_get_global(Absyn, jl_symbol("RCR"))));
assert((Absyn_Exp_REAL = jl_get_function(Absyn, "REAL")));
assert((Absyn_Exp_REAL = jl_get_global(Absyn, jl_symbol("REAL"))));
assert((Absyn_ElementArg_REDECLARATION = jl_get_function(Absyn, "REDECLARATION")));
assert((Absyn_ElementArg_REDECLARATION = jl_get_global(Absyn, jl_symbol("REDECLARATION"))));
assert((Absyn_RedeclareKeywords_REDECLARE = jl_get_function(Absyn, "REDECLARE")));
assert((Absyn_RedeclareKeywords_REDECLARE = jl_get_global(Absyn, jl_symbol("REDECLARE"))));
assert((Absyn_RedeclareKeywords_REDECLARE_REPLACEABLE = jl_get_function(Absyn, "REDECLARE_REPLACEABLE")));
assert((Absyn_RedeclareKeywords_REDECLARE_REPLACEABLE = jl_get_global(Absyn, jl_symbol("REDECLARE_REPLACEABLE"))));
assert((Absyn_Exp_RELATION = jl_get_function(Absyn, "RELATION")));
assert((Absyn_Exp_RELATION = jl_get_global(Absyn, jl_symbol("RELATION"))));
assert((Absyn_RedeclareKeywords_REPLACEABLE = jl_get_function(Absyn, "REPLACEABLE")));
assert((Absyn_RedeclareKeywords_REPLACEABLE = jl_get_global(Absyn, jl_symbol("REPLACEABLE"))));
assert((Absyn_Ref_RIM = jl_get_function(Absyn, "RIM")));
assert((Absyn_Ref_RIM = jl_get_global(Absyn, jl_symbol("RIM"))));
assert((Absyn_Ref_RTS = jl_get_function(Absyn, "RTS")));
assert((Absyn_Ref_RTS = jl_get_global(Absyn, jl_symbol("RTS"))));
assert((Absyn_Restriction_R_BLOCK = jl_get_function(Absyn, "R_BLOCK")));
assert((Absyn_Restriction_R_BLOCK = jl_get_global(Absyn, jl_symbol("R_BLOCK"))));
assert((Absyn_Restriction_R_CLASS = jl_get_function(Absyn, "R_CLASS")));
assert((Absyn_Restriction_R_CLASS = jl_get_global(Absyn, jl_symbol("R_CLASS"))));
assert((Absyn_Restriction_R_CONNECTOR = jl_get_function(Absyn, "R_CONNECTOR")));
assert((Absyn_Restriction_R_CONNECTOR = jl_get_global(Absyn, jl_symbol("R_CONNECTOR"))));
assert((Absyn_Restriction_R_ENUMERATION = jl_get_function(Absyn, "R_ENUMERATION")));
assert((Absyn_Restriction_R_ENUMERATION = jl_get_global(Absyn, jl_symbol("R_ENUMERATION"))));
assert((Absyn_Restriction_R_EXP_CONNECTOR = jl_get_function(Absyn, "R_EXP_CONNECTOR")));
assert((Absyn_Restriction_R_EXP_CONNECTOR = jl_get_global(Absyn, jl_symbol("R_EXP_CONNECTOR"))));
assert((Absyn_Restriction_R_FUNCTION = jl_get_function(Absyn, "R_FUNCTION")));
assert((Absyn_Restriction_R_FUNCTION = jl_get_global(Absyn, jl_symbol("R_FUNCTION"))));
assert((Absyn_Restriction_R_METARECORD = jl_get_function(Absyn, "R_METARECORD")));
assert((Absyn_Restriction_R_METARECORD = jl_get_global(Absyn, jl_symbol("R_METARECORD"))));
assert((Absyn_Restriction_R_MODEL = jl_get_function(Absyn, "R_MODEL")));
assert((Absyn_Restriction_R_MODEL = jl_get_global(Absyn, jl_symbol("R_MODEL"))));
assert((Absyn_Restriction_R_OPERATOR = jl_get_function(Absyn, "R_OPERATOR")));
assert((Absyn_Restriction_R_OPERATOR = jl_get_global(Absyn, jl_symbol("R_OPERATOR"))));
assert((Absyn_Restriction_R_OPERATOR_RECORD = jl_get_function(Absyn, "R_OPERATOR_RECORD")));
assert((Absyn_Restriction_R_OPERATOR_RECORD = jl_get_global(Absyn, jl_symbol("R_OPERATOR_RECORD"))));
assert((Absyn_Restriction_R_OPTIMIZATION = jl_get_function(Absyn, "R_OPTIMIZATION")));
assert((Absyn_Restriction_R_OPTIMIZATION = jl_get_global(Absyn, jl_symbol("R_OPTIMIZATION"))));
assert((Absyn_Restriction_R_PACKAGE = jl_get_function(Absyn, "R_PACKAGE")));
assert((Absyn_Restriction_R_PACKAGE = jl_get_global(Absyn, jl_symbol("R_PACKAGE"))));
assert((Absyn_Restriction_R_PREDEFINED_BOOLEAN = jl_get_function(Absyn, "R_PREDEFINED_BOOLEAN")));
assert((Absyn_Restriction_R_PREDEFINED_BOOLEAN = jl_get_global(Absyn, jl_symbol("R_PREDEFINED_BOOLEAN"))));
assert((Absyn_Restriction_R_PREDEFINED_CLOCK = jl_get_function(Absyn, "R_PREDEFINED_CLOCK")));
assert((Absyn_Restriction_R_PREDEFINED_CLOCK = jl_get_global(Absyn, jl_symbol("R_PREDEFINED_CLOCK"))));
assert((Absyn_Restriction_R_PREDEFINED_ENUMERATION = jl_get_function(Absyn, "R_PREDEFINED_ENUMERATION")));
assert((Absyn_Restriction_R_PREDEFINED_ENUMERATION = jl_get_global(Absyn, jl_symbol("R_PREDEFINED_ENUMERATION"))));
assert((Absyn_Restriction_R_PREDEFINED_INTEGER = jl_get_function(Absyn, "R_PREDEFINED_INTEGER")));
assert((Absyn_Restriction_R_PREDEFINED_INTEGER = jl_get_global(Absyn, jl_symbol("R_PREDEFINED_INTEGER"))));
assert((Absyn_Restriction_R_PREDEFINED_REAL = jl_get_function(Absyn, "R_PREDEFINED_REAL")));
assert((Absyn_Restriction_R_PREDEFINED_REAL = jl_get_global(Absyn, jl_symbol("R_PREDEFINED_REAL"))));
assert((Absyn_Restriction_R_PREDEFINED_STRING = jl_get_function(Absyn, "R_PREDEFINED_STRING")));
assert((Absyn_Restriction_R_PREDEFINED_STRING = jl_get_global(Absyn, jl_symbol("R_PREDEFINED_STRING"))));
assert((Absyn_Restriction_R_RECORD = jl_get_function(Absyn, "R_RECORD")));
assert((Absyn_Restriction_R_RECORD = jl_get_global(Absyn, jl_symbol("R_RECORD"))));
assert((Absyn_Restriction_R_TYPE = jl_get_function(Absyn, "R_TYPE")));
assert((Absyn_Restriction_R_TYPE = jl_get_global(Absyn, jl_symbol("R_TYPE"))));
assert((Absyn_Restriction_R_UNIONTYPE = jl_get_function(Absyn, "R_UNIONTYPE")));
assert((Absyn_Restriction_R_UNIONTYPE = jl_get_global(Absyn, jl_symbol("R_UNIONTYPE"))));
assert((Absyn_Restriction_R_UNKNOWN = jl_get_function(Absyn, "R_UNKNOWN")));
assert((Absyn_Restriction_R_UNKNOWN = jl_get_global(Absyn, jl_symbol("R_UNKNOWN"))));
assert((Absyn_FlowStream_STREAM = jl_get_function(Absyn, "STREAM")));
assert((Absyn_FlowStream_STREAM = jl_get_global(Absyn, jl_symbol("STREAM"))));
assert((Absyn_Exp_STRING = jl_get_function(Absyn, "STRING")));
assert((Absyn_Exp_STRING = jl_get_global(Absyn, jl_symbol("STRING"))));
assert((Absyn_Operator_SUB = jl_get_function(Absyn, "SUB")));
assert((Absyn_Operator_SUB = jl_get_global(Absyn, jl_symbol("SUB"))));
assert((Absyn_Subscript_SUBSCRIPT = jl_get_function(Absyn, "SUBSCRIPT")));
assert((Absyn_Subscript_SUBSCRIPT = jl_get_global(Absyn, jl_symbol("SUBSCRIPT"))));
assert((Absyn_Operator_SUB_EW = jl_get_function(Absyn, "SUB_EW")));
assert((Absyn_Operator_SUB_EW = jl_get_global(Absyn, jl_symbol("SUB_EW"))));
assert((Absyn_TypeSpec_TCOMPLEX = jl_get_function(Absyn, "TCOMPLEX")));
assert((Absyn_TypeSpec_TCOMPLEX = jl_get_global(Absyn, jl_symbol("TCOMPLEX"))));
assert((Absyn_Element_TEXT = jl_get_function(Absyn, "TEXT")));
assert((Absyn_Element_TEXT = jl_get_global(Absyn, jl_symbol("TEXT"))));
assert((Absyn_ReductionIterType_THREAD = jl_get_function(Absyn, "THREAD")));
assert((Absyn_ReductionIterType_THREAD = jl_get_global(Absyn, jl_symbol("THREAD"))));
assert((Absyn_Within_TOP = jl_get_function(Absyn, "TOP")));
assert((Absyn_Within_TOP = jl_get_global(Absyn, jl_symbol("TOP"))));
assert((Absyn_TypeSpec_TPATH = jl_get_function(Absyn, "TPATH")));
assert((Absyn_TypeSpec_TPATH = jl_get_global(Absyn, jl_symbol("TPATH"))));
assert((Absyn_Exp_TUPLE = jl_get_function(Absyn, "TUPLE")));
assert((Absyn_Exp_TUPLE = jl_get_global(Absyn, jl_symbol("TUPLE"))));
assert((Absyn_Operator_UMINUS = jl_get_function(Absyn, "UMINUS")));
assert((Absyn_Operator_UMINUS = jl_get_global(Absyn, jl_symbol("UMINUS"))));
assert((Absyn_Operator_UMINUS_EW = jl_get_function(Absyn, "UMINUS_EW")));
assert((Absyn_Operator_UMINUS_EW = jl_get_global(Absyn, jl_symbol("UMINUS_EW"))));
assert((Absyn_Exp_UNARY = jl_get_function(Absyn, "UNARY")));
assert((Absyn_Exp_UNARY = jl_get_global(Absyn, jl_symbol("UNARY"))));
assert((Absyn_Import_UNQUAL_IMPORT = jl_get_function(Absyn, "UNQUAL_IMPORT")));
assert((Absyn_Import_UNQUAL_IMPORT = jl_get_global(Absyn, jl_symbol("UNQUAL_IMPORT"))));
assert((Absyn_Operator_UPLUS = jl_get_function(Absyn, "UPLUS")));
assert((Absyn_Operator_UPLUS = jl_get_global(Absyn, jl_symbol("UPLUS"))));
assert((Absyn_Operator_UPLUS_EW = jl_get_function(Absyn, "UPLUS_EW")));
assert((Absyn_Operator_UPLUS_EW = jl_get_global(Absyn, jl_symbol("UPLUS_EW"))));
assert((Absyn_Variability_VAR = jl_get_function(Absyn, "VAR")));
assert((Absyn_Variability_VAR = jl_get_global(Absyn, jl_symbol("VAR"))));
assert((Absyn_ComponentRef_WILD = jl_get_function(Absyn, "WILD")));
assert((Absyn_ComponentRef_WILD = jl_get_global(Absyn, jl_symbol("WILD"))));
assert((Absyn_Within_WITHIN = jl_get_function(Absyn, "WITHIN")));
assert((Absyn_Within_WITHIN = jl_get_global(Absyn, jl_symbol("WITHIN"))));

}
#else
void OpenModelica_initAbsynReferences();
#endif
/* Extern declarations */
/* External declarations for the uniontype: Absyn.Algorithm*/
extern jl_value_t *Absyn_Algorithm;
extern jl_function_t *Absyn_Algorithm_ALG_ASSIGN;
extern jl_function_t *Absyn_Algorithm_ALG_ASSIGN_type;
static inline jl_value_t *Absyn__ALG_5fASSIGN(jl_value_t *assignComponent, jl_value_t *value) {
return jl_call2(Absyn_Algorithm_ALG_ASSIGN, assignComponent, value);
}
extern jl_function_t *Absyn_Algorithm_ALG_BREAK;
extern jl_function_t *Absyn_Algorithm_ALG_BREAK_type;
#define Absyn__ALG_5fBREAK jl_call0(Absyn_Algorithm_ALG_BREAK)
extern jl_function_t *Absyn_Algorithm_ALG_CONTINUE;
extern jl_function_t *Absyn_Algorithm_ALG_CONTINUE_type;
#define Absyn__ALG_5fCONTINUE jl_call0(Absyn_Algorithm_ALG_CONTINUE)
extern jl_function_t *Absyn_Algorithm_ALG_FAILURE;
extern jl_function_t *Absyn_Algorithm_ALG_FAILURE_type;
static inline jl_value_t *Absyn__ALG_5fFAILURE(jl_value_t *equ) {
return jl_call1(Absyn_Algorithm_ALG_FAILURE, equ);
}
extern jl_function_t *Absyn_Algorithm_ALG_FOR;
extern jl_function_t *Absyn_Algorithm_ALG_FOR_type;
static inline jl_value_t *Absyn__ALG_5fFOR(jl_value_t *iterators, jl_value_t *forBody) {
return jl_call2(Absyn_Algorithm_ALG_FOR, iterators, forBody);
}
extern jl_function_t *Absyn_Algorithm_ALG_IF;
extern jl_function_t *Absyn_Algorithm_ALG_IF_type;
static inline jl_value_t *Absyn__ALG_5fIF(jl_value_t *ifExp, jl_value_t *trueBranch, jl_value_t *elseIfAlgorithmBranch, jl_value_t *elseBranch) {
jl_value_t *values[4] = {ifExp, trueBranch, elseIfAlgorithmBranch, elseBranch};
return jl_call(Absyn_Algorithm_ALG_IF, values, 4);
}
extern jl_function_t *Absyn_Algorithm_ALG_NORETCALL;
extern jl_function_t *Absyn_Algorithm_ALG_NORETCALL_type;
static inline jl_value_t *Absyn__ALG_5fNORETCALL(jl_value_t *functionCall, jl_value_t *functionArgs) {
return jl_call2(Absyn_Algorithm_ALG_NORETCALL, functionCall, functionArgs);
}
extern jl_function_t *Absyn_Algorithm_ALG_PARFOR;
extern jl_function_t *Absyn_Algorithm_ALG_PARFOR_type;
static inline jl_value_t *Absyn__ALG_5fPARFOR(jl_value_t *iterators, jl_value_t *parforBody) {
return jl_call2(Absyn_Algorithm_ALG_PARFOR, iterators, parforBody);
}
extern jl_function_t *Absyn_Algorithm_ALG_RETURN;
extern jl_function_t *Absyn_Algorithm_ALG_RETURN_type;
#define Absyn__ALG_5fRETURN jl_call0(Absyn_Algorithm_ALG_RETURN)
extern jl_function_t *Absyn_Algorithm_ALG_TRY;
extern jl_function_t *Absyn_Algorithm_ALG_TRY_type;
static inline jl_value_t *Absyn__ALG_5fTRY(jl_value_t *body, jl_value_t *elseBody) {
return jl_call2(Absyn_Algorithm_ALG_TRY, body, elseBody);
}
extern jl_function_t *Absyn_Algorithm_ALG_WHEN_A;
extern jl_function_t *Absyn_Algorithm_ALG_WHEN_A_type;
static inline jl_value_t *Absyn__ALG_5fWHEN_5fA(jl_value_t *boolExpr, jl_value_t *whenBody, jl_value_t *elseWhenAlgorithmBranch) {
return jl_call3(Absyn_Algorithm_ALG_WHEN_A, boolExpr, whenBody, elseWhenAlgorithmBranch);
}
extern jl_function_t *Absyn_Algorithm_ALG_WHILE;
extern jl_function_t *Absyn_Algorithm_ALG_WHILE_type;
static inline jl_value_t *Absyn__ALG_5fWHILE(jl_value_t *boolExpr, jl_value_t *whileBody) {
return jl_call2(Absyn_Algorithm_ALG_WHILE, boolExpr, whileBody);
}
/* End External declarations for the uniontypeAbsyn.Algorithm */
/* External declarations for the uniontype: Absyn.AlgorithmItem*/
extern jl_value_t *Absyn_AlgorithmItem;
extern jl_function_t *Absyn_AlgorithmItem_ALGORITHMITEM;
extern jl_function_t *Absyn_AlgorithmItem_ALGORITHMITEM_type;
static inline jl_value_t *Absyn__ALGORITHMITEM(jl_value_t *algorithm_, jl_value_t *comment, jl_value_t *info) {
return jl_call3(Absyn_AlgorithmItem_ALGORITHMITEM, algorithm_, comment, info);
}
extern jl_function_t *Absyn_AlgorithmItem_ALGORITHMITEMCOMMENT;
extern jl_function_t *Absyn_AlgorithmItem_ALGORITHMITEMCOMMENT_type;
static inline jl_value_t *Absyn__ALGORITHMITEMCOMMENT(jl_value_t *comment) {
return jl_call1(Absyn_AlgorithmItem_ALGORITHMITEMCOMMENT, comment);
}
/* End External declarations for the uniontypeAbsyn.AlgorithmItem */
/* External declarations for the uniontype: Absyn.Annotation*/
extern jl_value_t *Absyn_Annotation;
extern jl_function_t *Absyn_Annotation_ANNOTATION;
extern jl_function_t *Absyn_Annotation_ANNOTATION_type;
static inline jl_value_t *Absyn__ANNOTATION(jl_value_t *elementArgs) {
return jl_call1(Absyn_Annotation_ANNOTATION, elementArgs);
}
/* End External declarations for the uniontypeAbsyn.Annotation */
/* External declarations for the uniontype: Absyn.Case*/
extern jl_value_t *Absyn_Case;
extern jl_function_t *Absyn_Case_CASE;
extern jl_function_t *Absyn_Case_CASE_type;
static inline jl_value_t *Absyn__CASE(jl_value_t *pattern, jl_value_t *patternGuard, jl_value_t *patternInfo, jl_value_t *localDecls, jl_value_t *classPart, jl_value_t *result, jl_value_t *resultInfo, jl_value_t *comment, jl_value_t *info) {
jl_value_t *values[9] = {pattern, patternGuard, patternInfo, localDecls, classPart, result, resultInfo, comment, info};
return jl_call(Absyn_Case_CASE, values, 9);
}
extern jl_function_t *Absyn_Case_ELSE;
extern jl_function_t *Absyn_Case_ELSE_type;
static inline jl_value_t *Absyn__ELSE(jl_value_t *localDecls, jl_value_t *classPart, jl_value_t *result, jl_value_t *resultInfo, jl_value_t *comment, jl_value_t *info) {
jl_value_t *values[6] = {localDecls, classPart, result, resultInfo, comment, info};
return jl_call(Absyn_Case_ELSE, values, 6);
}
/* End External declarations for the uniontypeAbsyn.Case */
/* External declarations for the uniontype: Absyn.Class*/
extern jl_value_t *Absyn_Class;
extern jl_function_t *Absyn_Class_CLASS;
extern jl_function_t *Absyn_Class_CLASS_type;
static inline jl_value_t *Absyn__CLASS(jl_value_t *name, jl_value_t *partialPrefix, jl_value_t *finalPrefix, jl_value_t *encapsulatedPrefix, jl_value_t *restriction, jl_value_t *body, jl_value_t *info) {
jl_value_t *values[7] = {name, partialPrefix, finalPrefix, encapsulatedPrefix, restriction, body, info};
return jl_call(Absyn_Class_CLASS, values, 7);
}
/* End External declarations for the uniontypeAbsyn.Class */
/* External declarations for the uniontype: Absyn.ClassDef*/
extern jl_value_t *Absyn_ClassDef;
extern jl_function_t *Absyn_ClassDef_CLASS_EXTENDS;
extern jl_function_t *Absyn_ClassDef_CLASS_EXTENDS_type;
static inline jl_value_t *Absyn__CLASS_5fEXTENDS(jl_value_t *baseClassName, jl_value_t *modifications, jl_value_t *comment, jl_value_t *parts, jl_value_t *ann) {
jl_value_t *values[5] = {baseClassName, modifications, comment, parts, ann};
return jl_call(Absyn_ClassDef_CLASS_EXTENDS, values, 5);
}
extern jl_function_t *Absyn_ClassDef_DERIVED;
extern jl_function_t *Absyn_ClassDef_DERIVED_type;
static inline jl_value_t *Absyn__DERIVED(jl_value_t *typeSpec, jl_value_t *attributes, jl_value_t *arguments, jl_value_t *comment) {
jl_value_t *values[4] = {typeSpec, attributes, arguments, comment};
return jl_call(Absyn_ClassDef_DERIVED, values, 4);
}
extern jl_function_t *Absyn_ClassDef_ENUMERATION;
extern jl_function_t *Absyn_ClassDef_ENUMERATION_type;
static inline jl_value_t *Absyn__ENUMERATION(jl_value_t *enumLiterals, jl_value_t *comment) {
return jl_call2(Absyn_ClassDef_ENUMERATION, enumLiterals, comment);
}
extern jl_function_t *Absyn_ClassDef_OVERLOAD;
extern jl_function_t *Absyn_ClassDef_OVERLOAD_type;
static inline jl_value_t *Absyn__OVERLOAD(jl_value_t *functionNames, jl_value_t *comment) {
return jl_call2(Absyn_ClassDef_OVERLOAD, functionNames, comment);
}
extern jl_function_t *Absyn_ClassDef_PARTS;
extern jl_function_t *Absyn_ClassDef_PARTS_type;
static inline jl_value_t *Absyn__PARTS(jl_value_t *typeVars, jl_value_t *classAttrs, jl_value_t *classParts, jl_value_t *ann, jl_value_t *comment) {
jl_value_t *values[5] = {typeVars, classAttrs, classParts, ann, comment};
return jl_call(Absyn_ClassDef_PARTS, values, 5);
}
extern jl_function_t *Absyn_ClassDef_PDER;
extern jl_function_t *Absyn_ClassDef_PDER_type;
static inline jl_value_t *Absyn__PDER(jl_value_t *functionName, jl_value_t *vars, jl_value_t *comment) {
return jl_call3(Absyn_ClassDef_PDER, functionName, vars, comment);
}
/* End External declarations for the uniontypeAbsyn.ClassDef */
/* External declarations for the uniontype: Absyn.ClassPart*/
extern jl_value_t *Absyn_ClassPart;
extern jl_function_t *Absyn_ClassPart_ALGORITHMS;
extern jl_function_t *Absyn_ClassPart_ALGORITHMS_type;
static inline jl_value_t *Absyn__ALGORITHMS(jl_value_t *contents) {
return jl_call1(Absyn_ClassPart_ALGORITHMS, contents);
}
extern jl_function_t *Absyn_ClassPart_CONSTRAINTS;
extern jl_function_t *Absyn_ClassPart_CONSTRAINTS_type;
static inline jl_value_t *Absyn__CONSTRAINTS(jl_value_t *contents) {
return jl_call1(Absyn_ClassPart_CONSTRAINTS, contents);
}
extern jl_function_t *Absyn_ClassPart_EQUATIONS;
extern jl_function_t *Absyn_ClassPart_EQUATIONS_type;
static inline jl_value_t *Absyn__EQUATIONS(jl_value_t *contents) {
return jl_call1(Absyn_ClassPart_EQUATIONS, contents);
}
extern jl_function_t *Absyn_ClassPart_EXTERNAL;
extern jl_function_t *Absyn_ClassPart_EXTERNAL_type;
static inline jl_value_t *Absyn__EXTERNAL(jl_value_t *externalDecl, jl_value_t *annotation_) {
return jl_call2(Absyn_ClassPart_EXTERNAL, externalDecl, annotation_);
}
extern jl_function_t *Absyn_ClassPart_INITIALALGORITHMS;
extern jl_function_t *Absyn_ClassPart_INITIALALGORITHMS_type;
static inline jl_value_t *Absyn__INITIALALGORITHMS(jl_value_t *contents) {
return jl_call1(Absyn_ClassPart_INITIALALGORITHMS, contents);
}
extern jl_function_t *Absyn_ClassPart_INITIALEQUATIONS;
extern jl_function_t *Absyn_ClassPart_INITIALEQUATIONS_type;
static inline jl_value_t *Absyn__INITIALEQUATIONS(jl_value_t *contents) {
return jl_call1(Absyn_ClassPart_INITIALEQUATIONS, contents);
}
extern jl_function_t *Absyn_ClassPart_PROTECTED;
extern jl_function_t *Absyn_ClassPart_PROTECTED_type;
static inline jl_value_t *Absyn__PROTECTED(jl_value_t *contents) {
return jl_call1(Absyn_ClassPart_PROTECTED, contents);
}
extern jl_function_t *Absyn_ClassPart_PUBLIC;
extern jl_function_t *Absyn_ClassPart_PUBLIC_type;
static inline jl_value_t *Absyn__PUBLIC(jl_value_t *contents) {
return jl_call1(Absyn_ClassPart_PUBLIC, contents);
}
/* End External declarations for the uniontypeAbsyn.ClassPart */
/* External declarations for the uniontype: Absyn.CodeNode*/
extern jl_value_t *Absyn_CodeNode;
extern jl_function_t *Absyn_CodeNode_C_ALGORITHMSECTION;
extern jl_function_t *Absyn_CodeNode_C_ALGORITHMSECTION_type;
static inline jl_value_t *Absyn__C_5fALGORITHMSECTION(jl_value_t *boolean, jl_value_t *algorithmItemLst) {
return jl_call2(Absyn_CodeNode_C_ALGORITHMSECTION, boolean, algorithmItemLst);
}
extern jl_function_t *Absyn_CodeNode_C_CONSTRAINTSECTION;
extern jl_function_t *Absyn_CodeNode_C_CONSTRAINTSECTION_type;
static inline jl_value_t *Absyn__C_5fCONSTRAINTSECTION(jl_value_t *boolean, jl_value_t *equationItemLst) {
return jl_call2(Absyn_CodeNode_C_CONSTRAINTSECTION, boolean, equationItemLst);
}
extern jl_function_t *Absyn_CodeNode_C_ELEMENT;
extern jl_function_t *Absyn_CodeNode_C_ELEMENT_type;
static inline jl_value_t *Absyn__C_5fELEMENT(jl_value_t *element) {
return jl_call1(Absyn_CodeNode_C_ELEMENT, element);
}
extern jl_function_t *Absyn_CodeNode_C_EQUATIONSECTION;
extern jl_function_t *Absyn_CodeNode_C_EQUATIONSECTION_type;
static inline jl_value_t *Absyn__C_5fEQUATIONSECTION(jl_value_t *boolean, jl_value_t *equationItemLst) {
return jl_call2(Absyn_CodeNode_C_EQUATIONSECTION, boolean, equationItemLst);
}
extern jl_function_t *Absyn_CodeNode_C_EXPRESSION;
extern jl_function_t *Absyn_CodeNode_C_EXPRESSION_type;
static inline jl_value_t *Absyn__C_5fEXPRESSION(jl_value_t *exp) {
return jl_call1(Absyn_CodeNode_C_EXPRESSION, exp);
}
extern jl_function_t *Absyn_CodeNode_C_MODIFICATION;
extern jl_function_t *Absyn_CodeNode_C_MODIFICATION_type;
static inline jl_value_t *Absyn__C_5fMODIFICATION(jl_value_t *modification) {
return jl_call1(Absyn_CodeNode_C_MODIFICATION, modification);
}
extern jl_function_t *Absyn_CodeNode_C_TYPENAME;
extern jl_function_t *Absyn_CodeNode_C_TYPENAME_type;
static inline jl_value_t *Absyn__C_5fTYPENAME(jl_value_t *path) {
return jl_call1(Absyn_CodeNode_C_TYPENAME, path);
}
extern jl_function_t *Absyn_CodeNode_C_VARIABLENAME;
extern jl_function_t *Absyn_CodeNode_C_VARIABLENAME_type;
static inline jl_value_t *Absyn__C_5fVARIABLENAME(jl_value_t *componentRef) {
return jl_call1(Absyn_CodeNode_C_VARIABLENAME, componentRef);
}
/* End External declarations for the uniontypeAbsyn.CodeNode */
/* External declarations for the uniontype: Absyn.Comment*/
extern jl_value_t *Absyn_Comment;
extern jl_function_t *Absyn_Comment_COMMENT;
extern jl_function_t *Absyn_Comment_COMMENT_type;
static inline jl_value_t *Absyn__COMMENT(jl_value_t *annotation_, jl_value_t *comment) {
return jl_call2(Absyn_Comment_COMMENT, annotation_, comment);
}
/* End External declarations for the uniontypeAbsyn.Comment */
/* External declarations for the uniontype: Absyn.Component*/
extern jl_value_t *Absyn_Component;
extern jl_function_t *Absyn_Component_COMPONENT;
extern jl_function_t *Absyn_Component_COMPONENT_type;
static inline jl_value_t *Absyn__COMPONENT(jl_value_t *name, jl_value_t *arrayDim, jl_value_t *modification) {
return jl_call3(Absyn_Component_COMPONENT, name, arrayDim, modification);
}
/* End External declarations for the uniontypeAbsyn.Component */
/* External declarations for the uniontype: Absyn.Exp*/
extern jl_value_t *Absyn_Exp;
extern jl_function_t *Absyn_Exp_ARRAY;
extern jl_function_t *Absyn_Exp_ARRAY_type;
static inline jl_value_t *Absyn__ARRAY(jl_value_t *arrayExp) {
return jl_call1(Absyn_Exp_ARRAY, arrayExp);
}
extern jl_function_t *Absyn_Exp_AS;
extern jl_function_t *Absyn_Exp_AS_type;
static inline jl_value_t *Absyn__AS(jl_value_t *id, jl_value_t *exp) {
return jl_call2(Absyn_Exp_AS, id, exp);
}
extern jl_function_t *Absyn_Exp_BINARY;
extern jl_function_t *Absyn_Exp_BINARY_type;
static inline jl_value_t *Absyn__BINARY(jl_value_t *exp1, jl_value_t *op, jl_value_t *exp2) {
return jl_call3(Absyn_Exp_BINARY, exp1, op, exp2);
}
extern jl_function_t *Absyn_Exp_BOOL;
extern jl_function_t *Absyn_Exp_BOOL_type;
static inline jl_value_t *Absyn__BOOL(jl_value_t *value) {
return jl_call1(Absyn_Exp_BOOL, value);
}
extern jl_function_t *Absyn_Exp_CALL;
extern jl_function_t *Absyn_Exp_CALL_type;
static inline jl_value_t *Absyn__CALL(jl_value_t *function_, jl_value_t *functionArgs, jl_value_t *typeVars) {
return jl_call3(Absyn_Exp_CALL, function_, functionArgs, typeVars);
}
extern jl_function_t *Absyn_Exp_CODE;
extern jl_function_t *Absyn_Exp_CODE_type;
static inline jl_value_t *Absyn__CODE(jl_value_t *code) {
return jl_call1(Absyn_Exp_CODE, code);
}
extern jl_function_t *Absyn_Exp_CONS;
extern jl_function_t *Absyn_Exp_CONS_type;
static inline jl_value_t *Absyn__CONS(jl_value_t *head, jl_value_t *rest) {
return jl_call2(Absyn_Exp_CONS, head, rest);
}
extern jl_function_t *Absyn_Exp_CREF;
extern jl_function_t *Absyn_Exp_CREF_type;
static inline jl_value_t *Absyn__CREF(jl_value_t *componentRef) {
return jl_call1(Absyn_Exp_CREF, componentRef);
}
extern jl_function_t *Absyn_Exp_DOT;
extern jl_function_t *Absyn_Exp_DOT_type;
static inline jl_value_t *Absyn__DOT(jl_value_t *exp, jl_value_t *index) {
return jl_call2(Absyn_Exp_DOT, exp, index);
}
extern jl_function_t *Absyn_Exp_END;
extern jl_function_t *Absyn_Exp_END_type;
#define Absyn__END jl_call0(Absyn_Exp_END)
extern jl_function_t *Absyn_Exp_IFEXP;
extern jl_function_t *Absyn_Exp_IFEXP_type;
static inline jl_value_t *Absyn__IFEXP(jl_value_t *ifExp, jl_value_t *trueBranch, jl_value_t *elseBranch, jl_value_t *elseIfBranch) {
jl_value_t *values[4] = {ifExp, trueBranch, elseBranch, elseIfBranch};
return jl_call(Absyn_Exp_IFEXP, values, 4);
}
extern jl_function_t *Absyn_Exp_INTEGER;
extern jl_function_t *Absyn_Exp_INTEGER_type;
static inline jl_value_t *Absyn__INTEGER(jl_value_t *value) {
return jl_call1(Absyn_Exp_INTEGER, value);
}
extern jl_function_t *Absyn_Exp_LBINARY;
extern jl_function_t *Absyn_Exp_LBINARY_type;
static inline jl_value_t *Absyn__LBINARY(jl_value_t *exp1, jl_value_t *op, jl_value_t *exp2) {
return jl_call3(Absyn_Exp_LBINARY, exp1, op, exp2);
}
extern jl_function_t *Absyn_Exp_LIST;
extern jl_function_t *Absyn_Exp_LIST_type;
static inline jl_value_t *Absyn__LIST(jl_value_t *exps) {
return jl_call1(Absyn_Exp_LIST, exps);
}
extern jl_function_t *Absyn_Exp_LUNARY;
extern jl_function_t *Absyn_Exp_LUNARY_type;
static inline jl_value_t *Absyn__LUNARY(jl_value_t *op, jl_value_t *exp) {
return jl_call2(Absyn_Exp_LUNARY, op, exp);
}
extern jl_function_t *Absyn_Exp_MATCHEXP;
extern jl_function_t *Absyn_Exp_MATCHEXP_type;
static inline jl_value_t *Absyn__MATCHEXP(jl_value_t *matchTy, jl_value_t *inputExp, jl_value_t *localDecls, jl_value_t *cases, jl_value_t *comment) {
jl_value_t *values[5] = {matchTy, inputExp, localDecls, cases, comment};
return jl_call(Absyn_Exp_MATCHEXP, values, 5);
}
extern jl_function_t *Absyn_Exp_MATRIX;
extern jl_function_t *Absyn_Exp_MATRIX_type;
static inline jl_value_t *Absyn__MATRIX(jl_value_t *matrix) {
return jl_call1(Absyn_Exp_MATRIX, matrix);
}
extern jl_function_t *Absyn_Exp_PARTEVALFUNCTION;
extern jl_function_t *Absyn_Exp_PARTEVALFUNCTION_type;
static inline jl_value_t *Absyn__PARTEVALFUNCTION(jl_value_t *function_, jl_value_t *functionArgs) {
return jl_call2(Absyn_Exp_PARTEVALFUNCTION, function_, functionArgs);
}
extern jl_function_t *Absyn_Exp_RANGE;
extern jl_function_t *Absyn_Exp_RANGE_type;
static inline jl_value_t *Absyn__RANGE(jl_value_t *start, jl_value_t *step, jl_value_t *stop) {
return jl_call3(Absyn_Exp_RANGE, start, step, stop);
}
extern jl_function_t *Absyn_Exp_REAL;
extern jl_function_t *Absyn_Exp_REAL_type;
static inline jl_value_t *Absyn__REAL(jl_value_t *value) {
return jl_call1(Absyn_Exp_REAL, value);
}
extern jl_function_t *Absyn_Exp_RELATION;
extern jl_function_t *Absyn_Exp_RELATION_type;
static inline jl_value_t *Absyn__RELATION(jl_value_t *exp1, jl_value_t *op, jl_value_t *exp2) {
return jl_call3(Absyn_Exp_RELATION, exp1, op, exp2);
}
extern jl_function_t *Absyn_Exp_STRING;
extern jl_function_t *Absyn_Exp_STRING_type;
static inline jl_value_t *Absyn__STRING(jl_value_t *value) {
return jl_call1(Absyn_Exp_STRING, value);
}
extern jl_function_t *Absyn_Exp_TUPLE;
extern jl_function_t *Absyn_Exp_TUPLE_type;
static inline jl_value_t *Absyn__TUPLE(jl_value_t *expressions) {
return jl_call1(Absyn_Exp_TUPLE, expressions);
}
extern jl_function_t *Absyn_Exp_UNARY;
extern jl_function_t *Absyn_Exp_UNARY_type;
static inline jl_value_t *Absyn__UNARY(jl_value_t *op, jl_value_t *exp) {
return jl_call2(Absyn_Exp_UNARY, op, exp);
}
/* End External declarations for the uniontypeAbsyn.Exp */
/* External declarations for the uniontype: Absyn.ComponentItem*/
extern jl_value_t *Absyn_ComponentItem;
extern jl_function_t *Absyn_ComponentItem_COMPONENTITEM;
extern jl_function_t *Absyn_ComponentItem_COMPONENTITEM_type;
static inline jl_value_t *Absyn__COMPONENTITEM(jl_value_t *component, jl_value_t *condition, jl_value_t *comment) {
return jl_call3(Absyn_ComponentItem_COMPONENTITEM, component, condition, comment);
}
/* End External declarations for the uniontypeAbsyn.ComponentItem */
/* External declarations for the uniontype: Absyn.ComponentRef*/
extern jl_value_t *Absyn_ComponentRef;
extern jl_function_t *Absyn_ComponentRef_ALLWILD;
extern jl_function_t *Absyn_ComponentRef_ALLWILD_type;
#define Absyn__ALLWILD jl_call0(Absyn_ComponentRef_ALLWILD)
extern jl_function_t *Absyn_ComponentRef_CREF_FULLYQUALIFIED;
extern jl_function_t *Absyn_ComponentRef_CREF_FULLYQUALIFIED_type;
static inline jl_value_t *Absyn__CREF_5fFULLYQUALIFIED(jl_value_t *componentRef) {
return jl_call1(Absyn_ComponentRef_CREF_FULLYQUALIFIED, componentRef);
}
extern jl_function_t *Absyn_ComponentRef_CREF_IDENT;
extern jl_function_t *Absyn_ComponentRef_CREF_IDENT_type;
static inline jl_value_t *Absyn__CREF_5fIDENT(jl_value_t *name, jl_value_t *subscripts) {
return jl_call2(Absyn_ComponentRef_CREF_IDENT, name, subscripts);
}
extern jl_function_t *Absyn_ComponentRef_CREF_QUAL;
extern jl_function_t *Absyn_ComponentRef_CREF_QUAL_type;
static inline jl_value_t *Absyn__CREF_5fQUAL(jl_value_t *name, jl_value_t *subscripts, jl_value_t *componentRef) {
return jl_call3(Absyn_ComponentRef_CREF_QUAL, name, subscripts, componentRef);
}
extern jl_function_t *Absyn_ComponentRef_WILD;
extern jl_function_t *Absyn_ComponentRef_WILD_type;
#define Absyn__WILD jl_call0(Absyn_ComponentRef_WILD)
/* End External declarations for the uniontypeAbsyn.ComponentRef */
/* External declarations for the uniontype: Absyn.ConstrainClass*/
extern jl_value_t *Absyn_ConstrainClass;
extern jl_function_t *Absyn_ConstrainClass_CONSTRAINCLASS;
extern jl_function_t *Absyn_ConstrainClass_CONSTRAINCLASS_type;
static inline jl_value_t *Absyn__CONSTRAINCLASS(jl_value_t *elementSpec, jl_value_t *comment) {
return jl_call2(Absyn_ConstrainClass_CONSTRAINCLASS, elementSpec, comment);
}
/* End External declarations for the uniontypeAbsyn.ConstrainClass */
/* External declarations for the uniontype: Absyn.Direction*/
extern jl_value_t *Absyn_Direction;
extern jl_function_t *Absyn_Direction_BIDIR;
extern jl_function_t *Absyn_Direction_BIDIR_type;
#define Absyn__BIDIR jl_call0(Absyn_Direction_BIDIR)
extern jl_function_t *Absyn_Direction_INPUT;
extern jl_function_t *Absyn_Direction_INPUT_type;
#define Absyn__INPUT jl_call0(Absyn_Direction_INPUT)
extern jl_function_t *Absyn_Direction_INPUT_OUTPUT;
extern jl_function_t *Absyn_Direction_INPUT_OUTPUT_type;
#define Absyn__INPUT_5fOUTPUT jl_call0(Absyn_Direction_INPUT_OUTPUT)
extern jl_function_t *Absyn_Direction_OUTPUT;
extern jl_function_t *Absyn_Direction_OUTPUT_type;
#define Absyn__OUTPUT jl_call0(Absyn_Direction_OUTPUT)
/* End External declarations for the uniontypeAbsyn.Direction */
/* External declarations for the uniontype: Absyn.Each*/
extern jl_value_t *Absyn_Each;
extern jl_function_t *Absyn_Each_EACH;
extern jl_function_t *Absyn_Each_EACH_type;
#define Absyn__EACH jl_call0(Absyn_Each_EACH)
extern jl_function_t *Absyn_Each_NON_EACH;
extern jl_function_t *Absyn_Each_NON_EACH_type;
#define Absyn__NON_5fEACH jl_call0(Absyn_Each_NON_EACH)
/* End External declarations for the uniontypeAbsyn.Each */
/* External declarations for the uniontype: Absyn.Element*/
extern jl_value_t *Absyn_Element;
extern jl_function_t *Absyn_Element_DEFINEUNIT;
extern jl_function_t *Absyn_Element_DEFINEUNIT_type;
static inline jl_value_t *Absyn__DEFINEUNIT(jl_value_t *name, jl_value_t *args, jl_value_t *info) {
return jl_call3(Absyn_Element_DEFINEUNIT, name, args, info);
}
extern jl_function_t *Absyn_Element_ELEMENT;
extern jl_function_t *Absyn_Element_ELEMENT_type;
static inline jl_value_t *Absyn__ELEMENT(jl_value_t *finalPrefix, jl_value_t *redeclareKeywords, jl_value_t *innerOuter, jl_value_t *specification, jl_value_t *info, jl_value_t *constrainClass) {
jl_value_t *values[6] = {finalPrefix, redeclareKeywords, innerOuter, specification, info, constrainClass};
return jl_call(Absyn_Element_ELEMENT, values, 6);
}
extern jl_function_t *Absyn_Element_TEXT;
extern jl_function_t *Absyn_Element_TEXT_type;
static inline jl_value_t *Absyn__TEXT(jl_value_t *optName, jl_value_t *string, jl_value_t *info) {
return jl_call3(Absyn_Element_TEXT, optName, string, info);
}
/* End External declarations for the uniontypeAbsyn.Element */
/* External declarations for the uniontype: Absyn.ElementArg*/
extern jl_value_t *Absyn_ElementArg;
extern jl_function_t *Absyn_ElementArg_MODIFICATION;
extern jl_function_t *Absyn_ElementArg_MODIFICATION_type;
static inline jl_value_t *Absyn__MODIFICATION(jl_value_t *finalPrefix, jl_value_t *eachPrefix, jl_value_t *path, jl_value_t *modification, jl_value_t *comment, jl_value_t *info) {
jl_value_t *values[6] = {finalPrefix, eachPrefix, path, modification, comment, info};
return jl_call(Absyn_ElementArg_MODIFICATION, values, 6);
}
extern jl_function_t *Absyn_ElementArg_REDECLARATION;
extern jl_function_t *Absyn_ElementArg_REDECLARATION_type;
static inline jl_value_t *Absyn__REDECLARATION(jl_value_t *finalPrefix, jl_value_t *redeclareKeywords, jl_value_t *eachPrefix, jl_value_t *elementSpec, jl_value_t *constrainClass, jl_value_t *info) {
jl_value_t *values[6] = {finalPrefix, redeclareKeywords, eachPrefix, elementSpec, constrainClass, info};
return jl_call(Absyn_ElementArg_REDECLARATION, values, 6);
}
/* End External declarations for the uniontypeAbsyn.ElementArg */
/* External declarations for the uniontype: Absyn.ElementAttributes*/
extern jl_value_t *Absyn_ElementAttributes;
extern jl_function_t *Absyn_ElementAttributes_ATTR;
extern jl_function_t *Absyn_ElementAttributes_ATTR_type;
static inline jl_value_t *Absyn__ATTR(jl_value_t *flowPrefix, jl_value_t *streamPrefix, jl_value_t *parallelism, jl_value_t *variability, jl_value_t *direction, jl_value_t *isField, jl_value_t *arrayDim) {
jl_value_t *values[7] = {flowPrefix, streamPrefix, parallelism, variability, direction, isField, arrayDim};
return jl_call(Absyn_ElementAttributes_ATTR, values, 7);
}
/* End External declarations for the uniontypeAbsyn.ElementAttributes */
/* External declarations for the uniontype: Absyn.ElementItem*/
extern jl_value_t *Absyn_ElementItem;
extern jl_function_t *Absyn_ElementItem_ELEMENTITEM;
extern jl_function_t *Absyn_ElementItem_ELEMENTITEM_type;
static inline jl_value_t *Absyn__ELEMENTITEM(jl_value_t *element) {
return jl_call1(Absyn_ElementItem_ELEMENTITEM, element);
}
extern jl_function_t *Absyn_ElementItem_LEXER_COMMENT;
extern jl_function_t *Absyn_ElementItem_LEXER_COMMENT_type;
static inline jl_value_t *Absyn__LEXER_5fCOMMENT(jl_value_t *comment) {
return jl_call1(Absyn_ElementItem_LEXER_COMMENT, comment);
}
/* End External declarations for the uniontypeAbsyn.ElementItem */
/* External declarations for the uniontype: Absyn.ElementSpec*/
extern jl_value_t *Absyn_ElementSpec;
extern jl_function_t *Absyn_ElementSpec_CLASSDEF;
extern jl_function_t *Absyn_ElementSpec_CLASSDEF_type;
static inline jl_value_t *Absyn__CLASSDEF(jl_value_t *replaceable_, jl_value_t *class_) {
return jl_call2(Absyn_ElementSpec_CLASSDEF, replaceable_, class_);
}
extern jl_function_t *Absyn_ElementSpec_COMPONENTS;
extern jl_function_t *Absyn_ElementSpec_COMPONENTS_type;
static inline jl_value_t *Absyn__COMPONENTS(jl_value_t *attributes, jl_value_t *typeSpec, jl_value_t *components) {
return jl_call3(Absyn_ElementSpec_COMPONENTS, attributes, typeSpec, components);
}
extern jl_function_t *Absyn_ElementSpec_EXTENDS;
extern jl_function_t *Absyn_ElementSpec_EXTENDS_type;
static inline jl_value_t *Absyn__EXTENDS(jl_value_t *path, jl_value_t *elementArg, jl_value_t *annotationOpt) {
return jl_call3(Absyn_ElementSpec_EXTENDS, path, elementArg, annotationOpt);
}
extern jl_function_t *Absyn_ElementSpec_IMPORT;
extern jl_function_t *Absyn_ElementSpec_IMPORT_type;
static inline jl_value_t *Absyn__IMPORT(jl_value_t *import_, jl_value_t *comment, jl_value_t *info) {
return jl_call3(Absyn_ElementSpec_IMPORT, import_, comment, info);
}
/* End External declarations for the uniontypeAbsyn.ElementSpec */
/* External declarations for the uniontype: Absyn.EnumDef*/
extern jl_value_t *Absyn_EnumDef;
extern jl_function_t *Absyn_EnumDef_ENUMLITERALS;
extern jl_function_t *Absyn_EnumDef_ENUMLITERALS_type;
static inline jl_value_t *Absyn__ENUMLITERALS(jl_value_t *enumLiterals) {
return jl_call1(Absyn_EnumDef_ENUMLITERALS, enumLiterals);
}
extern jl_function_t *Absyn_EnumDef_ENUM_COLON;
extern jl_function_t *Absyn_EnumDef_ENUM_COLON_type;
#define Absyn__ENUM_5fCOLON jl_call0(Absyn_EnumDef_ENUM_COLON)
/* End External declarations for the uniontypeAbsyn.EnumDef */
/* External declarations for the uniontype: Absyn.EnumLiteral*/
extern jl_value_t *Absyn_EnumLiteral;
extern jl_function_t *Absyn_EnumLiteral_ENUMLITERAL;
extern jl_function_t *Absyn_EnumLiteral_ENUMLITERAL_type;
static inline jl_value_t *Absyn__ENUMLITERAL(jl_value_t *literal, jl_value_t *comment) {
return jl_call2(Absyn_EnumLiteral_ENUMLITERAL, literal, comment);
}
/* End External declarations for the uniontypeAbsyn.EnumLiteral */
/* External declarations for the uniontype: Absyn.EqMod*/
extern jl_value_t *Absyn_EqMod;
extern jl_function_t *Absyn_EqMod_EQMOD;
extern jl_function_t *Absyn_EqMod_EQMOD_type;
static inline jl_value_t *Absyn__EQMOD(jl_value_t *exp, jl_value_t *info) {
return jl_call2(Absyn_EqMod_EQMOD, exp, info);
}
extern jl_function_t *Absyn_EqMod_NOMOD;
extern jl_function_t *Absyn_EqMod_NOMOD_type;
#define Absyn__NOMOD jl_call0(Absyn_EqMod_NOMOD)
/* End External declarations for the uniontypeAbsyn.EqMod */
/* External declarations for the uniontype: Absyn.Equation*/
extern jl_value_t *Absyn_Equation;
extern jl_function_t *Absyn_Equation_EQ_CONNECT;
extern jl_function_t *Absyn_Equation_EQ_CONNECT_type;
static inline jl_value_t *Absyn__EQ_5fCONNECT(jl_value_t *connector1, jl_value_t *connector2) {
return jl_call2(Absyn_Equation_EQ_CONNECT, connector1, connector2);
}
extern jl_function_t *Absyn_Equation_EQ_EQUALS;
extern jl_function_t *Absyn_Equation_EQ_EQUALS_type;
static inline jl_value_t *Absyn__EQ_5fEQUALS(jl_value_t *leftSide, jl_value_t *rightSide) {
return jl_call2(Absyn_Equation_EQ_EQUALS, leftSide, rightSide);
}
extern jl_function_t *Absyn_Equation_EQ_FAILURE;
extern jl_function_t *Absyn_Equation_EQ_FAILURE_type;
static inline jl_value_t *Absyn__EQ_5fFAILURE(jl_value_t *equ) {
return jl_call1(Absyn_Equation_EQ_FAILURE, equ);
}
extern jl_function_t *Absyn_Equation_EQ_FOR;
extern jl_function_t *Absyn_Equation_EQ_FOR_type;
static inline jl_value_t *Absyn__EQ_5fFOR(jl_value_t *iterators, jl_value_t *forEquations) {
return jl_call2(Absyn_Equation_EQ_FOR, iterators, forEquations);
}
extern jl_function_t *Absyn_Equation_EQ_IF;
extern jl_function_t *Absyn_Equation_EQ_IF_type;
static inline jl_value_t *Absyn__EQ_5fIF(jl_value_t *ifExp, jl_value_t *equationTrueItems, jl_value_t *elseIfBranches, jl_value_t *equationElseItems) {
jl_value_t *values[4] = {ifExp, equationTrueItems, elseIfBranches, equationElseItems};
return jl_call(Absyn_Equation_EQ_IF, values, 4);
}
extern jl_function_t *Absyn_Equation_EQ_NORETCALL;
extern jl_function_t *Absyn_Equation_EQ_NORETCALL_type;
static inline jl_value_t *Absyn__EQ_5fNORETCALL(jl_value_t *functionName, jl_value_t *functionArgs) {
return jl_call2(Absyn_Equation_EQ_NORETCALL, functionName, functionArgs);
}
extern jl_function_t *Absyn_Equation_EQ_PDE;
extern jl_function_t *Absyn_Equation_EQ_PDE_type;
static inline jl_value_t *Absyn__EQ_5fPDE(jl_value_t *leftSide, jl_value_t *rightSide, jl_value_t *domain) {
return jl_call3(Absyn_Equation_EQ_PDE, leftSide, rightSide, domain);
}
extern jl_function_t *Absyn_Equation_EQ_WHEN_E;
extern jl_function_t *Absyn_Equation_EQ_WHEN_E_type;
static inline jl_value_t *Absyn__EQ_5fWHEN_5fE(jl_value_t *whenExp, jl_value_t *whenEquations, jl_value_t *elseWhenEquations) {
return jl_call3(Absyn_Equation_EQ_WHEN_E, whenExp, whenEquations, elseWhenEquations);
}
/* End External declarations for the uniontypeAbsyn.Equation */
/* External declarations for the uniontype: Absyn.EquationItem*/
extern jl_value_t *Absyn_EquationItem;
extern jl_function_t *Absyn_EquationItem_EQUATIONITEM;
extern jl_function_t *Absyn_EquationItem_EQUATIONITEM_type;
static inline jl_value_t *Absyn__EQUATIONITEM(jl_value_t *equation_, jl_value_t *comment, jl_value_t *info) {
return jl_call3(Absyn_EquationItem_EQUATIONITEM, equation_, comment, info);
}
extern jl_function_t *Absyn_EquationItem_EQUATIONITEMCOMMENT;
extern jl_function_t *Absyn_EquationItem_EQUATIONITEMCOMMENT_type;
static inline jl_value_t *Absyn__EQUATIONITEMCOMMENT(jl_value_t *comment) {
return jl_call1(Absyn_EquationItem_EQUATIONITEMCOMMENT, comment);
}
/* End External declarations for the uniontypeAbsyn.EquationItem */
/* External declarations for the uniontype: Absyn.ExternalDecl*/
extern jl_value_t *Absyn_ExternalDecl;
extern jl_function_t *Absyn_ExternalDecl_EXTERNALDECL;
extern jl_function_t *Absyn_ExternalDecl_EXTERNALDECL_type;
static inline jl_value_t *Absyn__EXTERNALDECL(jl_value_t *funcName, jl_value_t *lang, jl_value_t *output_, jl_value_t *args, jl_value_t *annotation_) {
jl_value_t *values[5] = {funcName, lang, output_, args, annotation_};
return jl_call(Absyn_ExternalDecl_EXTERNALDECL, values, 5);
}
/* End External declarations for the uniontypeAbsyn.ExternalDecl */
/* External declarations for the uniontype: Absyn.FlowStream*/
extern jl_value_t *Absyn_FlowStream;
extern jl_function_t *Absyn_FlowStream_FLOW;
extern jl_function_t *Absyn_FlowStream_FLOW_type;
#define Absyn__FLOW jl_call0(Absyn_FlowStream_FLOW)
extern jl_function_t *Absyn_FlowStream_NOT_FLOW_STREAM;
extern jl_function_t *Absyn_FlowStream_NOT_FLOW_STREAM_type;
#define Absyn__NOT_5fFLOW_5fSTREAM jl_call0(Absyn_FlowStream_NOT_FLOW_STREAM)
extern jl_function_t *Absyn_FlowStream_STREAM;
extern jl_function_t *Absyn_FlowStream_STREAM_type;
#define Absyn__STREAM jl_call0(Absyn_FlowStream_STREAM)
/* End External declarations for the uniontypeAbsyn.FlowStream */
/* External declarations for the uniontype: Absyn.ForIterator*/
extern jl_value_t *Absyn_ForIterator;
extern jl_function_t *Absyn_ForIterator_ITERATOR;
extern jl_function_t *Absyn_ForIterator_ITERATOR_type;
static inline jl_value_t *Absyn__ITERATOR(jl_value_t *name, jl_value_t *guardExp, jl_value_t *range) {
return jl_call3(Absyn_ForIterator_ITERATOR, name, guardExp, range);
}
/* End External declarations for the uniontypeAbsyn.ForIterator */
/* External declarations for the uniontype: Absyn.FunctionArgs*/
extern jl_value_t *Absyn_FunctionArgs;
extern jl_function_t *Absyn_FunctionArgs_FOR_ITER_FARG;
extern jl_function_t *Absyn_FunctionArgs_FOR_ITER_FARG_type;
static inline jl_value_t *Absyn__FOR_5fITER_5fFARG(jl_value_t *exp, jl_value_t *iterType, jl_value_t *iterators) {
return jl_call3(Absyn_FunctionArgs_FOR_ITER_FARG, exp, iterType, iterators);
}
extern jl_function_t *Absyn_FunctionArgs_FUNCTIONARGS;
extern jl_function_t *Absyn_FunctionArgs_FUNCTIONARGS_type;
static inline jl_value_t *Absyn__FUNCTIONARGS(jl_value_t *args, jl_value_t *argNames) {
return jl_call2(Absyn_FunctionArgs_FUNCTIONARGS, args, argNames);
}
/* End External declarations for the uniontypeAbsyn.FunctionArgs */
/* External declarations for the uniontype: Absyn.FunctionPurity*/
extern jl_value_t *Absyn_FunctionPurity;
extern jl_function_t *Absyn_FunctionPurity_IMPURE;
extern jl_function_t *Absyn_FunctionPurity_IMPURE_type;
#define Absyn__IMPURE jl_call0(Absyn_FunctionPurity_IMPURE)
extern jl_function_t *Absyn_FunctionPurity_NO_PURITY;
extern jl_function_t *Absyn_FunctionPurity_NO_PURITY_type;
#define Absyn__NO_5fPURITY jl_call0(Absyn_FunctionPurity_NO_PURITY)
extern jl_function_t *Absyn_FunctionPurity_PURE;
extern jl_function_t *Absyn_FunctionPurity_PURE_type;
#define Absyn__PURE jl_call0(Absyn_FunctionPurity_PURE)
/* End External declarations for the uniontypeAbsyn.FunctionPurity */
/* External declarations for the uniontype: Absyn.FunctionRestriction*/
extern jl_value_t *Absyn_FunctionRestriction;
extern jl_function_t *Absyn_FunctionRestriction_FR_KERNEL_FUNCTION;
extern jl_function_t *Absyn_FunctionRestriction_FR_KERNEL_FUNCTION_type;
#define Absyn__FR_5fKERNEL_5fFUNCTION jl_call0(Absyn_FunctionRestriction_FR_KERNEL_FUNCTION)
extern jl_function_t *Absyn_FunctionRestriction_FR_NORMAL_FUNCTION;
extern jl_function_t *Absyn_FunctionRestriction_FR_NORMAL_FUNCTION_type;
static inline jl_value_t *Absyn__FR_5fNORMAL_5fFUNCTION(jl_value_t *purity) {
return jl_call1(Absyn_FunctionRestriction_FR_NORMAL_FUNCTION, purity);
}
extern jl_function_t *Absyn_FunctionRestriction_FR_OPERATOR_FUNCTION;
extern jl_function_t *Absyn_FunctionRestriction_FR_OPERATOR_FUNCTION_type;
#define Absyn__FR_5fOPERATOR_5fFUNCTION jl_call0(Absyn_FunctionRestriction_FR_OPERATOR_FUNCTION)
extern jl_function_t *Absyn_FunctionRestriction_FR_PARALLEL_FUNCTION;
extern jl_function_t *Absyn_FunctionRestriction_FR_PARALLEL_FUNCTION_type;
#define Absyn__FR_5fPARALLEL_5fFUNCTION jl_call0(Absyn_FunctionRestriction_FR_PARALLEL_FUNCTION)
/* End External declarations for the uniontypeAbsyn.FunctionRestriction */
/* External declarations for the uniontype: Absyn.GroupImport*/
extern jl_value_t *Absyn_GroupImport;
extern jl_function_t *Absyn_GroupImport_GROUP_IMPORT_NAME;
extern jl_function_t *Absyn_GroupImport_GROUP_IMPORT_NAME_type;
static inline jl_value_t *Absyn__GROUP_5fIMPORT_5fNAME(jl_value_t *name) {
return jl_call1(Absyn_GroupImport_GROUP_IMPORT_NAME, name);
}
extern jl_function_t *Absyn_GroupImport_GROUP_IMPORT_RENAME;
extern jl_function_t *Absyn_GroupImport_GROUP_IMPORT_RENAME_type;
static inline jl_value_t *Absyn__GROUP_5fIMPORT_5fRENAME(jl_value_t *rename, jl_value_t *name) {
return jl_call2(Absyn_GroupImport_GROUP_IMPORT_RENAME, rename, name);
}
/* End External declarations for the uniontypeAbsyn.GroupImport */
/* External declarations for the uniontype: Absyn.Import*/
extern jl_value_t *Absyn_Import;
extern jl_function_t *Absyn_Import_GROUP_IMPORT;
extern jl_function_t *Absyn_Import_GROUP_IMPORT_type;
static inline jl_value_t *Absyn__GROUP_5fIMPORT(jl_value_t *prefix, jl_value_t *groups) {
return jl_call2(Absyn_Import_GROUP_IMPORT, prefix, groups);
}
extern jl_function_t *Absyn_Import_NAMED_IMPORT;
extern jl_function_t *Absyn_Import_NAMED_IMPORT_type;
static inline jl_value_t *Absyn__NAMED_5fIMPORT(jl_value_t *name, jl_value_t *path) {
return jl_call2(Absyn_Import_NAMED_IMPORT, name, path);
}
extern jl_function_t *Absyn_Import_QUAL_IMPORT;
extern jl_function_t *Absyn_Import_QUAL_IMPORT_type;
static inline jl_value_t *Absyn__QUAL_5fIMPORT(jl_value_t *path) {
return jl_call1(Absyn_Import_QUAL_IMPORT, path);
}
extern jl_function_t *Absyn_Import_UNQUAL_IMPORT;
extern jl_function_t *Absyn_Import_UNQUAL_IMPORT_type;
static inline jl_value_t *Absyn__UNQUAL_5fIMPORT(jl_value_t *path) {
return jl_call1(Absyn_Import_UNQUAL_IMPORT, path);
}
/* End External declarations for the uniontypeAbsyn.Import */
/* External declarations for the uniontype: MetaModelica.SourceInfo*/
extern jl_value_t *MetaModelica_SourceInfo;
extern jl_function_t *MetaModelica_SourceInfo_SOURCEINFO;
extern jl_function_t *MetaModelica_SourceInfo_SOURCEINFO_type;
static inline jl_value_t *Absyn__SOURCEINFO(jl_value_t *fileName, jl_value_t *isReadOnly, jl_value_t *lineNumberStart, jl_value_t *columnNumberStart, jl_value_t *lineNumberEnd, jl_value_t *columnNumberEnd, jl_value_t *lastModification) {
jl_value_t *values[7] = {fileName, isReadOnly, lineNumberStart, columnNumberStart, lineNumberEnd, columnNumberEnd, lastModification};
return jl_call(MetaModelica_SourceInfo_SOURCEINFO, values, 7);
}
/* End External declarations for the uniontypeMetaModelica.SourceInfo */
/* External declarations for the uniontype: Absyn.InnerOuter*/
extern jl_value_t *Absyn_InnerOuter;
extern jl_function_t *Absyn_InnerOuter_INNER;
extern jl_function_t *Absyn_InnerOuter_INNER_type;
#define Absyn__INNER jl_call0(Absyn_InnerOuter_INNER)
extern jl_function_t *Absyn_InnerOuter_INNER_OUTER;
extern jl_function_t *Absyn_InnerOuter_INNER_OUTER_type;
#define Absyn__INNER_5fOUTER jl_call0(Absyn_InnerOuter_INNER_OUTER)
extern jl_function_t *Absyn_InnerOuter_NOT_INNER_OUTER;
extern jl_function_t *Absyn_InnerOuter_NOT_INNER_OUTER_type;
#define Absyn__NOT_5fINNER_5fOUTER jl_call0(Absyn_InnerOuter_NOT_INNER_OUTER)
extern jl_function_t *Absyn_InnerOuter_OUTER;
extern jl_function_t *Absyn_InnerOuter_OUTER_type;
#define Absyn__OUTER jl_call0(Absyn_InnerOuter_OUTER)
/* End External declarations for the uniontypeAbsyn.InnerOuter */
/* External declarations for the uniontype: Absyn.IsField*/
extern jl_value_t *Absyn_IsField;
extern jl_function_t *Absyn_IsField_FIELD;
extern jl_function_t *Absyn_IsField_FIELD_type;
#define Absyn__FIELD jl_call0(Absyn_IsField_FIELD)
extern jl_function_t *Absyn_IsField_NONFIELD;
extern jl_function_t *Absyn_IsField_NONFIELD_type;
#define Absyn__NONFIELD jl_call0(Absyn_IsField_NONFIELD)
/* End External declarations for the uniontypeAbsyn.IsField */
/* External declarations for the uniontype: Absyn.MatchType*/
extern jl_value_t *Absyn_MatchType;
extern jl_function_t *Absyn_MatchType_MATCH;
extern jl_function_t *Absyn_MatchType_MATCH_type;
#define Absyn__MATCH jl_call0(Absyn_MatchType_MATCH)
extern jl_function_t *Absyn_MatchType_MATCHCONTINUE;
extern jl_function_t *Absyn_MatchType_MATCHCONTINUE_type;
#define Absyn__MATCHCONTINUE jl_call0(Absyn_MatchType_MATCHCONTINUE)
/* End External declarations for the uniontypeAbsyn.MatchType */
/* External declarations for the uniontype: Absyn.Modification*/
extern jl_value_t *Absyn_Modification;
extern jl_function_t *Absyn_Modification_CLASSMOD;
extern jl_function_t *Absyn_Modification_CLASSMOD_type;
static inline jl_value_t *Absyn__CLASSMOD(jl_value_t *elementArgLst, jl_value_t *eqMod) {
return jl_call2(Absyn_Modification_CLASSMOD, elementArgLst, eqMod);
}
/* End External declarations for the uniontypeAbsyn.Modification */
/* External declarations for the uniontype: Absyn.Msg*/
extern jl_value_t *Absyn_Msg;
extern jl_function_t *Absyn_Msg_MSG;
extern jl_function_t *Absyn_Msg_MSG_type;
static inline jl_value_t *Absyn__MSG(jl_value_t *info) {
return jl_call1(Absyn_Msg_MSG, info);
}
extern jl_function_t *Absyn_Msg_NO_MSG;
extern jl_function_t *Absyn_Msg_NO_MSG_type;
#define Absyn__NO_5fMSG jl_call0(Absyn_Msg_NO_MSG)
/* End External declarations for the uniontypeAbsyn.Msg */
/* External declarations for the uniontype: Absyn.NamedArg*/
extern jl_value_t *Absyn_NamedArg;
extern jl_function_t *Absyn_NamedArg_NAMEDARG;
extern jl_function_t *Absyn_NamedArg_NAMEDARG_type;
static inline jl_value_t *Absyn__NAMEDARG(jl_value_t *argName, jl_value_t *argValue) {
return jl_call2(Absyn_NamedArg_NAMEDARG, argName, argValue);
}
/* End External declarations for the uniontypeAbsyn.NamedArg */
/* External declarations for the uniontype: Absyn.Operator*/
extern jl_value_t *Absyn_Operator;
extern jl_function_t *Absyn_Operator_ADD;
extern jl_function_t *Absyn_Operator_ADD_type;
#define Absyn__ADD jl_call0(Absyn_Operator_ADD)
extern jl_function_t *Absyn_Operator_ADD_EW;
extern jl_function_t *Absyn_Operator_ADD_EW_type;
#define Absyn__ADD_5fEW jl_call0(Absyn_Operator_ADD_EW)
extern jl_function_t *Absyn_Operator_AND;
extern jl_function_t *Absyn_Operator_AND_type;
#define Absyn__AND jl_call0(Absyn_Operator_AND)
extern jl_function_t *Absyn_Operator_DIV;
extern jl_function_t *Absyn_Operator_DIV_type;
#define Absyn__DIV jl_call0(Absyn_Operator_DIV)
extern jl_function_t *Absyn_Operator_DIV_EW;
extern jl_function_t *Absyn_Operator_DIV_EW_type;
#define Absyn__DIV_5fEW jl_call0(Absyn_Operator_DIV_EW)
extern jl_function_t *Absyn_Operator_EQUAL;
extern jl_function_t *Absyn_Operator_EQUAL_type;
#define Absyn__EQUAL jl_call0(Absyn_Operator_EQUAL)
extern jl_function_t *Absyn_Operator_GREATER;
extern jl_function_t *Absyn_Operator_GREATER_type;
#define Absyn__GREATER jl_call0(Absyn_Operator_GREATER)
extern jl_function_t *Absyn_Operator_GREATEREQ;
extern jl_function_t *Absyn_Operator_GREATEREQ_type;
#define Absyn__GREATEREQ jl_call0(Absyn_Operator_GREATEREQ)
extern jl_function_t *Absyn_Operator_LESS;
extern jl_function_t *Absyn_Operator_LESS_type;
#define Absyn__LESS jl_call0(Absyn_Operator_LESS)
extern jl_function_t *Absyn_Operator_LESSEQ;
extern jl_function_t *Absyn_Operator_LESSEQ_type;
#define Absyn__LESSEQ jl_call0(Absyn_Operator_LESSEQ)
extern jl_function_t *Absyn_Operator_MUL;
extern jl_function_t *Absyn_Operator_MUL_type;
#define Absyn__MUL jl_call0(Absyn_Operator_MUL)
extern jl_function_t *Absyn_Operator_MUL_EW;
extern jl_function_t *Absyn_Operator_MUL_EW_type;
#define Absyn__MUL_5fEW jl_call0(Absyn_Operator_MUL_EW)
extern jl_function_t *Absyn_Operator_NEQUAL;
extern jl_function_t *Absyn_Operator_NEQUAL_type;
#define Absyn__NEQUAL jl_call0(Absyn_Operator_NEQUAL)
extern jl_function_t *Absyn_Operator_NOT;
extern jl_function_t *Absyn_Operator_NOT_type;
#define Absyn__NOT jl_call0(Absyn_Operator_NOT)
extern jl_function_t *Absyn_Operator_OR;
extern jl_function_t *Absyn_Operator_OR_type;
#define Absyn__OR jl_call0(Absyn_Operator_OR)
extern jl_function_t *Absyn_Operator_POW;
extern jl_function_t *Absyn_Operator_POW_type;
#define Absyn__POW jl_call0(Absyn_Operator_POW)
extern jl_function_t *Absyn_Operator_POW_EW;
extern jl_function_t *Absyn_Operator_POW_EW_type;
#define Absyn__POW_5fEW jl_call0(Absyn_Operator_POW_EW)
extern jl_function_t *Absyn_Operator_SUB;
extern jl_function_t *Absyn_Operator_SUB_type;
#define Absyn__SUB jl_call0(Absyn_Operator_SUB)
extern jl_function_t *Absyn_Operator_SUB_EW;
extern jl_function_t *Absyn_Operator_SUB_EW_type;
#define Absyn__SUB_5fEW jl_call0(Absyn_Operator_SUB_EW)
extern jl_function_t *Absyn_Operator_UMINUS;
extern jl_function_t *Absyn_Operator_UMINUS_type;
#define Absyn__UMINUS jl_call0(Absyn_Operator_UMINUS)
extern jl_function_t *Absyn_Operator_UMINUS_EW;
extern jl_function_t *Absyn_Operator_UMINUS_EW_type;
#define Absyn__UMINUS_5fEW jl_call0(Absyn_Operator_UMINUS_EW)
extern jl_function_t *Absyn_Operator_UPLUS;
extern jl_function_t *Absyn_Operator_UPLUS_type;
#define Absyn__UPLUS jl_call0(Absyn_Operator_UPLUS)
extern jl_function_t *Absyn_Operator_UPLUS_EW;
extern jl_function_t *Absyn_Operator_UPLUS_EW_type;
#define Absyn__UPLUS_5fEW jl_call0(Absyn_Operator_UPLUS_EW)
/* End External declarations for the uniontypeAbsyn.Operator */
/* External declarations for the uniontype: Absyn.Parallelism*/
extern jl_value_t *Absyn_Parallelism;
extern jl_function_t *Absyn_Parallelism_NON_PARALLEL;
extern jl_function_t *Absyn_Parallelism_NON_PARALLEL_type;
#define Absyn__NON_5fPARALLEL jl_call0(Absyn_Parallelism_NON_PARALLEL)
extern jl_function_t *Absyn_Parallelism_PARGLOBAL;
extern jl_function_t *Absyn_Parallelism_PARGLOBAL_type;
#define Absyn__PARGLOBAL jl_call0(Absyn_Parallelism_PARGLOBAL)
extern jl_function_t *Absyn_Parallelism_PARLOCAL;
extern jl_function_t *Absyn_Parallelism_PARLOCAL_type;
#define Absyn__PARLOCAL jl_call0(Absyn_Parallelism_PARLOCAL)
/* End External declarations for the uniontypeAbsyn.Parallelism */
/* External declarations for the uniontype: Absyn.Path*/
extern jl_value_t *Absyn_Path;
extern jl_function_t *Absyn_Path_FULLYQUALIFIED;
extern jl_function_t *Absyn_Path_FULLYQUALIFIED_type;
static inline jl_value_t *Absyn__FULLYQUALIFIED(jl_value_t *path) {
return jl_call1(Absyn_Path_FULLYQUALIFIED, path);
}
extern jl_function_t *Absyn_Path_IDENT;
extern jl_function_t *Absyn_Path_IDENT_type;
static inline jl_value_t *Absyn__IDENT(jl_value_t *name) {
return jl_call1(Absyn_Path_IDENT, name);
}
extern jl_function_t *Absyn_Path_QUALIFIED;
extern jl_function_t *Absyn_Path_QUALIFIED_type;
static inline jl_value_t *Absyn__QUALIFIED(jl_value_t *name, jl_value_t *path) {
return jl_call2(Absyn_Path_QUALIFIED, name, path);
}
/* End External declarations for the uniontypeAbsyn.Path */
/* External declarations for the uniontype: Absyn.Program*/
extern jl_value_t *Absyn_Program;
extern jl_function_t *Absyn_Program_PROGRAM;
extern jl_function_t *Absyn_Program_PROGRAM_type;
static inline jl_value_t *Absyn__PROGRAM(jl_value_t *classes, jl_value_t *within_) {
return jl_call2(Absyn_Program_PROGRAM, classes, within_);
}
/* End External declarations for the uniontypeAbsyn.Program */
/* External declarations for the uniontype: Absyn.RedeclareKeywords*/
extern jl_value_t *Absyn_RedeclareKeywords;
extern jl_function_t *Absyn_RedeclareKeywords_REDECLARE;
extern jl_function_t *Absyn_RedeclareKeywords_REDECLARE_type;
#define Absyn__REDECLARE jl_call0(Absyn_RedeclareKeywords_REDECLARE)
extern jl_function_t *Absyn_RedeclareKeywords_REDECLARE_REPLACEABLE;
extern jl_function_t *Absyn_RedeclareKeywords_REDECLARE_REPLACEABLE_type;
#define Absyn__REDECLARE_5fREPLACEABLE jl_call0(Absyn_RedeclareKeywords_REDECLARE_REPLACEABLE)
extern jl_function_t *Absyn_RedeclareKeywords_REPLACEABLE;
extern jl_function_t *Absyn_RedeclareKeywords_REPLACEABLE_type;
#define Absyn__REPLACEABLE jl_call0(Absyn_RedeclareKeywords_REPLACEABLE)
/* End External declarations for the uniontypeAbsyn.RedeclareKeywords */
/* External declarations for the uniontype: Absyn.ReductionIterType*/
extern jl_value_t *Absyn_ReductionIterType;
extern jl_function_t *Absyn_ReductionIterType_COMBINE;
extern jl_function_t *Absyn_ReductionIterType_COMBINE_type;
#define Absyn__COMBINE jl_call0(Absyn_ReductionIterType_COMBINE)
extern jl_function_t *Absyn_ReductionIterType_THREAD;
extern jl_function_t *Absyn_ReductionIterType_THREAD_type;
#define Absyn__THREAD jl_call0(Absyn_ReductionIterType_THREAD)
/* End External declarations for the uniontypeAbsyn.ReductionIterType */
/* External declarations for the uniontype: Absyn.Restriction*/
extern jl_value_t *Absyn_Restriction;
extern jl_function_t *Absyn_Restriction_R_BLOCK;
extern jl_function_t *Absyn_Restriction_R_BLOCK_type;
#define Absyn__R_5fBLOCK jl_call0(Absyn_Restriction_R_BLOCK)
extern jl_function_t *Absyn_Restriction_R_CLASS;
extern jl_function_t *Absyn_Restriction_R_CLASS_type;
#define Absyn__R_5fCLASS jl_call0(Absyn_Restriction_R_CLASS)
extern jl_function_t *Absyn_Restriction_R_CONNECTOR;
extern jl_function_t *Absyn_Restriction_R_CONNECTOR_type;
#define Absyn__R_5fCONNECTOR jl_call0(Absyn_Restriction_R_CONNECTOR)
extern jl_function_t *Absyn_Restriction_R_ENUMERATION;
extern jl_function_t *Absyn_Restriction_R_ENUMERATION_type;
#define Absyn__R_5fENUMERATION jl_call0(Absyn_Restriction_R_ENUMERATION)
extern jl_function_t *Absyn_Restriction_R_EXP_CONNECTOR;
extern jl_function_t *Absyn_Restriction_R_EXP_CONNECTOR_type;
#define Absyn__R_5fEXP_5fCONNECTOR jl_call0(Absyn_Restriction_R_EXP_CONNECTOR)
extern jl_function_t *Absyn_Restriction_R_FUNCTION;
extern jl_function_t *Absyn_Restriction_R_FUNCTION_type;
static inline jl_value_t *Absyn__R_5fFUNCTION(jl_value_t *functionRestriction) {
return jl_call1(Absyn_Restriction_R_FUNCTION, functionRestriction);
}
extern jl_function_t *Absyn_Restriction_R_METARECORD;
extern jl_function_t *Absyn_Restriction_R_METARECORD_type;
static inline jl_value_t *Absyn__R_5fMETARECORD(jl_value_t *name, jl_value_t *index, jl_value_t *singleton, jl_value_t *moved, jl_value_t *typeVars) {
jl_value_t *values[5] = {name, index, singleton, moved, typeVars};
return jl_call(Absyn_Restriction_R_METARECORD, values, 5);
}
extern jl_function_t *Absyn_Restriction_R_MODEL;
extern jl_function_t *Absyn_Restriction_R_MODEL_type;
#define Absyn__R_5fMODEL jl_call0(Absyn_Restriction_R_MODEL)
extern jl_function_t *Absyn_Restriction_R_OPERATOR;
extern jl_function_t *Absyn_Restriction_R_OPERATOR_type;
#define Absyn__R_5fOPERATOR jl_call0(Absyn_Restriction_R_OPERATOR)
extern jl_function_t *Absyn_Restriction_R_OPERATOR_RECORD;
extern jl_function_t *Absyn_Restriction_R_OPERATOR_RECORD_type;
#define Absyn__R_5fOPERATOR_5fRECORD jl_call0(Absyn_Restriction_R_OPERATOR_RECORD)
extern jl_function_t *Absyn_Restriction_R_OPTIMIZATION;
extern jl_function_t *Absyn_Restriction_R_OPTIMIZATION_type;
#define Absyn__R_5fOPTIMIZATION jl_call0(Absyn_Restriction_R_OPTIMIZATION)
extern jl_function_t *Absyn_Restriction_R_PACKAGE;
extern jl_function_t *Absyn_Restriction_R_PACKAGE_type;
#define Absyn__R_5fPACKAGE jl_call0(Absyn_Restriction_R_PACKAGE)
extern jl_function_t *Absyn_Restriction_R_PREDEFINED_BOOLEAN;
extern jl_function_t *Absyn_Restriction_R_PREDEFINED_BOOLEAN_type;
#define Absyn__R_5fPREDEFINED_5fBOOLEAN jl_call0(Absyn_Restriction_R_PREDEFINED_BOOLEAN)
extern jl_function_t *Absyn_Restriction_R_PREDEFINED_CLOCK;
extern jl_function_t *Absyn_Restriction_R_PREDEFINED_CLOCK_type;
#define Absyn__R_5fPREDEFINED_5fCLOCK jl_call0(Absyn_Restriction_R_PREDEFINED_CLOCK)
extern jl_function_t *Absyn_Restriction_R_PREDEFINED_ENUMERATION;
extern jl_function_t *Absyn_Restriction_R_PREDEFINED_ENUMERATION_type;
#define Absyn__R_5fPREDEFINED_5fENUMERATION jl_call0(Absyn_Restriction_R_PREDEFINED_ENUMERATION)
extern jl_function_t *Absyn_Restriction_R_PREDEFINED_INTEGER;
extern jl_function_t *Absyn_Restriction_R_PREDEFINED_INTEGER_type;
#define Absyn__R_5fPREDEFINED_5fINTEGER jl_call0(Absyn_Restriction_R_PREDEFINED_INTEGER)
extern jl_function_t *Absyn_Restriction_R_PREDEFINED_REAL;
extern jl_function_t *Absyn_Restriction_R_PREDEFINED_REAL_type;
#define Absyn__R_5fPREDEFINED_5fREAL jl_call0(Absyn_Restriction_R_PREDEFINED_REAL)
extern jl_function_t *Absyn_Restriction_R_PREDEFINED_STRING;
extern jl_function_t *Absyn_Restriction_R_PREDEFINED_STRING_type;
#define Absyn__R_5fPREDEFINED_5fSTRING jl_call0(Absyn_Restriction_R_PREDEFINED_STRING)
extern jl_function_t *Absyn_Restriction_R_RECORD;
extern jl_function_t *Absyn_Restriction_R_RECORD_type;
#define Absyn__R_5fRECORD jl_call0(Absyn_Restriction_R_RECORD)
extern jl_function_t *Absyn_Restriction_R_TYPE;
extern jl_function_t *Absyn_Restriction_R_TYPE_type;
#define Absyn__R_5fTYPE jl_call0(Absyn_Restriction_R_TYPE)
extern jl_function_t *Absyn_Restriction_R_UNIONTYPE;
extern jl_function_t *Absyn_Restriction_R_UNIONTYPE_type;
#define Absyn__R_5fUNIONTYPE jl_call0(Absyn_Restriction_R_UNIONTYPE)
extern jl_function_t *Absyn_Restriction_R_UNKNOWN;
extern jl_function_t *Absyn_Restriction_R_UNKNOWN_type;
#define Absyn__R_5fUNKNOWN jl_call0(Absyn_Restriction_R_UNKNOWN)
/* End External declarations for the uniontypeAbsyn.Restriction */
/* External declarations for the uniontype: Absyn.Subscript*/
extern jl_value_t *Absyn_Subscript;
extern jl_function_t *Absyn_Subscript_NOSUB;
extern jl_function_t *Absyn_Subscript_NOSUB_type;
#define Absyn__NOSUB jl_call0(Absyn_Subscript_NOSUB)
extern jl_function_t *Absyn_Subscript_SUBSCRIPT;
extern jl_function_t *Absyn_Subscript_SUBSCRIPT_type;
static inline jl_value_t *Absyn__SUBSCRIPT(jl_value_t *subscript) {
return jl_call1(Absyn_Subscript_SUBSCRIPT, subscript);
}
/* End External declarations for the uniontypeAbsyn.Subscript */
/* External declarations for the uniontype: Absyn.TypeSpec*/
extern jl_value_t *Absyn_TypeSpec;
extern jl_function_t *Absyn_TypeSpec_TCOMPLEX;
extern jl_function_t *Absyn_TypeSpec_TCOMPLEX_type;
static inline jl_value_t *Absyn__TCOMPLEX(jl_value_t *path, jl_value_t *typeSpecs, jl_value_t *arrayDim) {
return jl_call3(Absyn_TypeSpec_TCOMPLEX, path, typeSpecs, arrayDim);
}
extern jl_function_t *Absyn_TypeSpec_TPATH;
extern jl_function_t *Absyn_TypeSpec_TPATH_type;
static inline jl_value_t *Absyn__TPATH(jl_value_t *path, jl_value_t *arrayDim) {
return jl_call2(Absyn_TypeSpec_TPATH, path, arrayDim);
}
/* End External declarations for the uniontypeAbsyn.TypeSpec */
/* External declarations for the uniontype: Absyn.Variability*/
extern jl_value_t *Absyn_Variability;
extern jl_function_t *Absyn_Variability_CONST;
extern jl_function_t *Absyn_Variability_CONST_type;
#define Absyn__CONST jl_call0(Absyn_Variability_CONST)
extern jl_function_t *Absyn_Variability_DISCRETE;
extern jl_function_t *Absyn_Variability_DISCRETE_type;
#define Absyn__DISCRETE jl_call0(Absyn_Variability_DISCRETE)
extern jl_function_t *Absyn_Variability_PARAM;
extern jl_function_t *Absyn_Variability_PARAM_type;
#define Absyn__PARAM jl_call0(Absyn_Variability_PARAM)
extern jl_function_t *Absyn_Variability_VAR;
extern jl_function_t *Absyn_Variability_VAR_type;
#define Absyn__VAR jl_call0(Absyn_Variability_VAR)
/* End External declarations for the uniontypeAbsyn.Variability */
/* External declarations for the uniontype: Absyn.Within*/
extern jl_value_t *Absyn_Within;
extern jl_function_t *Absyn_Within_TOP;
extern jl_function_t *Absyn_Within_TOP_type;
#define Absyn__TOP jl_call0(Absyn_Within_TOP)
extern jl_function_t *Absyn_Within_WITHIN;
extern jl_function_t *Absyn_Within_WITHIN_type;
static inline jl_value_t *Absyn__WITHIN(jl_value_t *path) {
return jl_call1(Absyn_Within_WITHIN, path);
}
/* End External declarations for the uniontypeAbsyn.Within */

/* End external declarations */
#ifdef __cplusplus
}
#endif

