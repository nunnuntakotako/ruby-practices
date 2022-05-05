# frozen_string_literal: true

COLUMN = 3

def arrangement
  contents = Dir.glob('*')
  quantity = contents.size
  row = quantity.ceil
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
