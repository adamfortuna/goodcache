require 'csv'
u = User.find 29
s = u.shelves.where(shelf: "read").first

csv_string = CSV.generate do |csv|
  csv << ["title", "author", "rating", "started_at", "completed_at", "pages", "year", "format", "review", "image_url", "isbn"]
  s.books.each do |book|
    csv << [
      book['book']['title'],
      book['book']['authors'].collect { |a| a[1]['name'] }.join(", "),
      book['rating'],
      book['started_at'] ? book['started_at'].to_date.to_s : nil,
      book['read_at'] ? book['read_at'].to_date.to_s : nil,
      book['book']['num_pages'],
      book['book']['publication_year'],
      book['book']['format'],
      book['body'].strip,
      book['book']['image_url'],
      book['book']['isbn']
    ]
  end
end
