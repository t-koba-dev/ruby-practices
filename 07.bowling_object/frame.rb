# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot, :third_shot
  THE_PREVIOUS_FRAME_FROM_THE_END = 9
  MAXIMUM_NUMBER_OF_SHOTS_IN_THE_FRAME = 2

  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def self.push_shots_to_frames(scores)
    frames = []
    shots = []
    scores.each_with_index do |shot, index|
      number_of_shots = index + 1
      if frames.size == THE_PREVIOUS_FRAME_FROM_THE_END
        push_when_frame10(scores, number_of_shots, shots)
        frames.push(Frame.new(shots[0], shots[1], shots[2]))
        break
      else
        push_when_others(shot, shots, frames)
        if shots.size == MAXIMUM_NUMBER_OF_SHOTS_IN_THE_FRAME
          frames.push(Frame.new(shots[0], shots[1]))
          shots.clear
        end
      end
    end

    frames
  end

  def self.push_when_frame10(scores, number_of_shots, shots)
    scores[(number_of_shots - 1)..-1].each { |i| shots << Shot.new(i).score }
  end

  def self.push_when_others(shot, shots, frames)
    if shots.size.zero? && (shot == 'X') # strike
      frames.push(Frame.new(10, 0))
    else
      shots << Shot.new(shot).score
    end
  end

  def score(frames)
    point = @first_shot.score + @second_shot.score + @third_shot.score
    if @first_shot.score == 10
      point += calculate_when_strike(frames)
    elsif @first_shot.score + @second_shot.score == 10
      point += frames[frames.index(self) + 1].first_shot.score
    end
    point
  end

  def score_when_last_frame
    @first_shot.score + @second_shot.score + @third_shot.score
  end

  def calculate_when_strike(frames)
    if (frames[frames.index(self) + 1].first_shot.score == 10) && (frames.index(self) < 8)
      10 + frames[frames.index(self) + 2].first_shot.score
    else
      frames[frames.index(self) + 1].first_shot.score + frames[frames.index(self) + 1].second_shot.score
    end
  end
end
