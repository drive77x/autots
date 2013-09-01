require 'sinatra/base'
require 'haml'

module Ayaneru
	class Server < Sinatra::Base
		get '/' do
			haml :index
		end

		get '/schedule' do
			@registered_tags = Ayaneru.redis.lrange "tags", 0, -1
			@results = []
			@registered_tags.each do |tag|
				r = Ayaneru.niconico.search(tag).to_s.split("\n")
				@results.push JSON.parse(r[2])
			end

			haml :schedule
		end

		post '/schedule' do
			Ayaneru.redis.rpush "tags", params[:tag]
			redirect '/schedule'
		end
	end
end
