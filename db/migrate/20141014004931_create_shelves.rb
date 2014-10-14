class CreateShelves < ActiveRecord::Migration
  def change
    create_table :shelves do |t|
      t.timestamps
      t.references :user
      t.string :shelf
      t.json :books
    end
  end
end
