# coding: utf-8

require "json"

def version
  manifest = JSON.parse(open("../UrlAutoRedirector/src/manifest.json").read)
  manifest["version"]
end

namespace :release do
  desc "Build package"
  task :build, [:force] do |t, args|
    args.with_defaults(:force => nil)
    # generate filename
    filename = "UrlAutoRedirector-#{version}.zip"
    # ch to UrlAutoRedirector
    Dir.chdir("../UrlAutoRedirector") do
      # make dir
      sh "mkdir -p dist"
      # check version
      Dir.chdir("dist") do
        if args[:force] != "--force"  && File.exist?(filename)
          puts "WARNING: #{filename} is existed. Please check and confirm the version number."
          exit 1
        end
      end
      # cleanup .DS_Store
      sh "find ./src -name .DS_Store | xargs rm"
      # zip
      sh "cd src && zip -r release.zip ."
      sh "mv src/release.zip dist/#{filename}"
    end
  end

  desc "Create and push a tag"
  task :tag do
    sh "git tag #{version}"
    sh "git push origin #{version}"
  end

  desc "Update changelog"
  task :changelog do
  end
end