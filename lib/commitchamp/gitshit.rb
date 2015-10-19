require "httparty"
require "pry"

require "commitchamp/version"
# Probably you also want to add a class for talking to github.

module Commitchamp
	class GitShit
		include HTTParty
		base_uri "https://api.github.com"

		def initialize(auth_token)
			      		@auth = {
			"Authorization" => "token #{auth_token}",
			"User-Agent" => "HTTParty"
		} 
		end

		def get_repo(owner,repo)
			self.class.get("/repos/#{owner}/#{repo}", :headers => @auth)

		end

		#GET /repos/:owner/:repo/stats/contributors
		def get_contributors(owner,repo)
			self.class.get("/repos/#{owner}/#{repo}/stats/contributors", :headers => @auth)

		end

		def build_user_table(response)
			#binding.pry
			@users = Array.new
			@data_item = Hash.new

			i = 0
			while i < response.count()
				adds = 0
				dels = 0
				chng = 0
				user = response[i]["author"]["login"]
				x = 0
				while x < response[i]["weeks"].count()
					adds += response[i]["weeks"][x]["a"]
					dels += response[i]["weeks"][x]["d"]
					chng += response[i]["weeks"][x]["c"]
				x += 1
				end
				i += 1
				@data_item = {"user" => user, "adds" => adds, "dels" => dels, "chng" => chng}
				@users.push(@data_item)
			end
		end

		def show_table
			puts @users
		end
	end
end