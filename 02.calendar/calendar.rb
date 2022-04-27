require "date"
require "optparse"

class Calendar
  def initialize(year: Date.today.year, month: Date.today.month)
    @year = year
    @month = month
  end

  def create_calendar
    set_day = Date.new(@year,@month,-1)
    start_week = Date.new(@year,@month,1).wday
    this_year = set_day.year
    this_month = set_day.mon
    last_day = set_day.mday

    week = ["日","月","火","水","木","金","土"]

    puts "      #{this_month}月 #{this_year}"
    week.each do |w|
      print "#{w} "
    end

    puts "\n"
    print " " * 3 * start_week

    (1 .. last_day).each do |day|
      print day.to_s.rjust(2) + " "
      start_week = start_week + 1
      print "\n" if start_week % 7 == 0
    end

  end
end

params = ARGV.getopts("y:","m:")
calendar = Calendar.new(
  year: params["y"]&.to_i || Date.today.year,
  month: params["m"]&.to_i || Date.today.month
)

calendar.create_calendar
