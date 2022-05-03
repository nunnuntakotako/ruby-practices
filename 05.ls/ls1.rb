# frozen_string_literal: true

def arrangement
  contents = Dir.glob('*')
  RETSU = 3
  quantity = contents.size
  gyo = quantity.divmod(RETSU)[0] + 1
    if quantity <= RETSU
      gyo = quantity.divmod(RETSU)[0]
    end
  remainder = quantity.divmod(RETSU)[1]
  view = contents.each_slice(gyo).to_a
  nils = []

  view[-1] << nil while view[- 1].size < gyo

  output(view)
end

def output(view)
  arrange = view.transpose
  arrange.each do |gyos|
    gyos.each do |content|
      print content.to_s.ljust(20)
    end
    print "\n"
  end
end

arrangement
