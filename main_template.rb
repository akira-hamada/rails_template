gem_group :default do
  gem 'settingslogic'
  gem 'haml'
  gem 'haml-rails'
  gem 'simple_form'
end

gem_group :development do
  gem 'activerecord-mysql-adapter'
end

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

# ---------------------------------------------------------------------------
# Remove Default Files
# ---------------------------------------------------------------------------
remove_file "public/index.html"
remove_file "favicon.ico"
# ---------------------------------------------------------------------------

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
  adapter: #{options[:database] =~ /mysql/ ? "mysql2" : options[:database]}
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

run "powder link #{app_name}"

if yes?("You need Twitter Bootstrap?")
  gem 'twitter-bootstrap-rails'
  generate "bootstrap:install"
  generate "bootstrap:layout -f application fluid"

  with_bootstrap = ' --bootstrap'
else
  with_bootstrap = ''
end

generate "simple_form:install#{with_bootstrap}"

git :init
git add: '.'
git commit: "-m 'initial commit'"

generate 'rspec:install'

git add: '.'
git commit: "-m 'install rspec'"

if yes?("You need Devise?")
  gem "devise"
  generate "devise:install"
  model_name = ask("What would you like the user model to be called? [user]")
  model_name = "user" if model_name.blank?
  generate "devise", model_name

  git add: '.'
  git commit: "-m 'install Devise'"
end

puts '--------------------------------------------------'
puts 'You NEED ACTIVATE pow, Execute the Following Code'
puts '  $ cd ~/.pow'
puts "  $ ln -s ~/rails_projects/#{app_name}"
puts '--------------------------------------------------'

puts '--------------------------------------------------'
puts 'if You need admin namespace, do the Following Code'
puts "  $ rails g controller 'admin/home'"
puts '--------------------------------------------------'
