module GoogleTranslator
  extend ActiveSupport::Concern

  included do
    before_action :write_translation_cookie, if: :translation_requested?
    before_action :current_language
  end

  def write_translation_cookie
    delete_translation_cookies

    cookies[:googtrans] = {
      value: "/en/#{params[:translate]}",
      domain: "#{ENV['DOMAIN_NAME']}"
    }
  end

  def delete_translation_cookies
    cookies.delete(:googtrans, domain: :all)
  end

  def translation_requested?
    params[:translate].present?
  end

  def current_language
    if cookies[:googtrans].nil?
      @current_lang = 'en'
    else
      @current_lang = cookies[:googtrans].split('/').last
    end
  end
end
