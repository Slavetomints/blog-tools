Gem::Specification.new do |s|
  s.name        = "blog-tools"
  s.version     = "0.1.0"
  s.summary     = "CLI tools for managing blog posts"
  s.authors     = ["Slavetomints"]
  s.email       = ["slavetomints@protonmail.com"]
  s.files       = Dir["lib/**/*.rb"] + ["bin/blog-tools"]
  s.executables << "blog-tools"
  s.require_paths = ["lib"]

  s.add_dependency "thor"
end
