require 'rubygems'
require 'sinatra'

use Rack::Session::Pool, :expire_after => 2592000

get '/' do
  @board = [[nil, nil, nil], [nil,nil,nil], [nil, nil, nil]]
  session[:info] = {:board => @board, :player => 'X'}
  erb :index
end

get '/set_value' do
  @board = session[:info][:board]
  @player = session[:info][:player]
  @board[params[:row].to_i][params[:column].to_i] = @player
  @win = win?(params[:row].to_i, params[:column].to_i, @board, @player)
  session[:info] = {:board => @board, :player => @player == 'X' ? 'O' : 'X'}
  erb :game_body
end

def win?(row, col, board, player)
  lines = [[[0,0],[1,1],[2,2]], [[2,0],[1,1],[0,2]]]
  lines << (0..2).map { |c1| [row, c1] }
  lines << (0..2).map { |r1| [r1, col] }
  win = lines.any? do |line|
    line.all? { |row,col| board[row][col] == player }
  end
end