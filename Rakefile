# coding: utf-8

Dir.glob('rake/**.rake').each do |f|
  import f
end

task default: %w[release:build]

task :init do
  sh "git clone https://github.com/UrlAutoRedirector/UrlAutoRedirector.git"
  sh "git clone https://github.com/UrlAutoRedirector/UrlAutoRedirector.github.io.git"
end

def version
  require "json"
  manifest = JSON.parse(open("../UrlAutoRedirector/src/manifest.json").read)
  manifest["version"]
end
