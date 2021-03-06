# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'i2c_drivers/version'

Gem::Specification.new do |spec|
  spec.name          = "i2c_drivers"
  spec.version       = I2cDrivers::VERSION
  spec.authors       = ["Kikuchi Ken"]
  spec.email         = ["ken@nuasa.org"]

  spec.summary       = %q{i2c drivers for some sensors.}
  spec.description   = %q{i2c drivers for some sensors.}
  spec.homepage      = "https://github.com/kenkiku1021/ruby_i2c_drivers"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "i2c", "~> 0.4.0"
end
