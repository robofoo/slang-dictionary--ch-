class DefineController < ApplicationController
  def show
    @char = params[:char]
    @definitions = Definition.where(:word => @char..@char.next)
  end
end
