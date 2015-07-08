class CreateUserBooks < ActiveRecord::Migration
  def change
    create_table :user_books do |t|
      t.timestamps
      t.integer :user_id
      t.integer :book_id
      t.json :review
    end
  end
end
