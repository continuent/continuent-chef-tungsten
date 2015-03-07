source "https://rubygems.org"

gem 'berkshelf', '~> 3.2'

group :chef_development do
  # Automatically run Tests upon file change
  gem 'guard', '~> 2.11.0'
  gem 'guard-kitchen', :git => 'git://github.com/logankoester/guard-kitchen.git', :ref => 'af7a86afdc64d8d338d544993c84c5d4aef392df'
  gem 'guard-foodcritic', :git => 'git://github.com/Nordstrom/guard-foodcritic.git', :branch => 'use_guard_v2_api'
  gem 'guard-rspec', '~> 4.5.0'

  gem 'chefspec'
  gem 'test-kitchen', '~> 1.3.0'
  gem 'kitchen-vagrant'
  gem 'foodcritic'

  # Windows notifications
  gem 'rb-notifu'
  # OSX notifications
  gem 'terminal-notifier-guard'
end