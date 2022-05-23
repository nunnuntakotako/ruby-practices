require 'etc'
require 'optparse'

COLUMN = 3

options = ARGV.getopts('l')

def l_options
  arrangement_l = []
  contents = Dir.glob('*')
  contents.each do |file|
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
    case file_type[0].to_i
    when 10
      type = 'p'
    when 20
      type = 'c'
    when 40
      type = 'd'
    when 60
      type = 'b'
    when 100
      type = '-'
    when 120
      type = 'l'
    when 140
      type = 's'
    end

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
        if n.zero? && num[n] == 1
          type.concat('r')
        elsif n == 1 && num[n] == 1
          type.concat('w')
        elsif n == 2 && num[n] == 1
          type.concat('x')
        else
          type.concat('-')
        end
      end
    end

    arrangement_l << "#{type}  #{stat.nlink} #{user}  #{group}  #{stat.size}  #{file_inf.mon} #{file_inf.mday} #{file_inf.strftime('%H:%M')} #{name}"
  end

  arrangement_l(arrangement_l)
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

def arrangement
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
  arrangement
end
