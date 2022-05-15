# frozen_string_literal: true

require 'optparse'

COLUMN = 3

def arrangement
  options = ARGV.getopts('r')
  contents = Dir.glob('*')
  contents = contents.reverse if options['r']
  quantity = contents.length.to_f
  row = (quantity / COLUMN).ceil
  view = contents.each_slice(row).to_a

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

arrangement
