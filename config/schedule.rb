set :output, "/var/log/#{APP_NAME}_cron.log"

every 12.hours do
  runner "Concert.update_schedule"
end
