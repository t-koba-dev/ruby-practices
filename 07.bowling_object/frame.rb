# frozen_string_literal: true

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
