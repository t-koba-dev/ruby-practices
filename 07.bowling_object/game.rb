# frozen_string_literal: true

class Game
  attr_reader :scores

  THE_PREVIOUS_FRAME_FROM_THE_END = 9
  MAXIMUM_NUMBER_OF_SHOTS_IN_THE_FRAME = 2

  def initialize(scores)
    @scores = scores
  end

  def score
    frames = push_shots_to_frames(scores)
    point = 0
    9.times do |frame|
      point += frames[frame].score
      if frames[frame].first_shot.score == 10
        point += self.calculate_when_strike(frames, frame)
      elsif frames[frame].first_shot.score + frames[frame].second_shot.score == 10
        point += self.caluclate_when_spare(frames, frame)
      end
    end
    point += score_when_last_frame(frames)
  end

  def calculate_when_strike(frames, frame)
    if (frames[frame + 1].first_shot.score == 10) && (frame < 8)
      10 + frames[frame + 2].first_shot.score
    else
      frames[frame + 1].first_shot.score + frames[frame + 1].second_shot.score
    end
  end

  def caluclate_when_spare(frames, frame)
    frames[frame + 1].first_shot.score
  end

  private

  def push_shots_to_frames(scores)
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

  def push_when_frame10(scores, number_of_shots, shots)
    scores[(number_of_shots - 1)..-1].each { |i| shots << Shot.new(i).score }
  end

  def push_when_others(shot, shots, frames)
    if shots.size.zero? && (shot == 'X') # strike
      frames.push(Frame.new(10, 0))
    else
      shots << Shot.new(shot).score
    end
  end

  def score_when_last_frame(frames)
    frames.last.first_shot.score + frames.last.second_shot.score + frames.last.third_shot.score
  end
end
