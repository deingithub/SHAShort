require "../../../logic"

get "/api/v1/resolve" do |env|
  env.response.content_type = "application/json"
  hash = URI.decode(env.params.query["hash"])
  hash = hash.lchop("https://ding.15318.de/resolve/").strip
  begin
    url = SHAShortLogic.fetch_link(hash)
    next {status: "success", url: url}.to_json
  rescue e
		puts e.to_s
    next case e
    when SHAShortLogic::InvalidHashLengthError
      env.response.status_code = 400
      {status: "error"}.to_json
		when DB::Error
			env.response.status_code = 400
			{status: "error"}.to_json
		else
      env.response.status_code = 500
      {status: "error"}.to_json
    end
  end
end
