require 'json'

module Ayaneru
	class Niconico
		def search(tag, until_days)
      logout
			post_data = {}
			data_filters = Array.new
			data_filters[0] = {
				"field" => "ss_adult",
				"type" => "equal",
				"value" => false
			}
			data_filters[1] = {
				"field" => "live_status",
				"type" => "equal",
				"value" => "reserved"
			}
			data_filters[2] = {
				"field" => "provider_type",
				"type" => "equal",
				"value" => "official"
			}
			data_filters[3] = {
				"field" => "start_time",
				"from" => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
				"include_lower" => true,
				"include_upper" => true,
				"to" => Time.at(Time.now.to_i + until_days * 24 * 60 * 60).strftime("%Y-%m-%d %H:%M:%S"),
				"type" => "range"
			}
			data_filters[4] = {
				"field" => "timeshift_enabled",
				"type" => "equal",
				"value" => true
			}
			post_data["filters"] = data_filters
			post_data["from"] = 0
			post_data["issuer"] = "http://github.com/tsuwatch/autots"
			post_data["join"] = [
				"cmsid",
				"title",
				"description",
				"community_id",
				"open_time",
				"start_time",
				"live_end_time",
				#"view_counter",
				"comment_counter",
				"score_timeshift_reserved",
				"provider_type",
				"channel_id",
				"live_status",
				"tags",
				"member_only"
			]
			post_data["order"] = "desc"
			post_data["query"] = tag
			post_data["reason"] = "default"
			post_data["search"] = ["tags"]
			post_data["service"] = ["live"]
			post_data["size"] = 100
			post_data["sort_by"] = "_live_recent"
			post_data["timeout"] = 10000

			response = Ayaneru.niconico.agent.post(URL[:search], JSON.pretty_generate(post_data))
			response.body
		end
	end
end
