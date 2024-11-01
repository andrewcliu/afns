require "test_helper"

class SysMailerTest < ActionMailer::TestCase
  test "waiver_email" do
    mail = SysMailer.waiver_email
    assert_equal "Waiver email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
