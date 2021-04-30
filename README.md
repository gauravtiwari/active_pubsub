# ActivePubsub

Simple pub-sub message bus for Rails built on top of ActiveSupportNotifications

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_pubsub_rails'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install active_pubsub_rails

## Usage

Create a subscriber that listens to events:

```rb
# Create your subscriber under app/subscribers
# app/subscribers/account_subscriber.rb

module AccountSubscriber
  include ActivePubsubRails::Subscriber

  event_action :account_opened
  event_action :account_verified
  event_action :account_deleted, event_name: :account_removed

  def account_opened(event)
    # Do something here
  end

  def account_verified(event)
    # Do something here
  end

  def account_deleted(event)
    # Do something here
  end
end
```

And, publish events like so

```rb
ActivePubsubRails.fire 'account_opened', account_id: 1
# => <ActiveSupport::Notifications::Event:0x00007fec80755d90 @name="account_opened", @payload={:account_id=>1}, @time=2021-04-30 13:44:23.997487 +0100, @transaction_id="ff2eeaa4cfa39993eef1", @end=2021-04-30 13:44:23.997494 +0100, @children=[], @cpu_time_start=0, @cpu_time_finish=0, @allocation_count_start=0, @allocation_count_finish=0>

ActivePubsubRails.fire 'account_verified', account_id: 1, verfied: true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gauravtiwari/active_pubsub_rails.

```

```

```

```
