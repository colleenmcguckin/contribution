#!/usr/bin/env ruby
require 'dry/cli'

module Contribution
  module CLI
    module Commands
      extend Dry::CLI::Registry

      class Version < Dry::CLI::Command
        desc "Print Version"

        def call(*)
          puts "0.0.0"
        end
      end

      class Contribute < Dry::CLI::Command
        desc "Keep track of contributions"

        argument :text, required: true, desc: "Contribution content"

        example [
          "did a thing"
        ]

        def call(text)
          Contribution::add_to_file('bragsheet.txt', text)
          puts "ADDED \"#{text[:text]}\" to contribution list"
        end
      end

      class List < Dry::CLI::Command
        desc "List your contributions"

        def call(*)
          Contribution::read_file('bragsheet.txt')
        end
      end

      register "version", Version, aliases: ["v", "-v", "--version"]
      register "contribute", Contribute, aliases: ["c", "-c", "--contribute"]
      register "list", List, aliases: ["l", "-l", "--list"]
    end
  end

  def self.add_to_file(file, text)
    open(file, 'a') do |file|
      file.puts "#{Time.now.strftime("%m-%e-%y %H:%M")} - #{text[:text]}"
    end
  end

  def self.read_file(file)
    puts "No contributions added yet!" if File.zero?(file)

    open(file).each do |line|
      print "#{line}"
    end
  end
end

Dry::CLI.new(Contribution::CLI::Commands).call