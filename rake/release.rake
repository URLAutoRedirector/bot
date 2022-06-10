# coding: utf-8
# handle build and release process

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
    Dir.chdir("../UrlAutoRedirector") do
      sh "git tag #{version}"
      sh "git push origin #{version}"
    end
  end

  desc "Update changelog"
  task :changelog, [:number] do |t, args|
    args.with_defaults(:number => 1)
    # get changes
    changes = []
    Dir.chdir("../UrlAutoRedirector") do
      sh "git log -n #{args[:number]} --pretty=format:'%h: %s' > dist/temp.log"
      changes = File.read("dist/temp.log").split("\n")
    end
    # update changelog to website
    Dir.chdir("../UrlAutoRedirector.github.io") do
      require "yaml"
      changelogs = YAML.load_file("_data/changelog.yml")

      new_change = {
        "version" => version,
        "changes" => []
      }

      changes.each do |change|
        detail = change.split(":")
        new_change["changes"] << {
          "text" => detail[1..-1].join(':').strip!,
          "hash" => detail[0]
        }
      end

      changelogs.insert(0, new_change)
      File.write("_data/changelog.yml", changelogs.to_yaml)
    end
  end
end
