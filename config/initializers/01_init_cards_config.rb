# coding: utf-8

unless defined?(CARDS_CONF)
  File.open(File.expand_path("../../cards_config.rb", __FILE__)) { |f|
    CARDS_CONF = eval(f.read())
    if(CARDS_CONF.class == Hash) then f.close() end
  }
end