server 'mindbot.ru', user: 'deploy', roles: %w{web app db}

set :rbenv_type, :user
set :rbenv_ruby, '2.1.0'
set :branch, :master