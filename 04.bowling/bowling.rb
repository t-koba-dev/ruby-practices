# frozen_string_literal: true

def push_shos_to_frames(score)
  scores = score.chars
  frames = []
  shots = []

  scores.each_with_index do |s, index|
    number_of_shots = index + 1
    if frames.size == 9
      push_when_frame10(scores, number_of_shots, shots)
      frames.push(shots)
      break
    else
      push_when_others(s, shots, frames)
      if shots.size == 2
        frames.push(shots.dup)
        shots.clear
      end
    end
  end

  frames
end

def push_when_frame10(scores, number_of_shots, shots)
  scores[(number_of_shots - 1)..-1].each { |i| shots << (i == 'X' ? 10 : i.to_i) }
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

  frames.each_with_index do |shots, number_of_frames_minus1|
    point += shots.sum
    if shots[0] == 10 && ((number_of_frames_minus1 + 1) != 10) # strike
      point += calculate_when_strike(frames, number_of_frames_minus1)
    elsif shots.sum == 10 && ((number_of_frames_minus1 + 1) != 10) # spare
      point += frames[number_of_frames_minus1 + 1][0]
    end
  end

  point
end

def calculate_when_strike(frames, number_of_frames_minus1)
  if (frames[number_of_frames_minus1 + 1][0] == 10) && ((number_of_frames_minus1 + 1) < 9)
    10 + frames[number_of_frames_minus1 + 2][0]
  else
    frames[number_of_frames_minus1 + 1][0..1].sum
  end
end

score = ARGV[0]

p calculate(score)
