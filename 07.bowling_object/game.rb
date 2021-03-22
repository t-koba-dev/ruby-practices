# frozen_string_literal: true

class Game
  attr_reader :scores

  def initialize(scores)
    @scores = scores
  end

  def score
    frames = Frame.push_shots_to_frames(scores)
    point = 0
    9.times do |frame|
      point += frames[frame].score(frames)
    end
    point += frames.last.score_when_last_frame
  end
end

scores = ARGV[0]&.split(',')
