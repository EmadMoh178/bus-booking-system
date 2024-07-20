require "test_helper"

class SeatsControllerTest < ActionDispatch::IntegrationTest
  test "should get available" do
    get seats_available_url
    assert_response :success
  end

  test "should get book" do
    get seats_book_url
    assert_response :success
  end
end
