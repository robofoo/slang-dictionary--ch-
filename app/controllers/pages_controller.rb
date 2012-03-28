class PagesController < ApplicationController
  def home
    random_per_page = 3
    valid_defs = Definition.where(:status => 'reviewed')
    def_count = valid_defs.count

    if def_count > random_per_page
      random_ids = []
      @definitions = []

      begin
        new_id = rand(def_count - 1)
        if random_ids.include?(new_id) == false
          random_ids << new_id 
          @definitions << valid_defs.offset(new_id).first
        end
      end while random_ids.count < random_per_page
    else
      @definitions = valid_defs.all
    end
  end

  def contact
  end

  def about
  end

  def error
    if request.referrer && (request.referrer.match(new_user_session_path) || request.referrer.match(new_user_registration_path))
      params[:error_code] = 2
    end

    @error_message = params[:error_message]
  end

  def pinger
  end
end
