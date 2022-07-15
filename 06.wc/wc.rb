# frozen_string_literal: false

require 'optparse'

options = ARGV.getopts('l')
file_information = []
input_contents = (!ARGF.argv.count.zero? ? ARGF.argv : readlines)
total = [0, 0, 0, 'total']

input_contents.each do |content|
  str = content.include?("\n") ? content : File.read(content)
  ary = str.split(/\s+/)
  file_information << [
    str.lines.count,
    ary.size,
    content ? str.bytesize : FileTest.size(content),
    File.basename(content)
  ]
end

if input_contents == ARGF.argv
  file_information.each do |file|
    row = options['l'] ? "      #{file[0]}   #{file[3]}\n" : "      #{file[0]}"
    print row
    print "      #{file[1]}       #{file[2]}   #{file[3]} \n" unless options['l']
  end
end

file_information.each do |file|
  total[0] += file[0]
  total[1] += file[1]
  total[2] += file[2]
end

if file_information.size > 1
  if input_contents == readlines
    row_total = (options['l'] ? "      #{total[0]}   #{total[3]}\n" : "      #{total[0]}")
    print row_total
    print "      #{total[1]}     #{total[2]}     #{total[3]}" unless options['l']
  end
  print "      #{total[0]}"
  print "      #{total[1]}     #{total[2]}" unless options['l']
  print "      #{total[3]}" if input_contents == ARGF.argv
end
