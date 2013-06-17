# coding: utf-8

unless defined?(APP_CONF)
  File.open(File.expand_path("../../myConfig.rb", __FILE__)) { |f|
    APP_CONF = eval(f.read())
    if(APP_CONF.class == Hash) then f.close() end
  }
end
