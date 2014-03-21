module Bowtie
  module Configuration

    def configure(klass, &block)
      @klass = klass
      definitions[@klass] = {}
      instance_eval(&block)
    end

    def definitions
      @definitions ||= {}
    end

    def index(&block)
      initialize_section(:index)
      definitions[@klass][:index] = IndexParser.new(&block).result
      clear_definitions(:index) if definitions[@klass][:index].empty?
    end

    def initialize_section(section)
      definitions[@klass] = {}
    end

    def clear_definitions(section)
      definitions[@klass].delete(section)
    end

    class IndexParser
      def initialize(&block)
        @columns = {}
        instance_eval(&block)
      end

      attr_accessor :columns

      def result
        columns
      end

      def column(method)
        columns[method] = true
      end
    end

  end

  extend Configuration
end
