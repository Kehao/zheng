# Sqider

A simple spider to fetch data from 3rd party website for internal using.

## Installation

Add this line to your application's Gemfile:

    gem 'sqider'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sqider

## Usage
    Sqider::Court.where(:name => "...", :card_number => "...")
    Sqider::Idinfo.where(:key => "...", :type => :name)

    $ sqider-cli -h

    $ sqider-cli -p 项羽

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
