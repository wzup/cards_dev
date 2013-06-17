require 'test_helper'

module Cards
  class GamesControllerTest < ActionController::TestCase
    test "should get index" do
      get :index
      assert_response :success
    end
  
    test "should get show" do
      get :show
      assert_response :success
    end
  
    test "should get create" do
      get :create
      assert_response :success
    end
  
    test "should get join" do
      get :join
      assert_response :success
    end
  
    test "should get turncard" do
      get :turncard
      assert_response :success
    end
  
    test "should get pingstate" do
      get :pingstate
      assert_response :success
    end
  
    test "should get destroy" do
      get :destroy
      assert_response :success
    end
  
    test "should get update" do
      get :update
      assert_response :success
    end
  
  end
end
