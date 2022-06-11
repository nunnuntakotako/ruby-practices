# frozen_string_literal: false

require 'optparse'

options = ARGV.getopts('l')

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

def lcommand_count(file_information, options)
  file_list = []

  ARGF.each do |list|
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

  if options['l']
    puts "      #{file_information[0]}"
  else
    puts "      #{file_information[0]}     #{file_information[1]}    #{file_information[2]}"
  end
end

if !ARGF.argv.count.zero?
  file_name = ARGF.argv
  file_information = []
  file_name.each do |files|
    str = File.read(files)
    def count_words(str)
      ary = str.split(/\s+/)
      ary.size
    end
    file_information << [str.lines.count, count_words(str), FileTest.size(files), File.basename(files)]
  end
  options['l'] ? line_only(file_information) : all_count(file_information)
else
  file_information = []
  lcommand_count(file_information, options)
end

