#!/usr/bin/env ruby

require 'rubygems'
require 'optparse'

# Gem::Specification.find_all_by_name("jekyll", Gem::Requirement.new("~> 1.5.1")).each { |spec| p spec.dependencies }

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

Gem::Specification.each do |gemspec|
#  puts "#{gemspec.name} version #{gemspec.version}"
  print_gem_deps(gemspec, options[:dev], options[:splitver])
end

puts '}'
