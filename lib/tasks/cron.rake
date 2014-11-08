desc 'Runs cron maintenance tasks.'
task cron: :environment do
  puts "Running cron at #{Time.now.strftime('%Y/%m/%d %H:%M:%S')}..."
  
  Shelf.all.each(&:annotate_books!)

  puts "Done running cron at #{Time.now.strftime('%Y/%m/%d %H:%M:%S')}..."
end
