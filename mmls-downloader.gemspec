Gem::Specification.new do |s|
  s.name        = 'mmls-downloader'
  s.version     = '1.0.7'
  s.date        = '2016-12-20'
  s.summary     = "MMLS Downloader"
  s.description = "A simple gem to download notes"
  s.authors     = ["Hii Yong Lian"]
  s.email       = 'yonglian146@gmail.com'
  s.files       = ["lib/mmls-downloader.rb"]
  s.executables = ["mmls"]
  s.add_runtime_dependency "mechanize", '2.7.3'
  s.add_runtime_dependency "highline", '1.7.8'
  s.add_runtime_dependency "daybreak", '0.3.0'
  s.add_runtime_dependency "colorize", '0.7.7'
  s.homepage    =
    'http://rubygems.org/gems/mmls'
  s.license       = 'MIT'
end