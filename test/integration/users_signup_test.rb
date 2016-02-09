require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { first_name:  "",
                               last_name:  "",
                               email: "user@invalid",
                               sk_username:  "",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    #assert_template 'users/new'
  end

  # test "valid signup information" do
  #   get signup_path
  #   assert_difference 'User.count', 1 do
  #     post_via_redirect users_path, user: { first_name:  "Kurt",
  #                                           last_name:  "Cobain",
  #                                           email: "kurt.cobain@songkick.com",
  #                                           sk_username:  "kurt-cobain",
  #                                           password: "password",
  #                                           password_confirmation: "password" }
  #   end
  #   assert_template 'users/show'
  # end
end