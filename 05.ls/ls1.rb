# frozen_string_literal: false

require 'etc'
require 'optparse'

COLUMN = 3

options = ARGV.getopts('l')

def l_formatter
  contents = Dir.glob('*')
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
  arrangement_l(arrange_l_option)
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
                elsif n == 2
                  'x'
                end
              else
                '-'
              end
    end
  end
end

def arrangement_l(arrange_l_option)
  quantity = arrange_l_option.length.to_f
  row = (quantity / COLUMN).ceil
  view = arrange_l_option.each_slice(row).to_a

  view[-1] << nil while view[-1].size < row

  output(view)
end

def output(view)
  arrange = view.transpose
  arrange.each do |rows|
    rows.each do |content|
      print content.to_s.ljust(20)
    end
    print "\n"
  end
end

def non_formatter
  contents = Dir.glob('*')
  quantity = contents.length.to_f
  row = (quantity / COLUMN).ceil
  view = contents.each_slice(row).to_a

  view[-1] << nil while view[-1].size < row

  output(view)
end

if options['l']
  l_formatter
else
  non_formatter
end
