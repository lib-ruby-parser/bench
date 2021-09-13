# This scripts downloads top 100 gems (by downloads)
# from rubygems.org

require 'open-uri'
require 'rexml/document'
require 'json'
require 'fileutils'

ROOT = __dir__
GEMS_ROOT  = File.join(ROOT, 'gems')
REPOS_ROOT = File.join(ROOT, 'repos')
FileUtils.mkdir_p(GEMS_ROOT)
FileUtils.mkdir_p(REPOS_ROOT)

def download_raw(url)
    URI.open(url).read
end

def download_json(url)
    JSON.parse(download_raw(url))
end

Page = Struct.new(:url, keyword_init: true) do
    extend Enumerable

    def self.each
        return to_enum(__method__) unless block_given?

        1.upto(10) do |page|
            url = "https://rubygems.org/stats?page=#{page}"
            yield Page.new(url: url)
        end
    end

    def gems
        gem_names = download_raw(url)
            .lines
            .grep(/stats__graph__gem__name/)
            .map { |line| REXML::Document.new(line) }
            .map { |doc| doc.elements.to_a[0].elements.to_a[0].text }

        if gem_names.length != 10
            raise "Script is incompatible with currrent rubygems.org markup"
        end

        gem_names.map { |gem_name| GemInfo.new(gem_name: gem_name) }
    end
end

GemInfo = Struct.new(:gem_name, keyword_init: true) do
    extend Enumerable

    def gem_uri
        download_json("https://rubygems.org/api/v1/gems/#{gem_name}.json")['gem_uri']
    end

    def download
        if File.exists?("#{GEMS_ROOT}/#{gem_name}.gem")
            puts "Skipping wget #{GEMS_ROOT}/#{gem_name}.gem"
        else
            `wget #{gem_uri} -O #{GEMS_ROOT}/#{gem_name}.gem`
        end
    end

    def unpack
        if File.directory?("#{REPOS_ROOT}/#{gem_name}")
            puts "Skipping gem unpack #{GEMS_ROOT}/#{gem_name}.gem"
        else
            `gem unpack #{GEMS_ROOT}/#{gem_name}.gem --target #{REPOS_ROOT}`
        end
    end
end

Page.map do |page|
    Thread.new do
        page.gems.each do |gem|
            gem.download
            gem.unpack
        end
    end
end.each(&:join)
