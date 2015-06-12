class CreateDashboards < ActiveRecord::Migration
  def change
    create_table :dashboards do |t|
      t.references :user
      t.references :messenger
      t.timestamps null: false
    end
  end
end
