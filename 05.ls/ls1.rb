# frozen_string_literal: true

require 'etc'
require 'optparse'

COLUMN = 3

options = ARGV.getopts('l')

def l_options
  contents = Dir.glob('*')
  arrangement_l = contents.map do |file|
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

    type = ''
    type_categorize(file_type)
    rwx_categorize(file_type, type)

                  "#{type}  #{stat.nlink} #{user}  #{group}  #{stat.size}  #{file_inf.mon} #{file_inf.mday} #{file_inf.strftime('%H:%M')} #{name}"
  end

  arrangement_l(arrangement_l)
end

def type_categorize(file_type)
  case file_type[0].to_i
  when 10
    type.to_s = 'p'
  when 20
    type.to_s = 'c'
  when 40
    type.to_s = 'd'
  when 60
    type.to_s = 'b'
  when 100
    type.to_s = '-'
  when 120
    type.to_s = 'l'
  when 140
    type.to_s = 's'
  end
end

def rwx_categorize(file_type, type)
  permission = []
  file_type[1].chars.map(&:to_i).each do |types|
    permission << types.to_s(2)
  end

  permissions = []
  permission.each do |per|
    permissions << per.chars.map(&:to_i)
  end

  permissions.each do |num|
    (0..num.size - 1).each do |n|
      type += if n.zero? && num[n] == 1
                'r'
              elsif n == 1 && num[n] == 1
                'w'
              elsif n == 2 && num[n] == 1
                'x'
              else
                '-'
              end
    end
  end
end

def arrangement_l(arrangement_l)
  quantity = arrangement_l.length.to_f
  row = (quantity / COLUMN).ceil
  view = arrangement_l.each_slice(row).to_a

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

def non_options
  contents = Dir.glob('*')
  quantity = contents.length.to_f
  row = (quantity / COLUMN).ceil
  view = contents.each_slice(row).to_a

  view[-1] << nil while view[-1].size < row

  output(view)
end

if options['l']
  l_options
else
  non_options
end
