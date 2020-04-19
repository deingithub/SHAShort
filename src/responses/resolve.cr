require "../logic"

get "/resolve/:hash" do |env|
  hash = env.params.url["hash"]
  begin
    link = SHAShortLogic.fetch_link(hash)
    env.redirect link
  rescue e
    puts e
    env.response.status_code = 404
  end
end
