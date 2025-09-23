require_relative "lib/active_translation/version"

Gem::Specification.new do |spec|
  spec.name        = "active_translation"
  spec.version     = ActiveTranslation::VERSION
  spec.authors     = [ "Sean Hogge" ]
  spec.email       = [ "sean@seanhogge.com" ]
  spec.homepage    = "TODO"
  spec.summary     = "TODO: Summary of ActiveTranslation."
  spec.description = "TODO: Description of ActiveTranslation."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.2.2"
  spec.add_dependency "activerecord", ">= 7.2.2"
end
