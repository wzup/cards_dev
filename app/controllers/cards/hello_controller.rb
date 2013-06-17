# coding: utf-8

require_dependency "cards/application_controller"

module Cards
  class HelloController < ApplicationController
    def index

      # Для Спрокета
      @page = 'cards/hello/index'
      @curGames = Game.last(CARDS_CONF[:games][:curGames]).reverse
      @title = "Cards. Rails super cool project"
    end
  end
end
