class DefineController < ApplicationController
  def show
    # from letter menu
    @char = params[:char]

    if @char
      chinese = Definition.where(:word => @char..@char.next, :status => 'reviewed')
      pinyin = Definition.where(:pinyin_for_search => @char..@char.next, :status => 'reviewed')
    # from search
    else
      chinese = Definition.where(:word => params[:word], :status => 'reviewed')
      # pinyin_for_search has spaces stripped
      pinyin = Definition.where(:pinyin_for_search => params[:word].gsub(' ',''), :status => 'reviewed')
    end

    @definitions = chinese + pinyin
  end
end
