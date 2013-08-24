gem_group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'
  gem 'pry-coolline'
  gem 'pry-debugger'
  gem 'hirb'
  gem 'hirb-unicode'
end

gem_group :default do
  gem 'settingslogic'
  gem 'haml'
  gem 'haml-rails'
end

# ---------------------------------------------------------------------------
# Haml setup
# ---------------------------------------------------------------------------
remove_file 'app/views/layouts/application.html.erb'
run "curl 'https://raw.github.com/akira-hamada/rails_template/master/application.html.haml' -o app/views/layouts/application.html.haml"
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# DB setup
# ---------------------------------------------------------------------------
create_file "config/database.yml", force: true do
"setup: &setup
  adapter: #{options[:database]}
  username: #{app_name}
  password: #{app_name}
  encoding: utf8
  reconnect: false
  pool: 5
  socket: /tmp/mysql.sock

development:
  <<: *setup
  database: #{options[:database] =~ /sqlite3/ ? "db/development.sqlite3" : "#{app_name}_development"}

test:
  <<: *setup
  database: #{options[:database] =~ /sqlite3/ ? "db/test.sqlite3" : "#{app_name}_test"}

staging:
  <<: *setup
  database: #{options[:database] =~ /sqlite3/ ? "db/staging.sqlite3" : "#{app_name}_staging"}

production:
  <<: *setup
  database: #{options[:database] =~ /sqlite3/ ? "db/production.sqlite3" : "#{app_name}_production"}"
end
# ---------------------------------------------------------------------------

run_bundle

git :init
git add: '.'
git commit: "-m 'initial commit'"

generate 'rspec:install'

git add: '.'
git commit: "-m 'rspec install'"

remove_file "public/index.html"

git rm: './public/index.html'
git commit: "-m 'remove default index.html'"
