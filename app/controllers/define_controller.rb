class DefineController < ApplicationController
  def show
    # from letter menu
    @char = params[:char]

    if @char
      chinese = Definition.where(:word => @char..@char.next)
      pinyin = Definition.where(:pinyin => @char..@char.next)
      @definitions = chinese + pinyin
    # from search
    else
      chinese = Definition.where(:word => params[:word])
      pinyin = Definition.where(:pinyin => params[:word])
      @definitions = chinese + pinyin
    end
  end
end
