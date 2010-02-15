
Gem::Specification.new do |s|
  s.name = %q{bowtie}
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tomás Pollak"]
  s.date = %q{2010-02-14}
  s.description = %q{Sinatra scaffold for DataMapper models.}
  s.email = %q{tomas@usefork.com}
  s.extra_rdoc_files = ["lib/bowtie.rb", "lib/core_extensions.rb", "lib/helpers.rb"]
  s.files = ["README", "bowtie.gemspec", "lib/bowtie.rb", "lib/core_extensions.rb", "lib/helpers.rb", "views/errors.erb", "views/field.erb", "views/flash.erb", "views/form.erb", "views/index.erb", "views/layout.erb", "views/new.erb", "views/search.erb", "views/search.erb", "views/show.erb", "views/subtypes.erb", "views/table.erb", "views/row.erb", "public/css/bowtie.css", "public/js/bowtie.js", "public/js/jquery.tablesorter.pack.js", "public/js/jquery.jeditable.pack.js"]
  s.homepage = %q{http://github.com/tomas/bowtie}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Bowtie", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{bowtie}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Bowtie Admin}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 0.9.4"])
      s.add_runtime_dependency(%q<dm-core>, [">= 0.10.2"])
      s.add_runtime_dependency(%q<dm-aggregates>, [">= 0.10.2"])
      s.add_runtime_dependency(%q<dm-pager>, [">= 1.0.1"])
    else
      s.add_dependency(%q<sinatra>, [">= 0.9.4"])
      s.add_dependency(%q<dm-core>, [">= 0.10.2"])
      s.add_dependency(%q<dm-aggregates>, [">= 0.10.2"])
      s.add_dependency(%q<dm-pager>, [">= 1.0.1"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0.9.4"])
    s.add_dependency(%q<dm-core>, [">= 0.10.2"])
    s.add_dependency(%q<dm-aggregates>, [">= 0.10.2"])
    s.add_dependency(%q<dm-pager>, [">= 1.0.1"])
  end
end
