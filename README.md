# shashort

SHAShort is the first and only URL shortening service to only use *cryptographically secure* hashing functions in the process of shortening, thereby making it *computationally infeasible* to reverse-engineer the original URL from the shortened link. That isn't something you should care about, but I did it anyway.

## Installation

Run `shards build --release`, create a database `shashort.sqlite3` with the table `CREATE TABLE urlmap (url string unique on conflict replace, hash string);
` adjust the port in `.env` if you want and run `bin/shashort`.

## Usage

Just navigate to <http://localhost:8001> (by default) to use.

## Contributing

The main codebase is located on https://git.15318.de. You can log in using GitLab or GitHub there.

1. Fork it (<https://git.15318.de/deing/SHAShort/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [deing](https://git.15318.de/deing) - creator and "maintainer"
