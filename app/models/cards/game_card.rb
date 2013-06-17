# coding: utf-8

module Cards
  class GameCard < ActiveRecord::Base

    attr_accessible(:game_id, :card_id, :pos, :isopen)
  
    belongs_to(:game, :class_name => :Game, :foreign_key => :game_id)
    belongs_to(:card, :class_name => :Card, :foreign_key => :card_id)
  end
end
