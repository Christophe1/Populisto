# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "log/cron_log.log"
set :environment, 'production'

# every :day, :at => '3:00 am' do
every 5.days, :at => '3:00 am' do
  runner "EmailInvitesReminder.perform()"
end

# Learn more: http://github.com/javan/whenever
