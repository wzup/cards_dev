require "random_in"

module Cards
  class Engine < ::Rails::Engine
    isolate_namespace Cards

    # middleware.delete(ActionDispatch::Session::CookieStore)
    

    # self в методе - это Cards::Engine instance
    # поэтому root можно вызывать без ресивера
    initializer("cards.locales") do |app|
      tracking_logger = Logger.new(app.root.join('log', "cards_engine_log.log"), 10, 30*1024*1024)
      Cards::Engine.config.i18n.load_path += Dir[root.join('my', 'locales', '*.{rb,yml}').to_s]
      Cards::Engine.config.i18n.default_locale = CARDS_CONF[:general][:dafault_locale]
      Cards::Engine.config.i18n.fallbacks = [:en] # это для вывода ошибок всегда на английском
      tracking_logger.debug "Cards::Engine specific locale settings are set. Def locale == #{CARDS_CONF[:general][:dafault_locale]}\n\n"
    end


    initializer("cards.delete_app's_session_cookiestore_moddleware_for_this_engine_only") do |app|
      app.middleware.delete(ActionDispatch::Session::CookieStore)
    end
  end
end
