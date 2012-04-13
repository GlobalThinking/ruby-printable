require 'test/unit'
require 'printable'

class PrintableTest < Test::Unit::TestCase
  def test_user_create
    user = Printable::User.new(5936, 9987)
    assert user, "Unable to create user object"

    assert_nothing_raised do
      user.create({
        "first" => "franklin",
        "last"  => "strube",
        "email" => "fstrube@globalthinking.com",
        "password" => "global1968"
      })
    end
  end

  def test_user_login
    user = Printable::User.new(5936, 9987)
    assert user, "Unable to create user object"

    assert_nothing_raised do
      user.login({
        "loginid" => "fstrube@globalthinking.com",
        "password" => "global1968"
      })
    end

    assert_raise RuntimeError do
      puts user.login({
        "loginid" => "fstrube@globalthinking.com",
        "password" => "global"
      })
    end
  end
end