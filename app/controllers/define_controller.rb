class DefineController < ApplicationController
  def show
    # from letter menu
    @char = params[:char]

    if @char
      @definitions = Definition.where(:word => @char..@char.next)
    # from search
    else
      chinese = Definition.where(:word => params[:word])
      pinyin = Definition.where(:pinyin => params[:word])
      @definitions = chinese + pinyin
    end
  end
end
