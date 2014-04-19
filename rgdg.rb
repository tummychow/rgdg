#!/usr/bin/env ruby

require 'rubygems'
require 'optparse'

def print_gem_deps(gemspec, dev, split)
  gemspec.dependencies.select { |gemdep| gemdep.type == :runtime || dev }.each do |gemdep|
    print "    \"#{gemspec.name}"
    print "-#{gemspec.version}" if split
    print " -> "
    print "\"#{gemdep.name}\""
    puts
  end
end



options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: rgdg.rb [options]"

  opts.on("-g", "--gem GEMNAME", "Show dependencies for a specific gem") do |gemname|
    options[:gemname] = gemname
  end

  opts.on("-v", "--version GEMVER", "Show dependencies for a specific version of a gem", "(Gem must be specified with -g)") do |gemver|
    options[:gemver] = gemver
  end

  opts.on("-D", "--[no-]development", "Show development dependencies") do |dev|
    options[:dev] = dev
  end

  opts.on("-V", "--[no-]splitver", "Split versions of a gem into separate nodes") do |splitver|
    options[:splitver] = splitver
  end
end.parse!



puts 'digraph G {'

if options[:gemname].nil?
  Gem::Specification
else
  Gem::Specification.find_all_by_name(options[:gemname], Gem::Requirement.new(options[:gemver].nil? ? ">= 0" : "= #{options[:gemver]}"))
end.each { |gemspec| print_gem_deps(gemspec, options[:dev], options[:splitver]) }

puts '}'
