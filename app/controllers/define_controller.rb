class DefineController < ApplicationController
  def index
    @char = params[:char]
    @definitions = Definition.where(:word => @char..@char.next)
  end

  def show
    if request.method == 'GET'
      @definitions = Definition.where(:word => params[:word])
    # from search
    elsif request.method == 'POST'
      @definitions = Definition.find(:all, :conditions => ["word like ?", "%#{params[:word]}%"])
    end
  end
end
