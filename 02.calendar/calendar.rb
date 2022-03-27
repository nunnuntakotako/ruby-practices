require "date"
require "optparse"

class Calendar
  def initialize(year: Date.today.year, month: Date.today.month)
    @year = year
    @month = month
  end

  def create_calendar
    # set_end_day = Date.new(set_day.year,set_day.mon,-1).mday
    set_day = Date.new(@year,@month,-1)                               
    st_1w = Date.new(@year,@month,1).wday                
    
    cal = [set_day.year,set_day.mon,set_day.mday,st_1w] #年　月　最終日 1日の曜日
    week = ["日","月","火","水","木","金","土"]
    
    puts "      #{cal[1]}月 #{cal[0]}"
    week.each do |w|
      print "#{w} "                               
    end
    
    puts "\n"                                           
    print " " * 3 * cal[3]                              
    
    (1 .. cal[2]).each do |day|
      print day.to_s.rjust(2) + " "                     
      cal[3] = cal[3]+1                                 
      if cal[3]%7 == 0                                 
        print "\n"
      end
    end
    
  end
end

params = ARGV.getopts("y:","m:")
calendar = Calendar.new(
  year: params["y"]&.to_i || Date.today.year,
  month: params["m"]&.to_i || Date.today.month
)

calendar.create_calendar