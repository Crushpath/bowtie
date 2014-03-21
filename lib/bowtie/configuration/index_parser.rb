module Bowtie
  module Configuration
    class IndexParser
      def initialize(&block)
        @columns = {}
        instance_eval(&block)
      end

      attr_accessor :columns

      def column(method)
        columns[method] = true
      end

      def rules
        columns
      end

      def rules?
        !columns.empty?
      end
    end
  end
end
