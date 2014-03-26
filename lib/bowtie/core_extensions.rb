# if we have active support, lets use it
# otherwise add the few needed methods to avoid loading it

begin

  require 'active_support/inflector'

rescue LoadError

  class String

    def titleize
      self.capitalize.gsub('_',' ')
    end

    def pluralize
      self.gsub(/y$/,'ie') + "s"
    end

  end

end

module Subclasses
  # return a list of the subclasses of a class
  def subclasses(direct = false)
    classes = []
    if direct
      ObjectSpace.each_object(Class) do |c|
        next unless c.superclass == self
        classes << c
      end
    else
      ObjectSpace.each_object(Class) do |c|
        next unless c.ancestors.include?(self) and (c != self)
        classes << c
      end
    end
    classes
  end
end

Object.send(:include, Subclasses)

class Class

  def linkable
    self.to_s.downcase.pluralize
  end

  def pluralize
    self.to_s.pluralize
  end

end

class Hash

  def prepare_for_query(model, options={})
    self.filter_inaccessible_in(model)
    self.include_missing_booleans_in(model) unless options[:skip_missing_booleans]
    self.parse_hash_fields(model)
    self.parse_array_fields(model)
    self.normalize
  end

  def filter_inaccessible_in(model)
    fields = model.field_names
    self.delete_if { |key,val| !fields.include?(key.to_sym) }
  end

  def include_missing_booleans_in(model)
    model.boolean_fields.each do |bool|
      self[bool] = false unless self.has_key?(bool.to_s)
    end
    self
  end

  def parse_hash_fields(model)
    if model.respond_to?(:hash_fields)
      model.hash_fields.each do |field|
        self[field] = parse_string(self[field]) if self.has_key?(field)
      end
    end
    self
  end

  def parse_array_fields(model)
    if model.respond_to?(:array_fields)
      model.array_fields.each do |field|
        self[field] = parse_string(self[field]) if self.has_key?(field)
      end
    end
    self
  end

  # this is for checkboxes which give us a param of 'on' on the params hash
  def normalize
    replacements = { 'on' => true, '' => nil, 'true' => true, 'false' => false}
    normalized = {}
    self.each_pair do |key,val|
      normalized[key] = replacements.has_key?(val) ? replacements[val] : val
    end
    normalized
  end

  private

  def parse_string(string)
    formatted_string = string.to_s.strip
    unless formatted_string.empty?
      JSON.parse(formatted_string.gsub('=>',':'))
    end
  end

end
