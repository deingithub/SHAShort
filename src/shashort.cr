require "kemal"
require "db"
require "sqlite3"
require "sha3"
require "dotenv"

module SHAShort
  extend self
  @@last_hash_time = Time.unix(0)
  RATELIMIT = Time::Span.new(0, 0, 1)
  def ratelimited?
    Time.now - @@last_hash_time < RATELIMIT
  end
  def ratelimit_set_now
    @@last_hash_time = Time.now
  end
end

post "/api/v0/create" do |env|
  handle_create(env.request.body.not_nil!.gets_to_end, env)
end

post "/api/web/create" do |env|
  handle_create(env.params.body["url"], env)
end

get "/" do |env|
  send_file env, "public/index.html"
end

get "/resolve/:hash" do |env|
  hash = env.params.url["hash"]
  begin
    link = fetch_link(hash)
    env.redirect link
  rescue e
    puts e
    env.response.status_code = 404
  end
end

def handle_create(url, env)
  env.response.content_type = "application/json"
  if SHAShort.ratelimited?
    env.response.status_code = 400
    puts "Rate limited"
    return {status: "error"}.to_json
  end
  if url.size > 2000
    env.response.status_code = 413
    puts "Payload size #{url.size} too large"
    return {status: "error"}.to_json
  end
  begin
    SHAShort.ratelimit_set_now
    hash = create_link(url)
    return {status: "success", hash: hash}.to_json
  rescue e
    puts e
    env.response.status_code = 500
    return {status: "error"}.to_json
  end
end

def create_link(url)
  raise "Too long, sorry" if url.size >= 2000
  raise "Invalid URL #{url}" if URLREGEX.match(url).nil?
  hash = Digest::SHA3.hexdigest(url)
  DATABASE.exec "insert into urlmap (url, hash) values (?,?)", url, hash
  hash
end

def fetch_link(hash)
  raise "Invalid Hash Length #{hash.size}" if hash.size != 128
  DATABASE.query_one "select url from urlmap where hash = ?", hash, as: String
end

DATABASE = DB.open "sqlite3://./shashort.sqlite3"
URLREGEX = Regex.new("^(https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]")

after_all do |env|
  env.response.headers.add("Content-Security-Policy", "default-src 'none'; img-src 'self'; script-src 'self'; style-src 'self'")
  env.response.headers.add("Strict-Transport-Security", "max-age=63072000")
  env.response.headers.add("X-Frame-Options", "DENY")
end

Dotenv.load!
Kemal.run ENV["port"].to_i32
