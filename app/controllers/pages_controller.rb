class PagesController < ApplicationController
  def home
    @definitions = Definition.offset(rand(Definition.count))
  end
end
