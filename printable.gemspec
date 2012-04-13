Gem::Specification.new do |s|
  s.name        = 'printable'
  s.version     = '0.0.1'
  s.date        = '2012-04-13'
  s.summary     = "Printable Technologies"
  s.description = "An API gem for Printable Technologies web-to-print systems"
  s.authors     = ["Global Thinking"]
  s.email       = 'ideas@globalthinking.com'
  s.files       = Dir["lib/**/*.rb", "test/**/*.rb"]
  s.homepage    =
    'http://rubygems.org/gems/printable'
  s.add_runtime_dependency 'htmlentities', '>= 4.0.0'
end