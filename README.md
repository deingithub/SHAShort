# shashort

SHAShort is the first and only URL shortening service to only use *cryptographically secure* hashing functions in the process of shortening, thereby making it *computationally infeasible* to reverse-engineer the original URL from the shortened link. That isn't something you should care about, but I did it anyway.

## Installation

Run `shards build --release`, create a database `shashort.sqlite3` with the table `CREATE TABLE urlmap (url string unique on conflict replace, hash string);
` adjust the port in `.env` if you want and run `bin/shashort`.

## Usage

Just navigate to <http://localhost:8001> (by default) to use.

## Contributing

1. Fork it (<https://github.com/your-github-user/shashort/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [deing](https://github.com/your-github-user) - creator and "maintainer"
