# frozen_string_literal: true

require './07.bowling_object/game'
require './07.bowling_object/frame'
require './07.bowling_object/shot'
require './07.bowling_object/argv'

scores = Option.enqueue

if ARGV[0].nil?
  MiniTest::Assertions # skip
else
  p Game.new(scores).score
end
