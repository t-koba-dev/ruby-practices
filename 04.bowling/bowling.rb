# frozen_string_literal: true

def push_shos_to_frames(score)
  scores = score.chars
  frames = []
  shots = []

  scores.each_with_index do |s, index|
    if frames.size == 9
      push_when_frame10(scores, index, shots)
      frames.push(shots)
      break
    else
      push_when_others(s, shots, frames)
      if shots.size == 2
        frames.push(shots.map { |n| n })
        shots.clear
      end
    end
  end

  frames
end

def push_when_frame10(scores, index, shots)
  scores[index..-1].each { |i| shots << (i == 'X' ? 10 : i.to_i) }
end

def push_when_others(score, shots, frames)
  if shots.size.zero? && (score == 'X')
    frames.push([10, 0])
  elsif score == 'X'
    shots << 10
  else
    shots << score.to_i
  end
end

def calculate(score)
  frames = push_shos_to_frames(score)
  point = 0

  frames.each_with_index do |shots, index|
    point += shots.sum
    if shots[0] == 10 && ((index + 1) != 10) # strike
      point += if (frames[index + 1][0] == 10) && ((index + 1) < 9)
                 10 + frames[index + 2][0]
               else
                 frames[index + 1][0..1].sum
               end
    elsif shots.sum == 10 && ((index + 1) != 10) # spare
      point += frames[index + 1][0]
    end
  end

  point
end

score = ARGV[0]

p calculate(score)
