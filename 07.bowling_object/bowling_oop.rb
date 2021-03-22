# frozen_string_literal: true

require './07.bowling_object/game'
require './07.bowling_object/frame'
require './07.bowling_object/shot'

scores = ARGV[0]&.split(',')

p Game.new(scores).score
