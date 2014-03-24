require 'bowtie/configuration/index_parser'

module Bowtie
  module Configuration
    def configure(model, &block)
      @model = model
      definitions[model] = {}
      instance_eval(&block)
    end

    attr_reader :model

    def definitions
      @definitions ||= {}
    end

    def index(&block)
      index_parser = IndexParser.new(&block)
      if index_parser.rules?
        definitions[model][:index] = index_parser.rules
      end
    end
  end

  extend Configuration
end
