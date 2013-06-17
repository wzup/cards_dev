# coding: utf-8

# class CreateCardsCards < ActiveRecord::Migration
#   def change
#     create_table(:cards_cards) do |t|
#       t.column(:suit, :integer, :limit => 1, :null => false)
#       t.column(:rank, :string, :limit => 15, :null => false)
#       t.column(:pic, :string, :limit => 10, :null => false, :default => '0')
#     end
#     # add_index(:cards_cards, :rank)
#     # add_index(:cards_cards, :pic)
#   end
# end


class CreateCardsCards < ActiveRecord::Migration

  # 
  # Создать таблицу game_cards. 
  # Для ассоциации сущности Card
  # 
  def up
    create_table(:cards_cards) do |t|
      t.column(:suit, :integer, :limit => 1, :null => false)
      t.column(:rank, :string, :limit => 15, :null => false)
      t.column(:pic, :string, :limit => 10, :null => false, :default => '0')
    end
    add_index(:cards_cards, :rank)
    add_index(:cards_cards, :pic)
    
    # Тут же и заполняю таблицу cards_cards.
    # Все 54 карты:
    # id | suit | rank | pic
    # 1  |  1   | Ace  | ac
    # 2  |  2   | Ace  | ad
    # filepath: engine.root + /db/__date/cards_dump.txt
    filepath = Cards::Engine.root.to_path + CARDS_CONF[:games][:cards_dump_path]
    execute <<-SQL
      COPY cards_cards FROM '#{filepath}';
    SQL
  end


  # 
  # Удалить все, что было создано в up
  # 
  def down
    remove_index(:cards_cards, :rank)
    remove_index(:cards_cards, :pic)
    execute <<-SQL
      DELETE FROM cards_cards
    SQL
    drop_table(:cards_cards)
  end  
end