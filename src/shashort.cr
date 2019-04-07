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

require "./responses/api/web/create"
require "./responses/api/v0/create"
require "./responses/resolve"

get "/" do |env|
  send_file env, "public/index.html"
end

after_all do |env|
  env.response.headers.add("Content-Security-Policy", "default-src 'none'; img-src 'self'; script-src 'self'; style-src 'self'; connect-src 'self'")
  env.response.headers.add("Strict-Transport-Security", "max-age=63072000")
  env.response.headers.add("X-Frame-Options", "DENY")
end

Dotenv.load!
Kemal.run ENV["port"].to_i32
