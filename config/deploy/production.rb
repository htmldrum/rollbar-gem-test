hosts = ['localhost']
role :web, hosts
role :app, hosts
role :worker, hosts
role :db, hosts

set :ssh_options, { forward_agent: true }
