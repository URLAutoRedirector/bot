# coding: utf-8

Dir.glob('rake/**.rake').each do |f|
  import f
end

task default: %w[release:build]

require "json"

def version
  manifest = JSON.parse(open("../UrlAutoRedirector/src/manifest.json").read)
  manifest["version"]
end
