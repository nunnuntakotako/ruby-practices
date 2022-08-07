# frozen_string_literal: false

require 'optparse'

options = ARGV.getopts('l')

input_contents = (ARGF.argv.count.zero? ? [$stdin.read] : ARGF.argv)
contents = []
total_count = 0
total_word = 0
total_size = 0
MAX_WIDTH = 8

input_contents.each do |name|
  contents << if name.include?("\n")
                [nil, name]
              else
                [name, File.read(name)]
              end
end

contents.each do |content|
  print content[1].count("\n").to_s.rjust(MAX_WIDTH)
  unless options['l']
    print content[1].split(/\s+/).size.to_s.rjust(MAX_WIDTH)
    print content[1].bytesize.to_s.rjust(MAX_WIDTH)
  end
  print "#{content[0].to_s.rjust(MAX_WIDTH)}\n" unless content[0] == nil?

  total_count += content[1].count("\n")
  total_word += content[1].split(/\s+/).size
  total_size += content[1].bytesize
end

if input_contents.length > 1
  print total_count.to_s.rjust(MAX_WIDTH)
  unless options['l']
    print total_word.to_s.rjust(MAX_WIDTH)
    print total_size.to_s.rjust(MAX_WIDTH)
  end
  print 'total'.to_s.rjust(MAX_WIDTH)
end
