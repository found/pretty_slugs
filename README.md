# PrettySlugs

![Slug Monster](http://www.horrordvds.com/reviews/n-z/slugs/slugs_shot3l.jpg)

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'pretty_slugs'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pretty_slugs

## Usage

to add the migration(s) to your app, run

    $ rails g pretty_slugs

then run

    $ rake db:migrate

To your models that need to implement pretty slugs, add this line:

    include PrettySlugs

And that is all you need if your model has a :name column, 
if you want to override the slug via a form field, then
you can create a field named :slug in the model's form



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
