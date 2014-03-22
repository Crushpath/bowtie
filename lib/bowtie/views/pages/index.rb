module Bowtie
  module Views
    module Pages

      class Index
        def initialize(model)
          @model = model
        end

        attr_reader :model

        def field_names
          if Bowtie.definitions[model] && Bowtie.definitions[model][:index]
            Bowtie.definitions[model][:index].keys
          else
            model.field_names
          end
        end
      end

    end
  end
end
