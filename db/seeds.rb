# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user1 = User.create(username: 'aca19dl', email: 'dlaszczyk1@sheffield.ac.uk', password:'1234', password_confirmation: '1234', admin: true)
user2 = User.create(username: 'acc19am', email: 'aminkov1@sheffield.ac.uk', password:'1234', password_confirmation: '1234', admin: true)

test_user1 = User.create(givenname: "Test", sn: "User1", username: 'test_user1', email: 'test_user1@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
test_user2 = User.create(givenname: "Test", sn: "User2", username: 'test_user2', email: 'test_user2@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
test_user3 = User.create(givenname: "Test", sn: "User3", username: 'test_user3', email: 'test_user3@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
test_user4 = User.create(givenname: "Test", sn: "User4", username: 'test_user4', email: 'test_user4@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
test_user5 = User.create(givenname: "Test", sn: "User5", username: 'test_user5', email: 'test_user5@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
test_user6 = User.create(givenname: "Test", sn: "User6", username: 'test_user6', email: 'test_user6@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
test_user7 = User.create(givenname: "Test", sn: "User7", username: 'test_user7', email: 'test_user7@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
test_user8 = User.create(givenname: "Test", sn: "User8", username: 'test_user8', email: 'test_user8@sheffield.ac.uk', password:'1234', password_confirmation: '1234')

modules = ListModule.create([
  {name: 'Software Hut', code: 'COM3420', description: 'The Software Hut (a microcosm of a real Software House) gives students an opportunity to experience the processes of engineering a real software system for a real client in a competitive environment. The taught element covers the tools and technologies needed to manage software development projects successfully and to deliver software products that meet both client expectations and quality standards. Topics that are put into practice include: the requirements engineering process; software modelling and testing; using specific software development framework(s); group project management etc. Tutorials take the form of project meetings, and so are concerned with team management, conduct of meetings and action minutes.', created_by: 'aca19dl', semester: 'SPRING', years: '2020/2021'},
  {name: 'Robotics', code: 'COM2009', description: 'Robots go brr', created_by: 'aca19dl', semester: 'SPRING', years: '2020/2021'},
  {name: 'Automata, Computation and Complexity', code: 'COM2109', description: 'Connect circles with lines', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2020/2021'},
  {name: 'Functional Programming', code: 'COM2108', description: 'Worse programming', created_by: 'aca19dl', semester: 'AUTUMN', years: '2020/2021'},
  {name: 'Data Driven Computing', code: 'COM2004', description: 'poopoo', created_by: 'aca19dl', semester: 'AUTUMN', years: '2020/2021'},

  {name: 'Java Programming', code: 'COM1003', description: 'java stuff', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2019/2020'},
  {name: 'Machines and Intelligence', code: 'COM1005', description: 'Miro', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2019/2020'},
  {name: 'Devices and Networks', code: 'COM1006', description: 'l;ksdjfbhnv', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2019/2020'},
  {name: 'Web and Internet Technology', code: 'COM1008', description: 'html', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2019/2020'},
  {name: 'Foundations of Computer Science', code: 'COM1002', description: 'mafs', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2019/2020'},

  {name: 'Test Module 1', code: 'COM3003', description: 'Test description 1', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2021/2022'},
  {name: 'Test Module 2', code: 'COM3005', description: 'Test description 2', created_by: 'aca19dl', semester: 'AUTUMN', years: '2021/2022'},
  {name: 'Test Module 3', code: 'COM3006', description: 'Test description 3', created_by: 'aca19dl', semester: 'SPRING', years: '2021/2022'}
  
])

test = UserListModule.create([
  #modules for user1
  {list_module: modules[0], user: user1, privilege: 'student'},
  {list_module: modules[1], user: user1, privilege: 'student'},
  {list_module: modules[2], user: user1, privilege: 'student'},
  {list_module: modules[3], user: user1, privilege: 'student'},
  {list_module: modules[4], user: user1, privilege: 'student'},

  #modules for user2
  {list_module: modules[0], user: user2, privilege: 'student'},
  {list_module: modules[1], user: user2, privilege: 'student'},
  {list_module: modules[2], user: user2, privilege: 'student'},
  {list_module: modules[3], user: user2, privilege: 'student'},
  {list_module: modules[4], user: user2, privilege: 'student'},

  #modules for test users
  {list_module: modules[7], user: test_user3, privilege: 'student'},
  {list_module: modules[7], user: test_user1, privilege: 'student'},
  {list_module: modules[7], user: test_user2, privilege: 'student'},
  {list_module: modules[8], user: test_user5, privilege: 'student'},
  {list_module: modules[8], user: test_user1, privilege: 'student'},
  {list_module: modules[8], user: test_user3, privilege: 'student'},
  {list_module: modules[9], user: test_user5, privilege: 'student'},
  {list_module: modules[10], user: test_user2, privilege: 'student'},
  {list_module: modules[10], user: test_user4, privilege: 'student'},
  {list_module: modules[11], user: test_user2, privilege: 'student'},
  {list_module: modules[11], user: test_user5, privilege: 'student'},
  {list_module: modules[11], user: test_user3, privilege: 'student'},
  {list_module: modules[12], user: test_user1, privilege: 'student'},
  {list_module: modules[12], user: test_user4, privilege: 'student'},
  {list_module: modules[12], user: test_user2, privilege: 'student'},

  {list_module: modules[0], user: test_user1, privilege: 'student'},
  {list_module: modules[0], user: test_user2, privilege: 'student'},
  {list_module: modules[0], user: test_user3, privilege: 'student'},
  {list_module: modules[0], user: test_user4, privilege: 'student'},

  {list_module: modules[0], user: test_user5, privilege: 'module_leader'},
  {list_module: modules[0], user: test_user6, privilege: 'teaching_assistant_1'},
  {list_module: modules[0], user: test_user7, privilege: 'teaching_assistant_2'},
  {list_module: modules[0], user: test_user8, privilege: 'teaching_assistant_3'}

])
    
teams = Team.create([
  {name: 'Team 1', topic: 'Topic 1', size: 6, list_module: modules[0]},
  {name: 'Team 2', topic: 'none', size: 6, list_module: modules[0]},
  {name: 'Team 3', topic: 'Topic 3', size: 6, list_module: modules[0]},
  {name: 'Team 4', topic: 'none', size: 6, list_module: modules[0]},
  {name: 'Team 5', topic: 'Topic 5', size: 6, list_module: modules[0]},
  {name: 'Team 6', topic: 'none', size: 6, list_module: modules[0]},
  {name: 'Team 7', topic: 'none', size: 6, list_module: modules[0]},
])


test2 = UserTeam.create([
  {team: teams[0], user: user1, signed_agreement: false},
  {team: teams[0], user: user2, signed_agreement: false},
  {team: teams[0], user: test_user1, signed_agreement: false},
  {team: teams[0], user: test_user2, signed_agreement: false},
  {team: teams[0], user: test_user3, signed_agreement: false},
  {team: teams[0], user: test_user4, signed_agreement: false},

  {team: teams[3], user: test_user5, signed_agreement: false},
  {team: teams[3], user: test_user6, signed_agreement: false},
  {team: teams[3], user: test_user7, signed_agreement: false},
  {team: teams[3], user: test_user8, signed_agreement: false},

  {team: teams[5], user: test_user2, signed_agreement: false},
  {team: teams[5], user: test_user3, signed_agreement: false},

  {team: teams[6], user: test_user1, signed_agreement: false},
  {team: teams[6], user: test_user4, signed_agreement: false},
  {team: teams[6], user: test_user5, signed_agreement: false},
  {team: teams[6], user: test_user6, signed_agreement: false},
  {team: teams[6], user: test_user7, signed_agreement: false},
])




