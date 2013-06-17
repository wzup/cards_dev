# coding: utf-8

module Cards
  class Card < ActiveRecord::Base
    attr_accessible(:pic, :rank, :suit)

    has_many(:games, :class_name => :Game,
      :through => :game_cards,
      :order => "id DESC"
    )
    has_many(:game_cards, :class_name => :GameCard)
  end
end
