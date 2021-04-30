# == Schema Information
#
# Table name: list_modules
#
#  id                :bigint           not null, primary key
#  code              :string
#  created_by        :string
#  description       :string
#  level             :integer
#  mailmerge_message :string           default("")
#  name              :string
#  semester          :string
#  team_type         :string           default("random")
#  years             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class ListModule < ApplicationRecord
  validates :name , presence: true
  validates :code , presence: true
  validates :description , presence: true
  validates :semester , presence: true
  validates :years , presence: true
  validates :created_by , presence: true
  validates :level , presence: true

  #connecting to other tables
  has_many :user_list_modules
  has_many :users, through: :user_list_modules
  has_many :teams
  has_many :feedback_dates


  #generate academic years based on current year(used for module creation)
  def self.generate_years(current_year, num_of_years)
    generated_years = []
    for i in 1..num_of_years
      next_year = current_year.to_s + "/" + (current_year+1).to_s
      generated_years.append(next_year)
      current_year = current_year + 1
    end
    return generated_years
  end

  #get users in a module
  #takes module id returns list of users
  def self.users_in_module(module_id)
    in_module = User.joins(:list_modules).where("list_modules.id = ?",
                                                 module_id)

    return in_module
  end

  #get students in module
  #takes module id, returns list of users
  def self.students_in_module(module_id)
    in_module = User.joins(:list_modules).where("list_modules.id = ? AND user_list_modules.privilege = ?",
                                                 module_id,
                                                 "student")

    return in_module
  end

  #get the module privilege of a user
  #takes username and module id, returns a privilege string
  def self.privilege_for_module(username, module_id)
    privilege = UserListModule.joins(:user).where("users.username = ? AND
                                                   user_list_modules.list_module_id = ?",
                                                   username,
                                                   module_id).first.privilege

    return privilege
  end

  #method for importing csv files and adding users to modules
  #takes a file and module id, returns void
  def self.import(file, module_id)
    transaction do 
      #variable for checking if all fields in the csv are input correctly 
      #and there arent any missing fields
      integrity = true

      #setting file types which the system can proccess
      allowed_file_types = ["text/csv", "application/vnd.ms-excel"]
      if file != nil && allowed_file_types.include?(file.content_type)
        csv_usernames = []

        #looping through rows in the csv(every row is one user)
        CSV.foreach(file.path, headers: true, skip_blanks: true) do |row|

          #get information about the user to add to the module
          current_user_from_csv = row.to_hash
          add_forename = current_user_from_csv['Forename']
          add_surname = current_user_from_csv['Surname']
          add_username = current_user_from_csv['Student Username']
          add_email = current_user_from_csv['Email']

          #if university of sheffield domain missing from email set integrity to false
          if add_email.include?("@sheffield.ac.uk") == false
            integrity = false
            break
          end

          #if any of the forename, surname, username or email fields are missing, set integrity to false
          if add_forename.nil? || add_surname.nil? || add_username.nil? || add_email.nil?
            integrity = false
            break
          end
        end

        #if data is fine in the csv add users to the database
        if integrity
          CSV.foreach(file.path, headers: true, skip_blanks: true) do |row|

            #get information about the user to add to the module
            current_user_from_csv = row.to_hash
            add_forename = current_user_from_csv['Forename']
            add_surname = current_user_from_csv['Surname']
            add_username = current_user_from_csv['Student Username']
            add_email = current_user_from_csv['Email']

            #check if this user is already in the system or in the module
            is_user_in_system = User.is_user_in_system(add_username)
            is_user_in_module = User.is_user_in_module(add_username, module_id)
            
            #if he is already in the module and was suspended change his status to student
            if (is_user_in_system == true) && (is_user_in_module == true) && (ListModule.privilege_for_module(add_username, module_id) == "suspended")
              User.change_privilege_user_module(add_username, module_id, "student")
            elsif (is_user_in_system == true) && (is_user_in_module == false)
              #if user was in the system, but wasnt in the module, then link him to the module
              UserListModule.create(user_id: User.get_user_id(add_username),
                                    list_module_id: module_id,
                                    privilege: "student")
            elsif (is_user_in_system == false) 
              #if user wasnt in the system, then add him to the system and then to the module
              created_user = User.create(givenname: add_forename,
                                        sn: add_surname,
                                        username: add_username,
                                        email: add_email)

              UserListModule.create(user_id: created_user.id,
                                    list_module_id: module_id,
                                    privilege: "student")
            end
            
            
            csv_usernames.append(add_username)
            
          end

          #users who are in the module but werent in the csv get privilege changed to suspended
          in_module_users = ListModule.users_in_module(module_id)

          for i in 0..(in_module_users.length-1)
            users_privilege = ListModule.privilege_for_module(in_module_users[i].username, module_id)
            if (csv_usernames.include?(in_module_users[i].username) == false) && (users_privilege != "module_leader") && (users_privilege.include?("teaching_assistant") == false)
              
              User.change_privilege_user_module(in_module_users[i].username, module_id, "suspended")
            end
          end

        end

      end

    end
  end

  #get number of students in a module
  #takes module id, returns int with number of students
  def self.num_students_in_mod(module_id)
    students_num = UserListModule.where(list_module_id: module_id,
                                        privilege: "student")

    return students_num.length
  end

  #change team type of given module
  #takes module id and a new team type as string
  #returns void
  def self.set_team_type(module_id, new_team_type)
    current_module = ListModule.where(id: module_id)

    current_module.update(team_type: new_team_type)
  end

  #get module name from module id
  #takes module id, returns module name as string
  def self.get_mod_name_from_id(module_id)
    mod_name = ListModule.find(module_id).name
    return mod_name
  end
end
