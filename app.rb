require 'sinatra'
require 'pry'
require 'csv'

### Model & Methods ######

set :port, 9000

league = []
CSV.foreach('lackp_starting_rosters.csv', headers:true, header_converters: :symbol) do |row|
   league << row.to_hash
end

def by_team(league,team_name)
  league.find_all do |players|
    players[:team] == team_name
  end
end

def by_position(league,position)
  league.find_all do |players|
    players[:position] == position
  end
end

def get_position(league)
  positions = []
  league.each{|row| positions << row[:position]}
  positions.uniq
end

def get_team_names(league)
  team_names = []
  league.each do |row|
      team_names << row[:team]
    end
  team_names.uniq
end


### # Routes - Controller (MVC style) ######


get '/' do
  @league = league
  @team_names = get_team_names(league)
  @positions = get_position(league)
  erb :view_teams
end

get '/:team_name' do
  @teams_players = by_team(league, params[:team_name])
  erb :view_individual_team
end

get '/all-players/:position' do
  @players = by_position(league,params[:position])
  erb :player_position
end
