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

# test_user1 = User.create(givenname: "Test", sn: "User1", username: 'test_user1', email: 'test_user1@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
# test_user2 = User.create(givenname: "Test", sn: "User2", username: 'test_user2', email: 'test_user2@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
# test_user3 = User.create(givenname: "Test", sn: "User3", username: 'test_user3', email: 'test_user3@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
# test_user4 = User.create(givenname: "Test", sn: "User4", username: 'test_user4', email: 'test_user4@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
# test_user5 = User.create(givenname: "Test", sn: "User5", username: 'test_user5', email: 'test_user5@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
# test_user6 = User.create(givenname: "Test", sn: "User6", username: 'test_user6', email: 'test_user6@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
# test_user7 = User.create(givenname: "Test", sn: "User7", username: 'test_user7', email: 'test_user7@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
# test_user8 = User.create(givenname: "Test", sn: "User8", username: 'test_user8', email: 'test_user8@sheffield.ac.uk', password:'1234', password_confirmation: '1234')

NUM_OF_TEST_USERS = 300

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


modules = ListModule.create([
  {name: 'Software Hut', code: 'COM3420', description: 'The Software Hut (a microcosm of a real Software House) gives students an opportunity to experience the processes of engineering a real software system for a real client in a competitive environment. The taught element covers the tools and technologies needed to manage software development projects successfully and to deliver software products that meet both client expectations and quality standards. Topics that are put into practice include: the requirements engineering process; software modelling and testing; using specific software development framework(s); group project management etc. Tutorials take the form of project meetings, and so are concerned with team management, conduct of meetings and action minutes.', created_by: 'aca19dl', semester: 'SPRING', years: '2020/2021', level: '5'},
  {name: 'Robotics', code: 'COM2009', description: 'Robots go brr', created_by: 'aca19dl', semester: 'SPRING', years: '2020/2021', level: '4'},
  {name: 'Automata, Computation and Complexity', code: 'COM2109', description: 'Connect circles with lines', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2020/2021', level: '7'},
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


num_of_modules = modules.length

#putting test_users in modules
for j in 0...num_of_modules
  for i in 0...NUM_OF_TEST_USERS
    UserListModule.create(list_module: modules[j], user: test_users[i], privilege: 'student')
  end
end

#creating teams in software hut
shuffled_test_users = test_users.shuffle
TEAM_SIZE = 5
NUM_OF_TEAMS = 60
test_teams = []

for j in 1..NUM_OF_TEAMS 
  new_team_name = "Team " + j.to_s
  new_team_topic = "none"
  new_team = Team.create(name: new_team_name, topic: new_team_topic, size: TEAM_SIZE, list_module: modules[0])
  test_teams.append(new_team)
  for i in 0...TEAM_SIZE
    UserTeam.create(team: new_team, user: shuffled_test_users[0], signed_agreement: false)
    shuffled_test_users.shift(1)
  end
end


    
start_date = DateTime.new(2020,2,3,4,5,6)
end_date = DateTime.new(2020,2,10,4,5,6)


#creating the feedback period
feedback_period = FeedbackDate.create(start_date: start_date, end_date: end_date, list_module: modules[0])

appreciate_messages = ["Helpful team member", "Very communicative", "Great leader"]
request_messages = ["Should try to speak more", "Should turn up in meetings", "Should explain ideas more clearly"]

NUM_OF_FEEDBACKS = NUM_OF_TEST_USERS/2

for i in 0...test_teams.length

  team_members = User.joins(:teams).where("teams.id = ?", test_teams[i].id)
 
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

        aprreciate_random = appreciate_messages.sample
        request_random = request_messages.sample

        PeerFeedback.create(feedback_date: feedback_period,
                            attendance: rand_attendace,  
                            attitude: rand_attitude,    
                            collaboration: rand_collaboration,
                            communication: rand_communication,
                            ethics: rand_ethics,   
                            leadership: rand_leadership,
                            qac: rand_qac,
                            appreciate: aprreciate_random,
                            request: request_random,
                            appreciate_edited: aprreciate_random,
                            request_edited: request_random,
                            created_by: team_members[j].username,
                            created_for: team_members[z].username)
      end
    end
  end

end


# teams = Team.create([
#   {name: 'Team 1', topic: 'Topic 1', size: 6, list_module: modules[0]},
#   {name: 'Team 2', topic: 'none', size: 6, list_module: modules[0]},
#   {name: 'Team 3', topic: 'Topic 3', size: 6, list_module: modules[0]},
#   {name: 'Team 4', topic: 'none', size: 6, list_module: modules[0]},
#   {name: 'Team 5', topic: 'Topic 5', size: 6, list_module: modules[0]},
#   {name: 'Team 6', topic: 'none', size: 6, list_module: modules[0]},
#   {name: 'Team 7', topic: 'none', size: 6, list_module: modules[0]},
# ])


# user_teams = UserTeam.create([
#   {team: teams[0], user: test_user1, signed_agreement: false},
#   {team: teams[0], user: test_user2, signed_agreement: false},
#   {team: teams[0], user: test_user3, signed_agreement: false},
#   {team: teams[0], user: test_user4, signed_agreement: false},

#   {team: teams[3], user: user3, signed_agreement: false},
#   {team: teams[3], user: user4, signed_agreement: false},
#   {team: teams[3], user: test_user5, signed_agreement: false},
#   {team: teams[3], user: test_user6, signed_agreement: false},
#   {team: teams[3], user: test_user7, signed_agreement: false},
#   {team: teams[3], user: test_user8, signed_agreement: false},

#   {team: teams[5], user: user5, signed_agreement: false},
#   {team: teams[5], user: user6, signed_agreement: false},
#   {team: teams[5], user: test_user2, signed_agreement: false},
#   {team: teams[5], user: test_user3, signed_agreement: false},

#   {team: teams[6], user: test_user1, signed_agreement: false},
#   {team: teams[6], user: test_user4, signed_agreement: false},
#   {team: teams[6], user: test_user5, signed_agreement: false},
#   {team: teams[6], user: test_user6, signed_agreement: false},
#   {team: teams[6], user: test_user7, signed_agreement: false},
# ])




