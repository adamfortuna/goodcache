class AddBooksCountToShelves < ActiveRecord::Migration
  def change
    add_column :shelves, :books_count, :integer, default: 0
  end
end
