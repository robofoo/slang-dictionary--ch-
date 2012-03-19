class DefineController < ApplicationController
  def show
    # from letter menu
    @char = params[:char]

    if @char
      chinese = Definition.where(:word => @char..@char.next, :status => 'reviewed')
      pinyin = Definition.where(:pinyin => @char..@char.next, :status => 'reviewed')
      @definitions = chinese + pinyin
    # from search
    else
      chinese = Definition.where(:word => params[:word], :status => 'reviewed')
      pinyin = Definition.where(:pinyin => params[:word], :status => 'reviewed')
      @definitions = chinese + pinyin
    end
  end
end
