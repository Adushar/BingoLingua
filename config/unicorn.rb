# set path to application
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "/home/deployer/app/shared"
working_directory app_dir


# Set unicorn options
worker_processes 2
preload_app true
timeout 30

listen File.join(app_path, 'shared/unicorn.sock'), :backlog => 64
# Set up socket location
listen "#{shared_dir}/unicorn.sock", :backlog => 64

# Logging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set master PID location
pid "#{shared_dir}/unicorn.pid"
