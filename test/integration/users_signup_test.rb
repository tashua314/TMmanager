require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get new_user_registration_path
    assert_no_difference 'User.count' do
      post users_path, :params => { :user => { :username => "",
                                        :email => "user@invalid",
                                        :password => "foo",
                                        :password_confirmation => "bar" } }
    end
    assert_template 'users/registrations/new'
  end


  test "valid signup information with account activation" do
    get new_user_registration_path
    assert_difference 'User.count', 1 do
      post users_path, :params => { :user => { :username => "Example User",
                                          :email => "user@example.com",
                                          :password => "password",
                                          :password_confirmation => "password" } }
    end
    follow_redirect!
    assert_template 'missions/index'
    # assert is_logged_in?
  end
end