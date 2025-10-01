# frozen_string_literal: true
# create gem
# gem build rails_payment_sandbox.gemspec
# gem push ./rails_payment_sandbox-0.1.1.gem

# gem yank rails_payment_sandbox -v 0.1.1 for delete

require_relative "lib/rails_payment_sandbox/version"

Gem::Specification.new do |spec|
  spec.name = "payment_sandbox_rails"
  spec.version = RailsPaymentSandbox::VERSION
  spec.authors = ["mrmalvi"]
  spec.email = ["malviyak00@gmail.com"]

  spec.summary       = "Simulate multiple payment gateways locally with fake data for testing"
  spec.description   = "Rails Payment Sandbox helps developers test payment flows locally without hitting real gateways. It simulates Stripe, Razorpay, PayPal, and provides fake transactions with random statuses."
  spec.homepage      = "https://github.com/mrmalvi/rails_payment_sandbox"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.0.0"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mrmalvi/rails_payment_sandbox"
  spec.metadata["changelog_uri"]   = "https://github.com/mrmalvi/rails_payment_sandbox/blob/main/CHANGELOG.md"

  spec.add_development_dependency "rspec", "~> 3.12"


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files         = Dir["lib/**/*.rb"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
