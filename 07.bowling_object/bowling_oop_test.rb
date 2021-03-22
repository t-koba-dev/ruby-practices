# frozen_string_literal: true

require 'minitest/autorun'
require './07.bowling_object/bowling_oop'

class BowlingOopTest < Minitest::Test
  def test_case1
    scores = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'.split(',')
    assert_equal 139, Game.new(scores).score
  end

  def test_case2
    scores = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'.split(',')
    assert_equal 164, Game.new(scores).score
  end

  def test_case3
    scores = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'.split(',')
    assert_equal 107, Game.new(scores).score
  end

  def test_case4
    scores = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'.split(',')
    assert_equal 134, Game.new(scores).score
  end

  def test_case5
    scores = 'X,X,X,X,X,X,X,X,X,X,X,X'.split(',')
    assert_equal 300, Game.new(scores).score
  end
end
