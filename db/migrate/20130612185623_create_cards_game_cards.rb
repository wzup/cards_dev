# coding: utf-8

class CreateCardsGameCards < ActiveRecord::Migration

  # 
  # Создать таблицу cards_game_cards. 
  # Для ассоциации сущностей Cards::Game и Cards::Card
  # 
  def up
    create_table(:cards_game_cards) do |t|
      t.belongs_to(:game)
      t.belongs_to(:card)
      t.column(:isopen, :integer, :limit => 1, :null => false, :default => '0')
      t.column(:pos, :integer, :limit => 2, :null => false)
      t.timestamps
    end

    # add_index(:имя_таблицы, :имя_колонки)
    # Имя индекса он сделает автоматом, можно не беспокоиться.
    # будет что-то типа index_cards_game_cards_on_card_id
    add_index(:cards_game_cards, :game_id)
    add_index(:cards_game_cards, :card_id)
    
    execute <<-SQL
      ALTER TABLE cards_game_cards ADD CONSTRAINT fk_game_id FOREIGN KEY (game_id) REFERENCES cards_games(id);
      ALTER TABLE cards_game_cards ADD CONSTRAINT fk_card_id FOREIGN KEY (card_id) REFERENCES cards_cards(id);
    SQL
  end


  # 
  # Удалить все, что было создано в up
  # 
  def down
    
    # remove_index(:имя_таблицы, :имя_колонки)
    # Имя индекса он определит автоматом, можно не беспокоиться.
    remove_index(:cards_game_cards, :card_id)
    remove_index(:cards_game_cards, :game_id)
    execute <<-SQL
      ALTER TABLE cards_game_cards DROP CONSTRAINT fk_card_id;
      ALTER TABLE cards_game_cards DROP CONSTRAINT fk_game_id;
    SQL
    drop_table(:cards_game_cards)
  end
end
