class PagesController < ApplicationController
  def home
    random_per_page = 3
    def_count = Definition.count

    if def_count > random_per_page
      @definitions = Definition.offset(rand(def_count - (random_per_page - 1)))[0..(random_per_page - 1)]
    else
      @definitions = Definition.all
    end
  end
end
