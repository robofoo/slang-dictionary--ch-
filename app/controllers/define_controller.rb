class DefineController < ApplicationController
  def show
    # from letter menu
    @char = params[:char]
    if @char
      @definitions = Definition.where(:word => @char..@char.next)
    # from search
    else
      @definitions = Definition.where(:word => params[:word])
    end
  end
end
