# coding: utf-8

#
# таблица ассоциации для сущностей games и users
#
class CreateCardsGameUsers < ActiveRecord::Migration

  # 
  # Создать таблицу game_users. Для ассоциации.
  # 
  def up
    create_table :cards_game_users do |t|
      t.belongs_to(:game)
      t.belongs_to(:user)
      t.timestamps
      t.timestamps
    end

    add_index(:cards_game_users, :game_id, :name => :game_id)
    add_index(:cards_game_users, :user_id, :name => :user_id)

    execute <<-SQL
      ALTER TABLE cards_game_users ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id);
      ALTER TABLE cards_game_users ADD CONSTRAINT fk_game_id FOREIGN KEY (game_id) REFERENCES cards_games(id);
    SQL
  end


  # 
  # Удалить все, что было создано в up
  # 
  def down

    remove_index(:cards_game_users, :name => :user_id)
    remove_index(:cards_game_users, :name => :game_id)

    execute <<-SQL
      ALTER TABLE cards_game_users DROP CONSTRAINT fk_user_id;
      ALTER TABLE cards_game_users DROP CONSTRAINT fk_game_id;
    SQL

    drop_table(:cards_game_users)
  end
end

