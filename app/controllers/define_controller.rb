class DefineController < ApplicationController
  def index
    @char = params[:char]
    @definitions = Definition.where(:word => @char..@char.next)
  end

  def show
    # from search
    @definitions = Definition.where(:word => params[:word])
  end
end
