require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @relationship = Relationship.new(:follower_id => users(:follower).id,
                                    :following_id => users(:following).id)
  end

  # test "should be valid" do
  #   assert @relationship.valid?
  # end

  # test "should require a follower_id" do
  #   @relationship.follower_id = nil
  #   assert_not @relationship.valid?
  # end

  # test "should require a following_id" do
  #   @relationship.following_id = nil
  #   assert_not @relationship.valid?
  # end
end
