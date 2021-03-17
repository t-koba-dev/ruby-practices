require 'minitest/autorun'
require './07.bowling_object/bowling_oop'

# bowling_oop.rbの以下の行をコメントアウトしてからテストを実行する(score = ARGV[0] よりscoreがnilとなってしまうため)
# p calculate(score)

class BowlingOopTest < Minitest::Test
  def test_case1
    score = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
    assert_equal 139, calculate(score)
  end

  def test_case2
    score = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'
    assert_equal 164, calculate(score)
  end

  def test_case3
    score = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    assert_equal 107, calculate(score)
  end

  def test_case4
    score = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'
    assert_equal 134, calculate(score)
  end

  def test_case5
    score = 'X,X,X,X,X,X,X,X,X,X,X,X'
    assert_equal 300, calculate(score)
  end
end
