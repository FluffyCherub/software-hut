# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user1 = User.create(givenname: 'Dominik', sn: 'Laszczyk', username: 'aca19dl', email: 'dlaszczyk1@sheffield.ac.uk', password:'1234', password_confirmation: '1234', admin: true)
user2 = User.create(givenname: 'Anton', sn: 'Minkov', username: 'acc19am', email: 'aminkov1@sheffield.ac.uk', password:'1234', password_confirmation: '1234', admin: true)
user3 = User.create(givenname: 'Laney', sn: 'Deveson', username: 'eia17ld', email: 'aminkov1@sheffield.ac.uk', password:'1234', password_confirmation: '1234', admin: true)
user4 = User.create(givenname: 'Ling', sn: 'Lai', username: 'aca18ll', email: 'aminkov1@sheffield.ac.uk', password:'1234', password_confirmation: '1234', admin: true)
user5 = User.create(givenname: 'Seth', sn: 'Roberts', username: 'eib18sr', email: 'aminkov1@sheffield.ac.uk', password:'1234', password_confirmation: '1234', admin: true)
user6 = User.create(givenname: 'Zijian', sn: 'He', username: 'aca19zh', email: 'aminkov1@sheffield.ac.uk', password:'1234', password_confirmation: '1234', admin: true)

NUM_OF_TEST_USERS = 78

#creating test_users
test_users = []
for i in 1..NUM_OF_TEST_USERS
  new_test_givenname = "Test"
  new_test_sn = "User" + i.to_s
  new_test_username = "test_user" + i.to_s
  new_test_email = new_test_username + "@sheffield.ac.uk"

  new_test_user = User.create(givenname: new_test_givenname, sn: new_test_sn, username: new_test_username, email: new_test_email, password:'1234', password_confirmation: '1234')

  test_users.append(new_test_user)
end

#module leader and ta's for software hut
mod_lead_soft = User.create(givenname: "Test", sn: "User123", username: "test_user123", email: "test_user123@sheffield.ac.uk", password:'1234', password_confirmation: '1234')
ta_1_soft = User.create(givenname: "Test", sn: "User425", username: "test_user425", email: "test_user425@sheffield.ac.uk", password:'1234', password_confirmation: '1234')
ta_2_soft = User.create(givenname: "Test", sn: "User426", username: "test_user426", email: "test_user426@sheffield.ac.uk", password:'1234', password_confirmation: '1234')
ta_3_soft = User.create(givenname: "Test", sn: "User427", username: "test_user427", email: "test_user427@sheffield.ac.uk", password:'1234', password_confirmation: '1234')

modules = ListModule.create([
  {name: 'Software Hut', code: 'COM3420', description: 'The Software Hut (a microcosm of a real Software House) gives students an opportunity to experience the processes of engineering a real software system for a real client in a competitive environment. The taught element covers the tools and technologies needed to manage software development projects successfully and to deliver software products that meet both client expectations and quality standards. Topics that are put into practice include: the requirements engineering process; software modelling and testing; using specific software development framework(s); group project management etc. Tutorials take the form of project meetings, and so are concerned with team management, conduct of meetings and action minutes.', created_by: 'aca19dl', semester: 'SPRING', years: '2020/2021', level: '5'},
  {name: 'Robotics', code: 'COM2009', description: 'Robots go brr', created_by: 'aca19dl', semester: 'SPRING', years: '2020/2021', level: '4'},
  {name: 'Automata, Computation and Complexity', code: 'COM2109', description: 'Connect circles with lines', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2020/2021', level: '5'},
  {name: 'Functional Programming', code: 'COM2108', description: 'Worse programming', created_by: 'aca19dl', semester: 'AUTUMN', years: '2020/2021', level: '4'},
  {name: 'Data Driven Computing', code: 'COM2004', description: 'poopoo', created_by: 'aca19dl', semester: 'AUTUMN', years: '2020/2021', level: '6'},

  {name: 'Java Programming', code: 'COM1003', description: 'java stuff', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2019/2020', level: '5'},
  {name: 'Machines and Intelligence', code: 'COM1005', description: 'Miro', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2019/2020', level: '4'},
  {name: 'Devices and Networks', code: 'COM1006', description: 'l;ksdjfbhnv', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2019/2020', level: '7'},
  {name: 'Web and Internet Technology', code: 'COM1008', description: 'html', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2019/2020', level: '4'},
  {name: 'Foundations of Computer Science', code: 'COM1002', description: 'mafs', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2019/2020', level: '6'},

  {name: 'Test Module 1', code: 'COM3003', description: 'Test description 1', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2021/2022', level: '7'},
  {name: 'Test Module 2', code: 'COM3005', description: 'Test description 2', created_by: 'aca19dl', semester: 'AUTUMN', years: '2021/2022', level: '6'},
  {name: 'Test Module 3', code: 'COM3006', description: 'Test description 3', created_by: 'aca19dl', semester: 'SPRING', years: '2021/2022', level: '5'}
  
])

#adding real people to software hut
UserListModule.create(list_module: modules[0], user: user1, privilege: 'student')
UserListModule.create(list_module: modules[0], user: user2, privilege: 'student')

#adding mod lead and ta's to soft hut
UserListModule.create(list_module: modules[0], user: mod_lead_soft, privilege: 'module_leader')
UserListModule.create(list_module: modules[0], user: ta_1_soft, privilege: 'teaching_assistant')
UserListModule.create(list_module: modules[0], user: ta_2_soft, privilege: 'teaching_assistant')
UserListModule.create(list_module: modules[0], user: ta_3_soft, privilege: 'teaching_assistant')

#adding real people to robotics
UserListModule.create(list_module: modules[1], user: user1, privilege: 'student')
UserListModule.create(list_module: modules[1], user: user2, privilege: 'student')

#adding mod lead and ta's to automata
UserListModule.create(list_module: modules[2], user: mod_lead_soft, privilege: 'module_leader')
UserListModule.create(list_module: modules[2], user: ta_1_soft, privilege: 'teaching_assistant')
UserListModule.create(list_module: modules[2], user: ta_2_soft, privilege: 'teaching_assistant')
UserListModule.create(list_module: modules[2], user: ta_3_soft, privilege: 'teaching_assistant')


#putting test_users in software hut
for i in 0...NUM_OF_TEST_USERS
  UserListModule.create(list_module: modules[0], user: test_users[i], privilege: 'student')
end

#putting test_users in robotics
for i in 0...NUM_OF_TEST_USERS
  UserListModule.create(list_module: modules[1], user: test_users[i], privilege: 'student')
end


TEAM_SIZE = 5
NUM_OF_TEAMS = 16

#creating teams in software hut
shuffled_test_users_soft = test_users.shuffle
shuffled_test_users_soft.append(user1)
shuffled_test_users_soft.append(user2)

test_teams_soft = []

for j in 1..NUM_OF_TEAMS 
  new_team_name = "Team " + j.to_s
  new_team_topic = "none"
  new_team = Team.create(name: new_team_name, topic: new_team_topic, size: TEAM_SIZE, list_module: modules[0])
  test_teams_soft.append(new_team)
  for i in 0...TEAM_SIZE
    UserTeam.create(team: new_team, user: shuffled_test_users_soft[0], signed_agreement: false)
    shuffled_test_users_soft.shift(1)
  end
end

#creating teams in robotics
shuffled_test_users_robot = test_users.shuffle
shuffled_test_users_robot.append(user1)
shuffled_test_users_robot.append(user2)

test_teams_robot = []

for j in 1..NUM_OF_TEAMS 
  new_team_name = "Team " + j.to_s
  new_team_topic = "none"
  new_team = Team.create(name: new_team_name, topic: new_team_topic, size: TEAM_SIZE, list_module: modules[1])
  test_teams_robot.append(new_team)
  for i in 0...TEAM_SIZE
    UserTeam.create(team: new_team, user: shuffled_test_users_robot[0], signed_agreement: false)
    shuffled_test_users_robot.shift(1)
  end
end



#creating the feedback period for software hut
start_date_soft = DateTime.new(2020,2,3,4,5,6)
end_date_soft = DateTime.new(2020,2,10,4,5,6)
feedback_period_soft = FeedbackDate.create(start_date: start_date_soft, end_date: end_date_soft, list_module: modules[0])


#creating the feedback period for robotics
start_date_robot = DateTime.new(2021,4,25,10,0,0)
end_date_robot = DateTime.new(2021,5,3,10,0,0)
feedback_period_robot = FeedbackDate.create(start_date: start_date_robot, end_date: end_date_robot, list_module: modules[1])


#connecting teams in software hut to feedback periods
for i in 0...(test_teams_soft.length)
  TeamFeedbackDate.create(feedback_date_id: feedback_period_soft.id, team_id: test_teams_soft[i].id)
end

#connecting teams in robotics to feedback periods
for i in 0...(test_teams_robot.length)
  TeamFeedbackDate.create(feedback_date_id: feedback_period_robot.id, team_id: test_teams_robot[i].id)
end



appreciate_messages = ["He is a very good teammate.",
                      "Helpful at all times and completes his work on time." ,
                      "Never late for meetings." ,
                      "Good team leader.",
                      "Does a good job of working in a team.",
                      "Proposes good ideas.",
                      "Takes care of other team members.",
                      "Very polite person.",
                      "Doesn't hesitate to offer his help.",
                      "Takes up on a lot of responsabilities.",
                      "Never slacks off.",
                      "Completes tasks assigned to him.",
                      "Good public speaker.",
                      "Good coder.",
                      "Intervines when there are issues in the team.",
                      "Very punctual. ",
                      "Awesome management skills.",
                      "Good peron to be in charge.",
                      "Very considerate.",
                      "Really helpful.",
                      "Always on time.",
                      "Delivers whats expected of him.",
                      "Good communicator."]


request_messages = ["Late for meetings.",
                    "Doesn't do his assigned tasks.",
                    "Doesn't attend facilitator meetings.",
                    "Rude to other team members. ",
                    "Doesn't work well in a team. Shouts during meetings.",
                    "Doesn't let other people speak. ",
                    "Doesn't want to take on any responsability.",
                    "Complains most of the time while doing no work. ",
                    "Doesn't listen to other team members.",
                    "Submits code without consulting with other team members. ",
                    "No proper manners.",
                    "Doesn't want to do any work. ",
                    "Doesn't participate in team activities. ",
                    "Can't be reached.",
                    "Extremelly negative attitude. ",
                    "Shouts constantly. ",
                    "Doesn't want to help with the project.",
                    "Is being harmful to the project.",
                    "Doesn't speak to team members.",
                    "Threatens other team members.",
                    "Only cares about himself.",
                    "Bad at teamwork.",
                    "Refuses to help other team members when they are in need."]

dumb_var = "He is dumb"


#adding peer feedback for software hut
for i in 0...test_teams_soft.length

  team_members = User.joins(:teams).where("teams.id = ?", test_teams_soft[i].id)
 
  for j in 0...team_members.length
    for z in 0...team_members.length
      if j != z && rand(2) == 0
        rand_attendace = rand(4) + 1
        rand_attitude = rand(4) + 1
        rand_collaboration = rand(4) + 1
        rand_communication = rand(4) + 1
        rand_ethics = rand(4) + 1
        rand_leadership = rand(4) + 1
        rand_qac = rand(4) + 1

        aprreciate_random = appreciate_messages.shuffle.take(rand(1..appreciate_messages.length))
        request_random = request_messages.shuffle.sample(rand(1..request_messages.length))

        if rand(1..25) == 10
          request_random.append(dumb_var)
        end

        PeerFeedback.create(feedback_date: feedback_period_soft,
                            attendance: rand_attendace,  
                            attitude: rand_attitude,    
                            collaboration: rand_collaboration,
                            communication: rand_communication,
                            ethics: rand_ethics,   
                            leadership: rand_leadership,
                            qac: rand_qac,
                            appreciate: aprreciate_random,
                            request: request_random,
                            appreciate_edited: aprreciate_random.join(" "),
                            request_edited: request_random.join(" "),
                            created_by: team_members[j].username,
                            created_for: team_members[z].username)
      end
    end
  end

end


