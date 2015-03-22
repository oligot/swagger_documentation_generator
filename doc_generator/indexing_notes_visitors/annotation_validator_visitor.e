note
	description: "Summary description for {ANNOTATION_VALIDATOR_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ANNOTATION_VALIDATOR_VISITOR

inherit

	INDEXING_NOTES_VISITOR

	ANNOTATION_VALIDATOR

feature {NONE}

	class_indexes_handled: BOOLEAN

	current_feature: FEATURE_AS

feature {NONE}
	set_error_msg(l_as: INDEX_AS)
	do
		error_found := true
		error_msg := "Error at%N"
		if attached current_class as c then
			error_msg := error_msg +  "  class '" + c.class_name.name_32 + "'%N"
		end
		if attached current_feature as f then
			error_msg := error_msg + "  feature '" + f.feature_name.name_32 + "'%N"
		end
		error_msg := error_msg + "  Annotation tag: '" + l_as.tag.name_32 + "'%N"
		--error_msg := error_msg + "line number: " + l_as.
	end

feature
	--visitor

	process_class_as (l_as: CLASS_AS)
		do
			error_found := false
			current_class := l_as
			l_as.top_indexes.process (current)
			if attached l_as.top_indexes as indexes then
				indexes.process (current)
			end
			class_indexes_handled := true
			if attached l_as.features as f then
				across
					f as features
				loop
					features.item.process (current)
				end
			end
		end

	process_feature_as (l_as: FEATURE_AS)
		do
			if attached l_as.indexes as indexes then
				indexes.process (current)
			end
		end

	process_feature_clause_as (l_as: FEATURE_CLAUSE_AS)
		do
			if attached l_as.features as f then
				across
					f as features
				loop
					features.item.process (current)
				end
			end
		end

	process_indexing_clause_as (l_as: INDEXING_CLAUSE_AS)
		do
			across
				l_as as indexes
			loop
				indexes.item.process (current)
			end
		end

	process_index_as (l_as: INDEX_AS)
		local
			tag: STRING
		do
			tag := l_as.tag.name_32
				--paths
			if tag.same_string ("sa_schema") then

			elseif tag.same_string ("sa_parameter") then
				validate_parameter_annotation(l_as)
			elseif tag.same_string ("sa_response") then
				validate_response_annotation(l_as)
			elseif tag.same_string ("sa_header") then
				validate_header_annotation(l_as)
			elseif tag.same_string ("sa_operation") then
				validate_operation_annotation (l_as)
			elseif tag.same_string ("sa_operation_tags") then
				validate_list_annotation(l_as)
			elseif tag.same_string ("sa_operation_consumes") then
				validate_list_annotation(l_as)
			elseif tag.same_string ("sa_operation_produces") then
				validate_list_annotation(l_as)
			elseif tag.same_string ("sa_operation_schemes") then
				validate_list_annotation(l_as)
			elseif tag.same_string ("sa_external_doc_def") then
				validate_external_doc_def_annotation(l_as)
			elseif tag.same_string ("sa_security_requirement") then
				validate_security_requirement_annotation(l_as)
			elseif tag.same_string ("sa_path") then
				validate_path_annotation(l_as)
					--info
			elseif l_as.tag.name_32.same_string ("sa_info") then
				validate_info_annotation (l_as)
			elseif l_as.tag.name_32.same_string ("sa_contact") then
				validate_contact_annotation (l_as)
			elseif l_as.tag.name_32.same_string ("sa_license") then
				validate_license_annotation (l_as)
					-- swagger object
			elseif tag.same_string ("sa_consumes") then
				validate_list_annotation(l_as)
			elseif tag.same_string ("sa_produces") then
				validate_list_annotation(l_as)
			elseif tag.same_string ("sa_schemes") then
				validate_list_annotation(l_as)
			elseif tag.same_string ("sa_definition") then
				validate_definition_annotation(l_as)
			elseif tag.same_string ("sa_schema") then
				validate_schema_annotation(l_as)
			elseif tag.same_string ("sa_security_scheme") then
				validate_security_scheme_annotation (l_as)
			elseif tag.same_string ("sa_scope") then
				validate_scope_annotation (l_as)
			elseif tag.same_string ("sa_tag") then
				validate_list_annotation(l_as)
			elseif tag.same_string ("sa_external_doc") then
				validate_external_doc_annotation (l_as)
			end

			if error_found then
				error_found := false
				io.putstring ("Error in annotations found: %N")
				io.putstring (error_msg)
				io.new_line
			end
		end

end