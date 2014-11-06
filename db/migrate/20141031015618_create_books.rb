class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :isbn, :title
      t.json :genres
    end

    add_index :books, :isbn
  end
end
