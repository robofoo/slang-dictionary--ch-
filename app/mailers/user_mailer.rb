# encoding: UTF-8

class UserMailer < ActionMailer::Base
  default from: "noreply@chengshicidian.com"

  def confirm_definition_email(email, word, code)
    @confirm_url = "#{confirm_url}?code=#{code}"
    @word = word
    mail(:to => email, :subject => "城市词典- #{word}")
  end
end
