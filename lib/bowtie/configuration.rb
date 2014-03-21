require 'bowtie/configuration/index_parser'

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
      index_parser = IndexParser.new(&block)
      if index_parser.rules?
        definitions[@klass][:index] = index_parser.rules
      end
    end

  end

  extend Configuration
end
