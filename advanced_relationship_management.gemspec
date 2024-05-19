# frozen_string_literal: true

require_relative "lib/advanced_relationship_management/version"

Gem::Specification.new do |spec|
  spec.name = "advanced_relationship_management"
  spec.version = AdvancedRelationshipManagement::VERSION
  spec.authors = ["Jana"]
  spec.email = ["shanmugamjanarthan24@gmail.com"]

  spec.summary       = %q{Advanced Relationship Management for ActiveRecord Models}
  spec.description   = %q{A gem to manage complex relationships, including recursive and graph-based relationships, for ActiveRecord models in Rails.}

  spec.homepage = "https://github.com/janarthanan-shanmugam/advanced_relationship_management"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/janarthanan-shanmugam/advanced_relationship_management"
  spec.metadata["changelog_uri"] = "https://github.com/janarthanan-shanmugam/advanced_relationship_management"

  spec.files         = Dir["lib/**/*"]
  spec.require_paths = ["lib"]


  # spec.files = Dir["./lib/**/*.rb"]
  # spec.bindir = "exe"
  # spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  # spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 6.0"
  spec.add_dependency "rgl", ">= 0.5.5"
end