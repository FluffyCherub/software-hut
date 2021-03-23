## Application deployment configuration
set :server,      'epi-stu-hut-demo3.shef.ac.uk'
set :user,        'demo.team22'
set :deploy_to,   -> { "/srv/services/#{fetch(:user)}" }
set :log_level,   :debug

## added below line due to an error: 'ruby stdout: Ruby ruby-2.6.6 is not installed.''
## https://vle.shef.ac.uk/ultra/courses/_90050_1/cl/outline?legacyUrl=%252Fwebapps%252Fblackboard%252Fexecute%252Fannouncement%3Fmethod%3Dsearch%26context%3Dmybb%26course_id%3D_90050_1%26individualAnnouncementId%3D_183481_1
## if the server is upgraded to 2.6.6, please remove the line below.
# set :rvm_ruby_version, 'ruby-2.6.2'




## Server configuration
server fetch(:server), user: fetch(:user), roles: %w{web app db}

## Additional tasks
namespace :deploy do
  task :seed do
    on primary :db do within current_path do with rails_env: fetch(:stage) do
      execute :rake, 'db:seed'
    end end end
  end
end