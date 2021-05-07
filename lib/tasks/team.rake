namespace :team do
  desc "Update teams status: active => inactive"
  task:status_update => :environment do
    Team.update_status
  end
end