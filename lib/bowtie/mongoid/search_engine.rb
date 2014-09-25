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
        conditions = @model.searchable_fields.inject({}) { |hash, field| hash[field] = /#{@query_string}/i;hash }
        Bowtie.add_paging(@model.where(conditions), @page).all
      end

      def search_on_specific_fields
        conditions = Hash[*@query_parts]
        conditions.each { |field, value| conditions[field] = /#{value}/i }
        Bowtie.add_paging(@model.where(conditions), @page).all
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
