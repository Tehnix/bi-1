require 'test_helper'

class ConcertTest < ActiveSupport::TestCase
  test "should correctly update concert schedule" do
    Concert.update_schedule

    @concert = Concert.find_by(artist: 'KASBO')

    assert_instance_of Concert, @concert
  end
end
