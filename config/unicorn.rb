rails_env = ENV['RAILS_ENV'] || 'production'
rails_root = ENV['RAILS_ROOT'] ||  File.expand_path('../..', __FILE__)
 
work_dir = rails_root

worker_processes 6
working_directory work_dir 

# This loads the application in the master process before forking
# worker processes
# Read more about it here:
# http://unicorn.bogomips.org/Unicorn/Configurator.html
preload_app true

timeout 60

# This is where we specify the socket.
# We will point the upstream Nginx module to this socket later on
listen "#{work_dir}/tmp/sockets/unicorn.sock", :backlog => 64
listen 3000, :tcp_nopush => true

pid "#{work_dir}/tmp/pids/unicorn.pid"

# Set the path of the log files inside the log folder of the testapp
stderr_path "#{work_dir}/log/unicorn.stderr.log"
stdout_path "#{work_dir}/log/unicorn.stdout.log"

before_fork do |server, worker|
# This option works in together with preload_app true setting
# What is does is prevent the master process from holding
# the database connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
    
  # This allows a new master process to incrementally
  # phase out the old master process with SIGTTOU to avoid a
  # thundering herd (especially in the "preload_app false" case)
  # when doing a transparent upgrade.  The last worker spawned
  # will then kill off the old master process with a SIGQUIT.
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      STDERR.puts "kill old unicorn failed!"
    end
  end

end

after_fork do |server, worker|
# Here we are establishing the connection after forking worker
# processes
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
