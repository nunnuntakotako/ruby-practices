# frozen_string_literal: true

score = ARGV[0]
scores = score.chars
shots = []
scores.each do |s|
  shots << if s == 'X'
             10
           else
             s.to_i
           end
end

frame = 0
max_frame = 10
count = 0
score = [0] * max_frame

shots.length.times do |i|
  if frame + 1 != max_frame
    if shots[i] == 10
      if count.zero?
        count = 1
        score[frame] = shots[i] + shots[i + 1] + shots[i + 2]
      else
        score[frame] = shots[i] + shots[i + 1]
      end

    elsif shots[i] + score[frame] == 10
      score[frame] = score[frame] + shots[i] + shots[i + 1]
    else
      score[frame] += shots[i]
    end
    count += 1
    if count == 2
      count = 0
      frame += 1
    end

  else
    score[frame] += shots[i]
  end
end

puts score.sum
