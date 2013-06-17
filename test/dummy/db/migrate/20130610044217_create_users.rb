# coding: utf-8

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.column(:name, :string, :limit => 50, :null => true)
      t.column(:ip, :string, :limit => 32, :null => false)

      t.timestamps
    end
  end
end
