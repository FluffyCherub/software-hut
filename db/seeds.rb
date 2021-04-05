# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user1 = User.create(username: 'aca19dl', email: 'dlaszczyk1@sheffield.ac.uk', password:'1234', password_confirmation: '1234', admin: true)
user2 = User.create(username: 'acc19am', email: 'aminkov1@sheffield.ac.uk', password:'1234', password_confirmation: '1234', admin: true)

test_user1 = User.create(username: 'test_user1', email: 'test_user1@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
test_user2 = User.create(username: 'test_user2', email: 'test_user2@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
test_user3 = User.create(username: 'test_user3', email: 'test_user3@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
test_user4 = User.create(username: 'test_user4', email: 'test_user4@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
test_user5 = User.create(username: 'test_user5', email: 'test_user5@sheffield.ac.uk', password:'1234', password_confirmation: '1234')

modules = ListModule.create([
  {name: 'Software Hut', code: 'COM3420', description: 'Do software be stronk', created_by: 'aca19dl', semester: 'SPRING', years: '2020/2021'},
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
  {list_module: modules[4], user: user2, privilege: 'student'}
])
    
teams = Team.create([
  {name: 'Team 22', topic: 'none', size: 6, list_module: modules[0]}
])


test2 = UserTeam.create([
  {team: teams[0], user: user1, signed_agreement: false},
  {team: teams[0], user: user2, signed_agreement: false},

  {team: teams[0], user: test_user1, signed_agreement: false},
  {team: teams[0], user: test_user2, signed_agreement: false},
  {team: teams[0], user: test_user3, signed_agreement: false},
  {team: teams[0], user: test_user4, signed_agreement: false}
])




