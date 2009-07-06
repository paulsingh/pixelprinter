namespace :db do
  desc 'Download the database from Heroku and store it in a SQLite file'
  task :backup => :environment do
    today = Date.today.strftime("%m_%d_%y")
    filename = "#{RAILS_ROOT}/db/backup/pixelprinter_backup_#{today}"
    puts "Backing up database to #{filename}"
    puts `heroku db:pull sqlite://#{filename}`
  end
end