# frozen_string_literal: true

def arrangement
  contents = Dir.glob('*')
  row = 3
  quantity = contents.size
  column = quantity.divmod(row)[0] + 1
  remainder = quantity.divmod(row)[1]
  view = contents.each_slice(column).to_a
  nils = []

  if view[row - 1].size < column
    (row - remainder).times { nils << nil }
    view[row - 1] = view[row - 1].concat(nils)
  end

  output(view)
end

def output(view)
  arrange = view.transpose
  arrange.each do |columns|
    columns.each do |content|
      print content.to_s.ljust(20)
    end
    print "\n"
  end
end

arrangement
