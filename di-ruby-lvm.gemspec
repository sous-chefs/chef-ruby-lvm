$:.unshift(File.expand_path('../lib/', __FILE__))
require 'lvm/version'

deps = {
  'open4' => ['~> 0.9', '>= 0.9.6'],
  'di-ruby-lvm-attrib' => ['~> 0.0.3']
}

Gem::Specification.new do |gem|
  gem.authors       = ["Greg Symons", "Matthew Kent"]
  gem.email         = ["mkent@magoazul.com", 'gsymons@gsconsulting.biz']
  gem.description   = 'A wrapper for the LVM2 administration utility, lvm.'
  gem.license       = "MIT"
  gem.summary       = 'A wrapper for the LVM2 administration utility, lvm.'
  gem.homepage      = "https://github.com/gregsymons/di-ruby-lvm"
  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "di-ruby-lvm"
  gem.require_paths = ["lib"]
  gem.version       = LVM::VERSION

  deps.each do |dep, constraints|
    gem.add_runtime_dependency dep, *constraints
  end
end
