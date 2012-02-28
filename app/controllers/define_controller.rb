class DefineController < ApplicationController
  def index
    @char = params[:char]
    @definition_list = Definition.where(:word => @char..@char.next)
  end

  def show
    @definition_list = Definition.where(:word => params[:word])
  end

  def search
    @definition_list = Definition.find(:all, :conditions => ["word like ?", "#{params[:word]}%"])
  end
end
