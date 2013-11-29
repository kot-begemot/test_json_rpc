require 'test_helper'

class JsonRpcControllerTest < ActionController::TestCase
  test "successfull login" do
    json_request = {"user"=>{"email"=>"max@example.com", "password"=>"123123123123"}}.to_json
    post(:login, json_request)

    assert_response 202
    assert_equal({"auth_token" => "nFEEbemtrmxJ9H-ocFDQ", "email" => "max@example.com"}, response_json)
  end

  test "no such user login" do
    json_request = {"user"=>{"email"=>"test@example.com", "password"=>"1231231"}}.to_json
    post(:login, json_request)

    assert_response 404
    assert_equal({"error"=>"Not Found"}, response_json)
  end

  test "failed login" do
    json_request = {"user"=>{"email"=>"max@example.com", "password"=>"1231231"}}.to_json
    post(:login, json_request)

    assert_response 401
    assert_equal({"error"=>"Unauthorized"}, response_json)
  end

  test "token authentication" do
    json_request = {"auth_token" => "nFEEbemtrmxJ9H-ocFDQ", "a" => 1, "b" => 2}.to_json
    post(:add, json_request)

    assert_response :success
    assert_equal({"result"=> 3}, response_json)
  end

  test "ADD: wrong params" do
    json_request = {"auth_token" => "nFEEbemtrmxJ9H-ocFDQ", "a" => 1, "b" => "a"}.to_json
    post(:add, json_request)

    assert_response 500
    assert_equal({"error"=>"Input string was not in a correct format."}, response_json)
  end
end
