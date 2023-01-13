require 'sinatra/activerecord/rake'
require_relative './config/environment'
require './app'

desc 'Start the app'
task :run do
  App.run!
end

desc 'Open a rails-like console'
task :console do
  require_all 'db/dml'
  Pry.start
end

desc 'Send a message in the #mariokart-elo channel with the current ELO ranking'
task :display_rank_in_channel do
  Command::Rank.new.rank_of_the_day
end

desc 'Put users not seen in a long time into inactive mode'
task :set_inactive_players do
  Player.includes(:games).each { |p| p.set_inactive! if p.should_be_inactive? }
end

desc 'Start a new season'
task :new_season do
  Task::NewSeason.new.process
end

desc 'Sync local database with Slack'
task :update_players do
  Task::UpdatePlayersFromSlack.new.process
end

desc 'Drop a buggy game'
task :delete_game, [:game_id] do |task, args|
  id = args[:game_id]
  Task::DeleteGame.new.process(id)
end 
