class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale, :store_location

  # redirect to current page after sign in
  def store_location
    # after registration is another special case - do not redirect to "current page"
    session[:user_return_to] = request.url unless ["devise/passwords", "devise/sessions", "devise/registrations"].include?(params[:controller])
  end

  def after_sign_in_path_for(resource)
    # if we came from accept or reject page goto review page instead
    if stored_location_for(resource).match(/accept$/) || stored_location_for(resource).match(/reject$/)
      review_definitions_path
    else
      stored_location_for(resource) || root_path
    end
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"

    # only set locale if language is other than Chinese
    if I18n.locale == 'zh-CN'.to_sym
      { }
    else
      { :locale => I18n.locale }
    end
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
