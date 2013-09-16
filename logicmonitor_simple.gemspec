Gem::Specification.new do |s|
  s.name        = 'logicmonitor_simple'
  s.version     = '0.1.2'
  s.date        = '2013-09-16'
  s.summary     = "Simple API client for LogicMonitor"
  s.description = "Simple API client for LogicMonitor"
  s.authors     = ["Michael Mittelstadt"]
  s.email       = 'meek@getsatisfaction.com'
  s.files       = ["LICENSE", "lib/logicmonitor_simple.rb"]
  s.homepage    = 'https://github.com/meekmichael/logicmonitor_simple'
  s.license     = 'MIT'
  [ "curb", "multi_json", "awrence" ].each do |dep|
     s.add_dependency dep
  end
end
