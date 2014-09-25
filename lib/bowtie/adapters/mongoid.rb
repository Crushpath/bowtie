module Bowtie

  def self.models
    models = Object.constants
                   .collect { |sym| Object.const_get(sym) }
                   .select { |constant| constant.class == Class && constant.include?(::Mongoid::Document) && !constant.embedded? }
  end

  def self.search(model, q, page)
    search_engine = Mongoid::SearchEngine.new(model, q, page)
    search_engine.get_results
  end

  def self.get_many(model, params, page)
    add_paging(model.where(params), page)
  end

  def self.get_one(model, id)
    model.find(id)
  end

  def self.create(model, params)
    model.create(params)
  end

  def self.get_associated(model, params)
    model.find(params[:id]).send(params[:association])
  end

  def self.add_paging(resources, page)
    resources.skip((page.to_i || 0)*PER_PAGE).limit(PER_PAGE).order_by(id: 1)
  end

  # doesnt trigger validations or callbacks
  def self.update!(resource, params)
    resource.update_attributes!(params)
  end

  def self.update(resource, params)
    resource.update_attributes(params)
  end

  def self.belongs_to_association?(assoc)
    assoc.relation.in? [ ::Mongoid::Relations::Referenced::In, ::Mongoid::Relations::Embedded::In ]
  end

  def self.has_one_association?(assoc)
    assoc.relation.in? [ ::Mongoid::Relations::Referenced::One, ::Mongoid::Relations::Embedded::One ]
  end

  def self.get_count(record, association)
    record.send(association).count
  end

  module Helpers

    def total_entries(resources)
      resources.count
    end

    def get_page(counter)
      str = request.path["/search"] ? "&model=#{params[:model]}&q=#{params[:q]}" : ""
      i = (params[:page].to_i || 0) + counter
      i == 0 ? str : "?page=#{i}#{str}"
    end

    def show_pager(resources, path)
      path = base_path + path.gsub(/[?|&]page=\d+/,'') # remove page from path
      nextlink = "<li><a class='next' href='#{path}#{get_page(1)}'>Next &rarr;</a></li>"
      prevlink = "<li><a class='prev' href='#{path}#{get_page(-1)}'>&larr; Prev</a></li>"
      s = params[:page] ? prevlink + nextlink : nextlink
      "<ul class='pager'>" + s + "</ul>"
    end

  end

  module ClassMethods

    def primary_key
      'id'
    end

    def model_associations
      self.associations
    end

    def field_names
      self.fields.keys.collect { |f| f.to_sym }
    end

    def boolean_fields
      fields_for_type(Boolean)
    end

    def hash_fields
      fields_for_type(Hash)
    end

    def array_fields
      fields_for_type(Array)
    end

    def searchable_fields
      [fields_for_type(String),
       fields_for_type(Integer),
       fields_for_type(Boolean)
      ].flatten.uniq - ["_type"]
    end

    def subtypes
      #TODO: Have to check inclusion options.
      #s = []
      #self.fields.each {|k,v| s << k if v.options[:type] == Array}
      #s.compact
      []
    end

    def options_for_subtype(field)
      self.fields[field].type
    end

    def relation_keys_include?(key)
      self.associations.map {|rel| true if key.to_sym == rel[1].name}.reduce
    end

    def fields_for_type(type)
      s = []
      self.fields.each {|k,v| s << k if v.options[:type] == type}
      s.compact
    end

  end

end

module Mongoid::Document

  def primary_key
    send(self.class.primary_key)
  end

end
