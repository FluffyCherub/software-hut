# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user1 = User.find_or_create_by(givenname: 'Dominik', sn: 'Laszczyk', username: 'aca19dl', email: 'dlaszczyk1@sheffield.ac.uk', admin: true)
user2 = User.find_or_create_by(givenname: 'Anton', sn: 'Minkov', username: 'acc19am', email: 'aminkov1@sheffield.ac.uk', admin: true)
user3 = User.find_or_create_by(givenname: 'Laney', sn: 'Deveson', username: 'eia17ld', email: 'aminkov1@sheffield.ac.uk', admin: true)
user4 = User.find_or_create_by(givenname: 'Ling', sn: 'Lai', username: 'aca18ll', email: 'aminkov1@sheffield.ac.uk', admin: true)
user5 = User.find_or_create_by(givenname: 'Seth', sn: 'Roberts', username: 'eib18sr', email: 'aminkov1@sheffield.ac.uk', admin: true)
user6 = User.find_or_create_by(givenname: 'Zijian', sn: 'He', username: 'aca19zh', email: 'aminkov1@sheffield.ac.uk', admin: true)
user7 = User.find_or_create_by(givenname: 'Gary', sn: 'Wood', username: 'me1gcw', email: 'g.c.wood@sheffield.ac.uk', admin: true)

NUM_OF_TEST_USERS = 77

#creating test_users
test_users = []
for i in 1..NUM_OF_TEST_USERS
  new_test_givenname = "Test"
  new_test_sn = "User" + i.to_s
  new_test_username = "test_user" + i.to_s
  new_test_email = new_test_username + "@sheffield.ac.uk"

  new_test_user = User.create(givenname: new_test_givenname, sn: new_test_sn, username: new_test_username, email: new_test_email)

  test_users.append(new_test_user)
end

#module leader and ta's for software hut
mod_lead_soft = User.create(givenname: "Test", sn: "User123", username: "test_user123", email: "test_user123@sheffield.ac.uk")
ta_1_soft = User.create(givenname: "Test", sn: "User425", username: "test_user425", email: "test_user425@sheffield.ac.uk")
ta_2_soft = User.create(givenname: "Test", sn: "User426", username: "test_user426", email: "test_user426@sheffield.ac.uk")
ta_3_soft = User.create(givenname: "Test", sn: "User427", username: "test_user427", email: "test_user427@sheffield.ac.uk")

modules = ListModule.create([
  {name: 'Software Hut', code: 'COM3420', description: 'The Software Hut (a microcosm of a real Software House) gives students an opportunity to experience the processes of engineering a real software system for a real client in a competitive environment. The taught element covers the tools and technologies needed to manage software development projects successfully and to deliver software products that meet both client expectations and quality standards. Topics that are put into practice include: the requirements engineering process; software modelling and testing; using specific software development framework(s); group project management etc. Tutorials take the form of project meetings, and so are concerned with team management, conduct of meetings and action minutes.', created_by: 'aca19dl', semester: 'SPRING', years: '2020/2021', level: '5'},
  {name: 'Robotics', code: 'COM2009', description: 'Robots go brr', created_by: 'aca19dl', semester: 'SPRING', years: '2019/2020', level: '4'},
  {name: 'Automata, Computation and Complexity', code: 'COM2109', description: 'Connect circles with lines', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2018/2019', level: '5'},
  {name: 'Functional Programming', code: 'COM2108', description: 'Worse programming', created_by: 'aca19dl', semester: 'AUTUMN', years: '2017/2018', level: '4'},
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
UserListModule.create(list_module: modules[0], user: user1, privilege: 'teaching_assistant_16')
UserListModule.create(list_module: modules[0], user: user2, privilege: 'student')
UserListModule.create(list_module: modules[0], user: user7, privilege: 'module_leader')

#adding mod lead and ta's to soft hut
UserListModule.create(list_module: modules[0], user: ta_1_soft, privilege: 'teaching_assistant')
UserListModule.create(list_module: modules[0], user: ta_2_soft, privilege: 'teaching_assistant')
UserListModule.create(list_module: modules[0], user: ta_3_soft, privilege: 'teaching_assistant')

#adding real people to robotics
UserListModule.create(list_module: modules[1], user: user1, privilege: 'student')
UserListModule.create(list_module: modules[1], user: user2, privilege: 'student')
UserListModule.create(list_module: modules[1], user: user7, privilege: 'module_leader')

#adding real people to automata
UserListModule.create(list_module: modules[2], user: user1, privilege: 'student')
UserListModule.create(list_module: modules[2], user: user2, privilege: 'student')
UserListModule.create(list_module: modules[2], user: user7, privilege: 'module_leader')

#adding mod lead and ta's to automata
UserListModule.create(list_module: modules[2], user: ta_1_soft, privilege: 'teaching_assistant')
UserListModule.create(list_module: modules[2], user: ta_2_soft, privilege: 'teaching_assistant')
UserListModule.create(list_module: modules[2], user: ta_3_soft, privilege: 'teaching_assistant')

#adding real people to functional
UserListModule.create(list_module: modules[3], user: user1, privilege: 'student')
UserListModule.create(list_module: modules[3], user: user2, privilege: 'student')
UserListModule.create(list_module: modules[3], user: user7, privilege: 'module_leader')


#putting test_users in software hut
for i in 0...NUM_OF_TEST_USERS
  UserListModule.create(list_module: modules[0], user: test_users[i], privilege: 'student')
end

#putting test_users in robotics
for i in 0...NUM_OF_TEST_USERS
  UserListModule.create(list_module: modules[1], user: test_users[i], privilege: 'student')
end

#putting test_users in automata
for i in 0...NUM_OF_TEST_USERS
  UserListModule.create(list_module: modules[2], user: test_users[i], privilege: 'student')
end

#putting test_users in functional
for i in 0...NUM_OF_TEST_USERS
  UserListModule.create(list_module: modules[3], user: test_users[i], privilege: 'student')
end


TEAM_SIZE = 5
NUM_OF_TEAMS = 16

#FILE = File.open('app/assets/docs/toa.pdf')

#creating teams in software hut
shuffled_test_users_soft = test_users.shuffle
shuffled_test_users_soft.append(user1)
shuffled_test_users_soft.append(user2)
shuffled_test_users_soft.append(user7)

test_teams_soft = []

for j in 1..NUM_OF_TEAMS 
  new_team_name = "Team " + j.to_s
  new_team_topic = "none"
  new_team = Team.create(name: new_team_name, topic: new_team_topic, size: TEAM_SIZE, list_module: modules[0])
  test_teams_soft.append(new_team)

  #attaching toa to new team
  #new_team.document.attach(io: FILE, filename: 'toa.pdf')

  for i in 0...TEAM_SIZE
    UserTeam.create(team: new_team, user: shuffled_test_users_soft[0], signed_agreement: false)
    shuffled_test_users_soft.shift(1)
  end
end

#creating teams in robotics
shuffled_test_users_robot = test_users.shuffle
shuffled_test_users_robot.append(user1)
shuffled_test_users_robot.append(user2)
shuffled_test_users_robot.append(user7)

test_teams_robot = []

for j in 1..NUM_OF_TEAMS 
  new_team_name = "Team " + j.to_s
  new_team_topic = "none"
  new_team = Team.create(name: new_team_name, topic: new_team_topic, size: TEAM_SIZE, list_module: modules[1], status: "active")
  test_teams_robot.append(new_team)

  #attaching toa to new team
  #new_team.document.attach(io: FILE, filename: 'toa.pdf')

  for i in 0...TEAM_SIZE
    UserTeam.create(team: new_team, user: shuffled_test_users_robot[0], signed_agreement: false)
    shuffled_test_users_robot.shift(1)
  end
end

#creating teams in automata
shuffled_test_users_automata = test_users.shuffle
shuffled_test_users_automata.append(user1)
shuffled_test_users_automata.append(user2)
shuffled_test_users_automata.append(user7)

test_teams_automata = []

for j in 1..NUM_OF_TEAMS 
  new_team_name = "Team " + j.to_s
  new_team_topic = "none"
  new_team = Team.create(name: new_team_name, topic: new_team_topic, size: TEAM_SIZE, list_module: modules[2], status: "active")
  test_teams_automata.append(new_team)

  #attaching toa to new team
  #new_team.document.attach(io: FILE, filename: 'toa.pdf')

  for i in 0...TEAM_SIZE
    UserTeam.create(team: new_team, user: shuffled_test_users_automata[0], signed_agreement: false)
    shuffled_test_users_automata.shift(1)
  end
end

#creating teams in functional
shuffled_test_users_functional = test_users.shuffle
shuffled_test_users_functional.append(user1)
shuffled_test_users_functional.append(user2)
shuffled_test_users_functional.append(user7)

test_teams_functional = []

for j in 1..NUM_OF_TEAMS 
  new_team_name = "Team " + j.to_s
  new_team_topic = "none"
  new_team = Team.create(name: new_team_name, topic: new_team_topic, size: TEAM_SIZE, list_module: modules[3], status: "active")
  test_teams_functional.append(new_team)

  #attaching toa to new team
  #new_team.document.attach(io: FILE, filename: 'toa.pdf')

  for i in 0...TEAM_SIZE
    UserTeam.create(team: new_team, user: shuffled_test_users_functional[0], signed_agreement: false)
    shuffled_test_users_functional.shift(1)
  end
end


#creating the feedback periods for robotics
feedback_periods_robots = []
feedback_periods_robots.append(FeedbackDate.create(start_date: DateTime.new(2021,4,25,10,0,0), end_date: DateTime.new(2022,5,3,10,0,0), list_module: modules[1]))
feedback_periods_robots.append(FeedbackDate.create(start_date: DateTime.new(2005,4,25,10,0,0), end_date: DateTime.new(2006,5,3,10,0,0), list_module: modules[1]))
feedback_periods_robots.append(FeedbackDate.create(start_date: DateTime.new(2007,4,25,10,0,0), end_date: DateTime.new(2008,5,3,10,0,0), list_module: modules[1]))
feedback_periods_robots.append(FeedbackDate.create(start_date: DateTime.new(2009,4,25,10,0,0), end_date: DateTime.new(2010,5,3,10,0,0), list_module: modules[1]))
feedback_periods_robots.append(FeedbackDate.create(start_date: DateTime.new(2011,4,25,10,0,0), end_date: DateTime.new(2012,5,3,10,0,0), list_module: modules[1]))
feedback_periods_robots.append(FeedbackDate.create(start_date: DateTime.new(2013,4,25,10,0,0), end_date: DateTime.new(2014,5,3,10,0,0), list_module: modules[1]))


#creating the feedback period for software hut
feedback_periods_soft = []
feedback_periods_soft.append(FeedbackDate.create(start_date: DateTime.new(2003,4,25,10,0,0), end_date: DateTime.new(2004,5,3,10,0,0), list_module: modules[0]))
feedback_periods_soft.append(FeedbackDate.create(start_date: DateTime.new(2005,4,25,10,0,0), end_date: DateTime.new(2006,5,3,10,0,0), list_module: modules[0]))
feedback_periods_soft.append(FeedbackDate.create(start_date: DateTime.new(2007,4,25,10,0,0), end_date: DateTime.new(2008,5,3,10,0,0), list_module: modules[0]))
feedback_periods_soft.append(FeedbackDate.create(start_date: DateTime.new(2009,4,25,10,0,0), end_date: DateTime.new(2010,5,3,10,0,0), list_module: modules[0]))
feedback_periods_soft.append(FeedbackDate.create(start_date: DateTime.new(2011,4,25,10,0,0), end_date: DateTime.new(2012,5,3,10,0,0), list_module: modules[0]))
feedback_periods_soft.append(FeedbackDate.create(start_date: DateTime.new(2013,4,25,10,0,0), end_date: DateTime.new(2014,5,3,10,0,0), list_module: modules[0]))
feedback_periods_soft.append(FeedbackDate.create(start_date: DateTime.new(2015,4,25,10,0,0), end_date: DateTime.new(2016,5,3,10,0,0), list_module: modules[0]))
feedback_periods_soft.append(FeedbackDate.create(start_date: DateTime.new(2017,4,25,10,0,0), end_date: DateTime.new(2018,5,3,10,0,0), list_module: modules[0]))


#creating the feedback periods for automata
feedback_periods_automata = []
feedback_periods_automata.append(FeedbackDate.create(start_date: DateTime.new(1995,4,25,10,0,0), end_date: DateTime.new(1996,5,3,10,0,0), list_module: modules[2]))
feedback_periods_automata.append(FeedbackDate.create(start_date: DateTime.new(1997,4,25,10,0,0), end_date: DateTime.new(1998,5,3,10,0,0), list_module: modules[2]))
feedback_periods_automata.append(FeedbackDate.create(start_date: DateTime.new(1999,4,25,10,0,0), end_date: DateTime.new(2000,5,3,10,0,0), list_module: modules[2]))
feedback_periods_automata.append(FeedbackDate.create(start_date: DateTime.new(2001,4,25,10,0,0), end_date: DateTime.new(2002,5,3,10,0,0), list_module: modules[2]))
feedback_periods_automata.append(FeedbackDate.create(start_date: DateTime.new(2003,4,25,10,0,0), end_date: DateTime.new(2004,5,3,10,0,0), list_module: modules[2]))
feedback_periods_automata.append(FeedbackDate.create(start_date: DateTime.new(2005,4,25,10,0,0), end_date: DateTime.new(2006,5,3,10,0,0), list_module: modules[2]))
feedback_periods_automata.append(FeedbackDate.create(start_date: DateTime.new(2007,4,25,10,0,0), end_date: DateTime.new(2008,5,3,10,0,0), list_module: modules[2]))
feedback_periods_automata.append(FeedbackDate.create(start_date: DateTime.new(2009,4,25,10,0,0), end_date: DateTime.new(2010,5,3,10,0,0), list_module: modules[2]))
feedback_periods_automata.append(FeedbackDate.create(start_date: DateTime.new(2011,4,25,10,0,0), end_date: DateTime.new(2012,5,3,10,0,0), list_module: modules[2]))
feedback_periods_automata.append(FeedbackDate.create(start_date: DateTime.new(2013,4,25,10,0,0), end_date: DateTime.new(2014,5,3,10,0,0), list_module: modules[2]))
feedback_periods_automata.append(FeedbackDate.create(start_date: DateTime.new(2015,4,25,10,0,0), end_date: DateTime.new(2016,5,3,10,0,0), list_module: modules[2]))
feedback_periods_automata.append(FeedbackDate.create(start_date: DateTime.new(2017,4,25,10,0,0), end_date: DateTime.new(2018,5,3,10,0,0), list_module: modules[2]))


#creating the feedback periods for functional
feedback_periods_functional = []
feedback_periods_functional.append(FeedbackDate.create(start_date: DateTime.new(2003,4,25,10,0,0), end_date: DateTime.new(2004,5,3,10,0,0), list_module: modules[3]))
feedback_periods_functional.append(FeedbackDate.create(start_date: DateTime.new(2005,4,25,10,0,0), end_date: DateTime.new(2006,5,3,10,0,0), list_module: modules[3]))
feedback_periods_functional.append(FeedbackDate.create(start_date: DateTime.new(2007,4,25,10,0,0), end_date: DateTime.new(2008,5,3,10,0,0), list_module: modules[3]))
feedback_periods_functional.append(FeedbackDate.create(start_date: DateTime.new(2009,4,25,10,0,0), end_date: DateTime.new(2010,5,3,10,0,0), list_module: modules[3]))




#connecting teams in robotics to feedback periods
for i in 0...(test_teams_robot.length)
  for j in 0...feedback_periods_robots.length
    TeamFeedbackDate.create(feedback_date_id: feedback_periods_robots[j].id, team_id: test_teams_robot[i].id)

  end
end


#connecting teams in software hut to feedback periods
for i in 0...(test_teams_soft.length)
  for j in 0...feedback_periods_soft.length
    TeamFeedbackDate.create(feedback_date_id: feedback_periods_soft[j].id, team_id: test_teams_soft[i].id)

  end
end

#connecting teams in automata to feedback periods
for i in 0...(test_teams_automata.length)
  for j in 0...feedback_periods_automata.length
    TeamFeedbackDate.create(feedback_date_id: feedback_periods_automata[j].id, team_id: test_teams_automata[i].id)

  end
end

#connecting teams in functional to feedback periods
for i in 0...(test_teams_functional.length)
  for j in 0...feedback_periods_functional.length
    TeamFeedbackDate.create(feedback_date_id: feedback_periods_functional[j].id, team_id: test_teams_functional[i].id)

  end
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
for k in 0...feedback_periods_soft.length
  for i in 0...test_teams_soft.length

    team_members = User.joins(:teams).where("teams.id = ?", test_teams_soft[i].id)
  
    for j in 0...team_members.length
      for z in 0...team_members.length
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

        PeerFeedback.create(feedback_date: feedback_periods_soft[k],
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


#adding peer feedback for robotics
for k in 0...feedback_periods_robots.length
  for i in 0...test_teams_robot.length

    team_members = User.joins(:teams).where("teams.id = ?", test_teams_robot[i].id)
  
    for j in 0...team_members.length
      for z in 0...team_members.length
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

        PeerFeedback.create(feedback_date: feedback_periods_robots[k],
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

#adding peer feedback for automata
for k in 0...feedback_periods_automata.length
  for i in 0...test_teams_automata.length

    team_members = User.joins(:teams).where("teams.id = ?", test_teams_automata[i].id)
  
    for j in 0...team_members.length
      for z in 0...team_members.length
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

        PeerFeedback.create(feedback_date: feedback_periods_automata[k],
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

#adding peer feedback for functional
for k in 0...feedback_periods_functional.length
  for i in 0...test_teams_functional.length

    team_members = User.joins(:teams).where("teams.id = ?", test_teams_functional[i].id)
  
    for j in 0...team_members.length
      for z in 0...team_members.length
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

        PeerFeedback.create(feedback_date: feedback_periods_functional[k],
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


