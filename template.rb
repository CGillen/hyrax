gem 'hyrax'
run 'bundle install'
generate 'hyrax:install', '-f'
rails_command 'db:migrate'
