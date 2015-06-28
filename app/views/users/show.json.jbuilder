json.id @user.id
json.goodreads_id @user.goodreads_id
json.name @user.name
json.shelves @user.shelves do |shelf|
  json.name shelf.shelf
  json.books_count shelf.books.length
end
