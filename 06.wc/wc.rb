# frozen_string_literal: false

require 'optparse'

options = ARGV.getopts('l')

input_contents = (!ARGF.argv.count.zero? ? ARGF.argv : [$stdin.read])
total_count = 0
total_word = 0
total_size = 0

MAX_WIDTH = 8

input_contents.each do |input_content|
  content = (input_content.include?("\n") ? input_content : File.read(input_content))
  print content.count("\n").to_s.rjust(MAX_WIDTH)
  unless options['l']
    print content.split(/\s+/).size.to_s.rjust(MAX_WIDTH)
    print content.bytesize.to_s.rjust(MAX_WIDTH)
  end
  print "#{input_content.to_s.rjust(MAX_WIDTH)}\n" unless input_content.include?("\n")

  total_count += content.count("\n")
  total_word += content.split(/\s+/).size
  total_size += content.bytesize
end

if input_contents.length > 1
  print total_count.to_s.rjust(MAX_WIDTH)
  unless options['l']
    print total_word.to_s.rjust(MAX_WIDTH)
    print total_size.to_s.rjust(MAX_WIDTH)
  end
  print '    total'
end
