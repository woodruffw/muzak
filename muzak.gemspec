require_relative "lib/muzak"

Gem::Specification.new do |s|
  s.name = "muzak"
  s.version = Muzak::VERSION
  s.summary = "muzak - A metamusic player."
  s.description = "A library for controlling playlists and media players."
  s.authors = ["William Woodruff"]
  s.email = "william@tuffbizz.com"
  s.files = Dir["LICENSE", "README.md", ".yardopts", "lib/**/*"]
  s.executables = ["muzak", "muzakd", "muzak-cmd", "muzak-dmenu"]
  s.required_ruby_version = ">= 2.3.0"
  s.homepage = "https://github.com/woodruffw/muzak"
  s.license = "MIT"
  s.add_runtime_dependency "taglib-ruby", "~> 0.7"
end
