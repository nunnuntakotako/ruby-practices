# frozen_string_literal: false

require 'optparse'

options = ARGV.getopts('l')
file_information = []
input_contents = (!ARGF.argv.count.zero? ? ARGF.argv : readlines)

def line_only(file_information)
  total_lines = 0
  file_information.each do |info|
    puts "     #{info[0]} #{info[3]}"
    total_lines += info[0].to_i
  end
  puts "     #{total_lines} total" if file_information.length > 1
end

def all_count(file_information)
  total_lines = 0
  total_words = 0
  total_size = 0
  file_information.each do |info|
    puts "     #{info[0]}     #{info[1]}    #{info[2]} #{info[3]}"
    total_lines += info[0].to_i
    total_words += info[1].to_i
    total_size += info[2].to_i
  end
  puts "     #{total_lines}     #{total_words}    #{total_size} total" if file_information.length > 1
end

def lcommand_count(file_information, options, input_contents)
  file_list = []

  input_contents.each do |list|
    file_list << list
  end

  total_words = 0
  total_size = 0
  file_list.each do |files|
    total_size += files.bytesize
    ary = files.split(/\s+/)
    total_words += ary.size.to_i
  end

  file_information[0] = file_list.size
  file_information[1] = total_words
  file_information[2] = total_size

  print "      #{file_information[0]}"
  print "     #{file_information[1]}    #{file_information[2]}" unless options['l']
end

if !ARGF.argv.count.zero?
  input_contents.each do |content|
    str = File.read(content)
    def count_words(str)
      ary = str.split(/\s+/)
      ary.size
    end
    file_information << [str.lines.count, count_words(str), FileTest.size(content), File.basename(content)]
  end
  options['l'] ? line_only(file_information) : all_count(file_information)
else
  lcommand_count(file_information, options, input_contents)
end
