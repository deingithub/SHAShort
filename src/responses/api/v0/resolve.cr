require "../../../logic"

get "/api/v0/resolve" do |env|
  env.response.content_type = "application/json"
  hash = env.request.body.not_nil!.gets_to_end
  begin
    url = SHAShortLogic.fetch_link(hash)
    next {status: "success", url: url}.to_json
  rescue e
		puts e
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
