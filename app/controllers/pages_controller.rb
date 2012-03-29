class PagesController < ApplicationController
  def home
    random_per_page = 3
    valid_defs = Definition.where(:status => 'reviewed')
    logger.debug Definition.where(:status => 'reviewed').to_sql
    def_count = valid_defs.count

    if def_count > random_per_page
      @definitions = Definition.random_subset(valid_defs, random_per_page)
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
