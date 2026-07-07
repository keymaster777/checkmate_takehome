class CreateMenuItems < ActiveRecord::Migration[7.1]
  def change
    create_table :menu_items do |t|
      t.string :name
      t.integer :price_cents
      t.integer :prep_seconds

      t.timestamps
    end
  end
end
