# frozen_string_literal: true

COLUMN = 3

def arrangement
  contents = Dir.glob('*')
  quantity = contents.size
  remainder = quantity.divmod(COLUMN)[1]

  row = if quantity <= COLUMN || remainder.zero?
          quantity.divmod(COLUMN)[0]
        else
          quantity.divmod(COLUMN)[0] + 1
        end

  if remainder.zero?
    view = contents.each_slice(row).to_a
  else
    remainder.times { view = contents.each_slice(row).to_a }
  end

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
