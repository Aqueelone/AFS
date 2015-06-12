class CreateMessengers < ActiveRecord::Migration
  def change
    create_table :messengers do |t|
      t.timestamps null: false
    end
  end
end
