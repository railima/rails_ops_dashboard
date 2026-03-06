namespace :test_ops do
  desc 'A test task for ops dashboard specs'
  task greet: :environment do
    puts 'Hello from test_ops:greet'
  end
end
