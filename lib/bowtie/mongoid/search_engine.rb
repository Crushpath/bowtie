module Bowtie
  module Mongoid
    class SearchEngine
      FIELDS_SEPARATOR = ';'
      KEY_VALUE_SEPARATOR = ':'

      def initialize(model, query_string, page)
        @model = model
        @query_string = query_string
        @page = page
        @query_parts = get_query_parts
      end

      def get_query_parts
        if @query_string.present?
          @query_string.split(FIELDS_SEPARATOR).map { |s| s.split(KEY_VALUE_SEPARATOR) }.flatten
        else
          []
        end
      end

      def search_on_all_fields?
        @query_parts.size == 1
      end

      def search_on_specific_fields?
        @query_parts.size > 1
      end

      def search_on_all_fields
        conditions = searchable_text_fields.inject({}) { |hash, field| hash[field] = /#{@query_string}/i;hash }
        conditions.inject([]) do |results, (field, value)|
          results.concat(Bowtie.add_paging(@model.where(field => value), @page).all)
        end.uniq
      end

      def search_on_specific_fields
        conditions = Hash[*@query_parts]
        conditions.each { |field, value| conditions[field] = get_adequate_matcher(field, value) }
        Bowtie.add_paging(@model.where(conditions), @page).all
      end

      def searchable_text_fields
        @model.searchable_fields.select do |field|
          @model.fields[field.to_s].type == String
        end
      end

      def get_adequate_matcher(field, value)
        field = @model.fields[field.to_s]

        if field
          case field.type
          when String then /#{value}/i
          else value
          end
        end
      end

      def get_results
        if search_on_all_fields?
          search_on_all_fields
        elsif search_on_specific_fields?
          search_on_specific_fields
        else
          []
        end
      end
    end
  end
end
