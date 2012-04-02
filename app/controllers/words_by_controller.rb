class WordsByController < ApplicationController
  def show
    @username = params[:username]
    @user = User.where(:username => @username).first

    if @user.present?
      @definitions = Definition.where(:email => @user.email)
    end
  end
end
