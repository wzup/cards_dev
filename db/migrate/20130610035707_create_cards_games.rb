# coding: utf-8

class CreateCardsGames < ActiveRecord::Migration

  def up
    create_table :cards_games do |t|
      t.column(:gamekey, :string, :limit => 50, :null => true)
      t.references(:user)
      t.timestamps
    end

    # Добавить ФК
    execute <<-SQL
      ALTER TABLE cards_games ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id)
    SQL
  end

  def down
    # Удалить ФК, откат назад
    execute <<-SQL
      ALTER TABLE cards_games DROP CONSTRAINT fk_user_id
    SQL

    drop_table :cards_games
  end
end
