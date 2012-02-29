class DefineController < ApplicationController
  def index
    @char = params[:char]
    @definition_list = Definition.where(:word => @char..@char.next)
  end

  def show
    if request.method == 'GET'
      @definition_list = Definition.where(:word => params[:word])
    # from search
    elsif request.method == 'POST'
      @definition_list = Definition.find(:all, :conditions => ["word like ?", "%#{params[:word]}%"])
    end
  end
end
