class DefineController < ApplicationController
  def show
    per_page = 3

    # from letter menu
    @char = params[:char]

    if @char
      definitions = Definition.where('pinyin_for_search between ? and ? or word between ? and ?', @char, @char.next, @char, @char.next).where(:status => 'reviewed')
    # from search
    else
      word_to_find = params[:word].gsub(' ', '') + "%"
      definitions = Definition.where('pinyin_for_search like ? or word like ?', word_to_find, word_to_find).where(:status => 'reviewed')
    end

    @definitions = definitions.paginate(:page => params[:page], :per_page => per_page).order("score desc, created_at desc")
  end
end
