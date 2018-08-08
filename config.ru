# --- Start of unicorn worker killer code ---
if ENV['RAILS_ENV'] == 'production' 
  require 'unicorn/worker_killer'

  # Max requests per worker
  max_request_min =  500
  max_request_max =  600

  use Unicorn::WorkerKiller::MaxRequests, max_request_min, max_request_max

  # Max memory size (RSS) per worker
  oom_min = (240) * (1024**2)
  oom_max = (260) * (1024**2)
  use Unicorn::WorkerKiller::Oom, oom_min, oom_max
end

# --- End of unicorn worker killer code ---
require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
