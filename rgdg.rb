#!/usr/bin/env ruby

require 'rubygems'
require 'optparse'
require 'set'



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



nodes = Set.new
edges = Set.new
GemDepEdge = Struct.new(:depender, :dependee)

node_queue =
  if options[:gemname].nil?
    Gem::Specification.to_a
  else
    Gem::Specification.find_all_by_name(options[:gemname], Gem::Requirement.new(options[:gemver].nil? ? ">= 0" : "= #{options[:gemver]}"))
  end

# breadth first search over dependency graph
until node_queue.empty?
  gemspec = node_queue.shift
  unless nodes.include?(gemspec)
    nodes << gemspec
    gemspec.dependencies.select { |gemdep| gemdep.type == :runtime || options[:dev] }.each do |gemdep|
      Gem::Specification.find_all_by_name(gemdep.name, gemdep.requirements_list).each do |depspec|
        edges << GemDepEdge.new(gemspec, depspec)
        node_queue << depspec
      end
    end
  end
end



puts 'digraph G {'

nodes.each do |node|
  print "    \"#{node.name}"
  print "-#{node.version}" if options[:splitver]
  puts '";'
end

edges.each do |edge|
  print "    \"#{edge.depender.name}"
  print "-#{edge.depender.version}" if options[:splitver]
  print '" -> '
  print "\"#{edge.dependee.name}"
  print "-#{edge.dependee.version}" if options[:splitver]
  puts '";'
end

puts '}'
