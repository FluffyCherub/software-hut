# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user1 = User.create(username: 'aca19dl', email: 'dlaszczyk1@sheffield.ac.uk', password:'1234', password_confirmation: '1234')
user2 = User.create(username: 'acc19am', email: 'aminkov1@sheffield.ac.uk', password:'1234', password_confirmation: '1234')


modules = ListModule.create([
  {name: 'Software Hut', code: 'COM3420', description: 'Do software be stronk', created_by: 'aca19dl', semester: 'SPRING', years: '2020/2021'},
  {name: 'Robotics', code: 'COM2009', description: 'Robots go brr', created_by: 'aca19dl', semester: 'SPRING', years: '2020/2021'},
  {name: 'Automata, Computation and Complexity', code: 'COM2109', description: 'Connect circles with lines', created_by: 'aca19dl', semester: 'ACADEMIC YEAR', years: '2020/2021'},
  {name: 'Functional Programming', code: 'COM2108', description: 'Worse programming', created_by: 'aca19dl', semester: 'AUTUMN', years: '2020/2021'},
  {name: 'Data Driven Computing', code: 'COM2004', description: 'poopoo', created_by: 'aca19dl', semester: 'AUTUMN', years: '2020/2021'}
])

test = UserListModule.create([
  #modules for user1
  {list_module: modules[0], user: user1,privilege: 'student'},
  {list_module: modules[1], user: user1,privilege: 'student'},
  {list_module: modules[2], user: user1,privilege: 'student'},
  {list_module: modules[3], user: user1,privilege: 'student'},
  {list_module: modules[4], user: user1,privilege: 'student'},

  #modules for user2
  {list_module: modules[0], user: user2,privilege: 'student'},
  {list_module: modules[1], user: user2,privilege: 'student'},
  {list_module: modules[2], user: user2,privilege: 'student'},
  {list_module: modules[3], user: user2,privilege: 'student'},
  {list_module: modules[4], user: user2,privilege: 'student'}
])
    
# teams = Teams.create{[
#   {name: 'Team 22', topic: 'none', size: 6, list_module_id: 1}
# ]}


# test2 = UserTeam.create([
#   {team: }
# ])




