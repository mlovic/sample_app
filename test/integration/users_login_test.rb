require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with valid information followed by logout" do
    get login_path
    post sessions_path, session: { email: @user.email, password: 'password' }
    assert _logged_in?
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=#{login_path}]", count: 0
    assert_select "a[href=#{logout_path}]"
    assert_select "a[href=#{user_path(@user)}]"
    delete logout_path
    assert_not _logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=#{login_path}]"
    assert_select "a[href=#{logout_path}]",      count: 0
    assert_select "a[href=#{user_path(@user)}]", count: 0
  end
end
