module Cards
  class ApplicationController < ActionController::Base
    protect_from_forgery

    # Эти фильтры - это как типа зендовские PreDispatch и PostDispatch.
    # before_filter, after_filter, around_filter
    before_filter(
      :setLocale,
    )

    # default_url_options - если есть локаль /ru|en в урле от юзера, то она будет добавлена
    # во все генерируемые урлы-хелперы link_to. Если нет - не будет добавлена,
    # а берется та, что по умолчанию.
    def default_url_options(options={})
      logger.debug "default_url_options is passed options: #{options.inspect}\n\n"
      return { :locale => I18n.locale } if params[:locale]
      return { :locale => nil }
    end

    
    private

      # Установить локаль
      def setLocale
        I18n.locale = params[:locale] || I18n.default_locale
      end
  end
end
