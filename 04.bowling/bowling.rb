# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  shots << if s == 'X'
             10
           else
             s.to_i
           end
end

frame = 0
MAX_FRAME = 10
shot_count = 0
score = [0] * MAX_FRAME

shots.length.times do |i|
  if frame + 1 != MAX_FRAME
    if shots[i] == 10
      if shot_count.zero?
        shot_count = 1
        score[frame] = shots[i] + shots[i + 1] + shots[i + 2]
      else
        score[frame] = shots[i] + shots[i + 1]
      end

    elsif shots[i] + score[frame] == 10
      score[frame] = score[frame] + shots[i] + shots[i + 1]
    else
      score[frame] += shots[i]
    end
    shot_count += 1
    if shot_count == 2
      shot_count = 0
      frame += 1
    end

  else
    score[frame] += shots[i]
  end
end

puts score.sum
