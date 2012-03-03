class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

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
