CarrierWave::Backgrounder.configure do |c|
  c.backend :delayed_job, queue: :delayed_job
  # c.backend :resque, queue: :carrierwave
  # c.backend :sidekiq, queue: :carrierwave
  # c.backend :girl_friday, queue: :carrierwave
  # c.backend :sucker_punch, queue: :carrierwave
  # c.backend :qu, queue: :carrierwave
  # c.backend :qc
end
