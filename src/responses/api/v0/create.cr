require "../../../logic"

post "/api/v0/create" do |env|
  env.response.content_type = "application/json"
  url = env.request.body.not_nil!.gets_to_end
  begin
    hash = SHAShortLogic.create_link(url)
    next {status: "success", hash: hash}.to_json
  rescue e
    next case e
    when SHAShortLogic::RateLimitError
      env.response.status_code = 429
      {status: "error"}.to_json
    when SHAShortLogic::NoURLError
      env.response.status_code = 400
      {status: "error"}.to_json
    when SHAShortLogic::TooLongError
      env.response.status_code = 413
      {status: "error"}.to_json
    else
      env.response.status_code = 500
      {status: "error"}.to_json
    end
  end
end
