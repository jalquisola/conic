require 'test_helper'

class ShortMessagesControllerTest < ActionController::TestCase
  setup do
    @short_message = short_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:short_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create short_message" do
    assert_difference('ShortMessage.count') do
      post :create, short_message: {  }
    end

    assert_redirected_to short_message_path(assigns(:short_message))
  end

  test "should show short_message" do
    get :show, id: @short_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @short_message
    assert_response :success
  end

  test "should update short_message" do
    patch :update, id: @short_message, short_message: {  }
    assert_redirected_to short_message_path(assigns(:short_message))
  end

  test "should destroy short_message" do
    assert_difference('ShortMessage.count', -1) do
      delete :destroy, id: @short_message
    end

    assert_redirected_to short_messages_path
  end
end
