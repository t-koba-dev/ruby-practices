# frozen_string_literal: true

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if mark == 'X'

    mark.to_i
  end
end

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    # to do
  end
end

def Game
  attr_reader :scores

  def initialize(scores)
    @scores = scores
  end

  def score
    # to do
  end
end


def push_shots_to_frames(score)
  scores = score.split(',')
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
  scores[(number_of_shots - 1)..-1].each { |i| shots << Shot.new(i).score }
end

def push_when_others(score, shots, frames)
  if shots.size.zero? && (score == 'X') # strike
    frames.push([10, 0])
  else
    shots << Shot.new(score).score
  end
end

def calculate(score)
  frames = push_shots_to_frames(score)
  point = 0

  frames.each_with_index do |shots, index|
    number_of_frames = index + 1
    point += shots.sum
    if shots[0] == 10 && !the_10th_frame?(number_of_frames) # strike
      point += calculate_when_strike(frames, number_of_frames)
    elsif shots.sum == 10 && !the_10th_frame?(number_of_frames) # spare
      point += frames[number_of_frames][0]
    end
  end

  point
end

def calculate_when_strike(frames, number_of_frames)
  if (frames[number_of_frames][0] == 10) && (number_of_frames < 9)
    10 + frames[number_of_frames + 1][0]
  else
    frames[number_of_frames][0..1].sum
  end
end

def the_10th_frame?(number_of_frames)
  number_of_frames == 10
end

score = ARGV[0]

p calculate(score)
