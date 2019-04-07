DATABASE = DB.open "sqlite3://./shashort.sqlite3"
URLREGEX = Regex.new("^(https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]")

module SHAShortLogic
  extend self
  class TooLongError < Exception
    def to_s
      "Too Long"
    end
  end
  class NoURLError < Exception
    def to_s
      "Not An URL"
    end
  end
  class RateLimitError < Exception
    def to_s
      "Rate Limited"
    end
  end

  def create_link(url)
    raise TooLongError.new() if url.size >= 2000
    raise NoURLError.new() if URLREGEX.match(url).nil?
    raise RateLimitError.new() if SHAShort.ratelimited?
    SHAShort.ratelimit_set_now
    hash = Digest::SHA3.hexdigest(url)
    DATABASE.exec "insert into urlmap (url, hash) values (?,?)", url, hash
    hash
  end

  def fetch_link(hash)
    raise "Invalid Hash Length #{hash.size}" if hash.size != 128
    DATABASE.query_one "select url from urlmap where hash = ?", hash, as: String
  end
end
