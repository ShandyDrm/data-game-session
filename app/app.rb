require 'sinatra'
require 'sinatra/json'
require 'sinatra/activerecord'
require 'json'

require_relative 'models/game_session'

require_relative 'requests/adapter_random_word'

get '/game-sessions' do
  json GameSession.all
end

get '/game-sessions/:id' do
  game_session = GameSession.find_by_id(params[:id])

  if game_session
    halt 200, json(game_session)
  else
    halt 404, json(message: 'game session not found')
  end
end

post '/game-sessions' do
  json_payload = JSON.parse(request.body.read)

  length = json_payload['length']
  game_session_payload = {
    'current_progress': json_payload['current_progress'] || '*' * length,
    'used_letters': json_payload['used_letters'] || '',
    'lives': json_payload['lives'],
    'answer': AdapterRandomWord.random_word({length: length})
  }

  game_session = GameSession.create!(game_session_payload)
  json game_session
rescue ActiveRecord::RecordInvalid => e
  halt 403, json(message: e.message)
rescue StandardError => e
  halt 500, json(message: 'internal server error')
end

patch '/game-sessions/:id' do
  game_session = GameSession.find_by_id(params[:id])

  halt 404 unless game_session

  json_game_session = JSON.parse(request.body.read)
  game_session.update!(json_game_session)
  json game_session
rescue ActiveRecord::RecordInvalid => e
  halt 403, json(message: e.message)
rescue StandardError => e
  halt 500, json(message: 'internal server error')
end

delete '/game-sessions/:id' do
  game_session = GameSession.find_by_id(params[:id])

  if game_session
    game_session.destroy
  else
    halt 404
  end
end
