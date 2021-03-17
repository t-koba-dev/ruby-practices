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

  def score(frames)
    point = @first_shot.score + @second_shot.score + @third_shot.score
    if @first_shot.score == 10
      point += calculate_when_strike(frames)
    elsif @first_shot.score + @second_shot.score == 10
      point += frames[frames.find_index(self) + 1].first_shot.score
    end
    point
  end

  def score_when_last_frame
    point = @first_shot.score + @second_shot.score + @third_shot.score
  end

  def calculate_when_strike(frames)
    if (frames[frames.find_index(self) + 1].first_shot.score == 10) && (frames.find_index(self) < 8)
      10 + frames[frames.find_index(self) + 2].first_shot.score
    else
      frames[frames.find_index(self) + 1].first_shot.score + frames[frames.find_index(self) + 1].second_shot.score
    end
  end
end

class Game
  attr_reader :scores

  def initialize(scores)
    @scores = scores
  end

  def score
    frames = AddShotsToFrame.push_shots_to_frames(scores)
    point = 0
    9.times do |frame|
      point += frames[frame].score(frames)
    end
    point += frames.last.score_when_last_frame
  end
end

class AddShotsToFrame
  def self.push_shots_to_frames(scores)
    frames = []
    shots = []
    scores.each_with_index do |shot, index|
      number_of_shots = index + 1
      if frames.size == 9
        push_when_frame10(scores, number_of_shots, shots)
        frames.push(Frame.new(shots[0], shots[1], shots[2]))
        break
      else
        push_when_others(shot, shots, frames)
        if shots.size == 2
          frames.push(Frame.new(shots.dup[0], shots.dup[1]))
          shots.clear
        end
      end
    end

    frames
  end

  def self.push_when_frame10(scores, number_of_shots, shots)
    scores[(number_of_shots - 1)..-1].each { |i| shots << Shot.new(i).score }
  end

  def self.push_when_others(score, shots, frames)
    if shots.size.zero? && (score == 'X') # strike
      frames.push(Frame.new(10, 0))
    else
      shots << Shot.new(score).score
    end
  end
end

scores = ARGV[0]&.split(',')

p Game.new(scores).score
