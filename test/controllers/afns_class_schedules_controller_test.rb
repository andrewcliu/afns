require 'test_helper'

class AfnsClassSchedulesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get afns_class_schedules_new_url
    assert_response :success
  end

  test "should get create" do
    get afns_class_schedules_create_url
    assert_response :success
  end

  test "should get edit" do
    get afns_class_schedules_edit_url
    assert_response :success
  end

  test "should get update" do
    get afns_class_schedules_update_url
    assert_response :success
  end

  test "should get destroy" do
    get afns_class_schedules_destroy_url
    assert_response :success
  end

end
