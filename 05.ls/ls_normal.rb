# frozen_string_literal: false

require 'etc'
require 'optparse'

options = ARGV.getopts('l')
contents = Dir.glob('*')

def l_formatter(contents)
  arrange_l_option = contents.map do |file|
    file_inf = File.mtime(file)
    name = File.basename(file)
    stat = File.stat(file)
    user = Etc.getpwuid(stat.uid).name
    group = Etc.getgrgid(stat.gid).name
    file_permission = stat.mode.to_s(8)

    file_type = if file_permission.length >= 6
                  file_permission.scan(/.{1,3}/)
                else
                  file_permission.split(/\A(.{1,2})/, 2)[1..]
                end
    type = type_categorize(file_type)
    permissions = rwx_categorize(file_type)
    rwx_convert(permissions, type)

    "#{type}  #{stat.nlink} #{user}  #{group}  #{stat.size}  #{file_inf.mon} #{file_inf.mday} #{file_inf.strftime('%H:%M')} #{name}"
  end
  contents = arrange_l_option
  output(contents)
end

def type_categorize(file_type)
  {
    10 => 'p',
    20 => 'c',
    40 => 'd',
    60 => 'b',
    100 => '-',
    120 => 'l',
    140 => 's'
  }[file_type[0].to_i]
end

def rwx_categorize(file_type)
  octal_number = file_type[1].chars.map(&:to_i).map { |types| types.to_s(2) }
  octal_number.map { |per| per.chars.map(&:to_i) }
end

def rwx_convert(permissions, type)
  permissions.map do |num|
    (0..2).map do |n|
      type << if num[n] == 1
                if n.zero?
                  'r'
                elsif n == 1
                  'w'
                else
                  'x'
                end
              else
                '-'
              end
    end
  end
end

def output(contents)
  contents.each do |content|
    print content.to_s.ljust(20)
    print "\n"
  end
end

def total(contents)
  block_size = 0
  contents.each do |content|
    block_num = File::Stat.new(content)
    block_size += block_num.blocks
  end
  "total #{block_size}"
end

if options['l']
  puts total(contents)
  l_formatter(contents)
else
  output(contents)
end

