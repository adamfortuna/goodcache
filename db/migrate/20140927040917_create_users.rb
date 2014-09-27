class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamp :created_at, :updated_at
      t.integer :goodreads_id

      t.json :books
    end
  end
end
