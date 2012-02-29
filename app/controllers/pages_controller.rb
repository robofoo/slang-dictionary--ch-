class PagesController < ApplicationController
  def home
    @random_definition = Definition.offset(rand(Definition.count)).first
  end
end
