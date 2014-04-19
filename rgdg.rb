#!/usr/bin/env ruby

require 'rubygems'

# Gem::Specification.find_all_by_name("jekyll", Gem::Requirement.new("~> 1.5.1")).each { |spec| p spec.dependencies }

puts "digraph G {"

Gem::Specification.each do |gemspec|
#  puts "#{gemspec.name} version #{gemspec.version}"
  gemspec.dependencies.each do |gemdep|
    if gemdep.type == :runtime
      puts "    \"#{gemspec.name}\" -> \"#{gemdep.name}\""
    end
  end
end

puts "}"
