# frozen_string_literal: true

require 'optparse'

COLUMN = 3

def arrangement
  options = ARGV.getopts('a')
  args = ['*']
  args << File::FNM_DOTMATCH if options['a']
  contents = Dir.glob(*args)
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
