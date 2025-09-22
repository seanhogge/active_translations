require_relative "lib/active_translations/version"

Gem::Specification.new do |spec|
  spec.name        = "active_translations"
  spec.version     = ActiveTranslations::VERSION
  spec.authors     = [ "Sean Hogge" ]
  spec.email       = [ "sean@seanhogge.com" ]
  spec.homepage    = "TODO"
  spec.summary     = "TODO: Summary of ActiveTranslations."
  spec.description = "TODO: Description of ActiveTranslations."
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

  spec.add_dependency "rails", ">= 7"
  # spec.add_dependency "faraday"
  # spec.add_dependency "googleauth"
  # spec.add_dependency "google-api-client"
  # spec.add_dependency "google-apis-core"
end
