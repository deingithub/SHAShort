require "../../../logic"

post "/api/v0/create" do |env|
  env.response.content_type = "application/json"
  url = env.request.body.not_nil!.gets_to_end
  begin
    hash = SHAShortLogic.create_link(url)
    next {status: "success", hash: hash}.to_json
  rescue e
    puts e
    env.response.status_code = 500
    next {status: "error"}.to_json
  end
end
