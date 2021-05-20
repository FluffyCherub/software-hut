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
                                                   module_id).first

    if privilege.nil?
      return nil
    else
      return privilege.privilege
    end
   
  end

  #method for importing csv files and adding users to modules
  #takes a file and module id, returns void
  
  # :nocov:
    def self.import(file, module_id)

      #variable for checking if all fields in the csv are input correctly
      #and there arent any missing fields
      integrity = true

      transaction do
        if file != nil
          #get an array of headers from the csv file
          csv_headers = file[0].split(',')

          #store usernames of users in csv file
          csv_usernames = []

          #get indexes of needed headers
          surname_index = csv_headers.index("Surname")
          forename_index = csv_headers.index("Forename")
          username_index = csv_headers.index("Student Username")
          email_index = csv_headers.index("Email")

          #check if all neccessary headers are present
          if surname_index.nil? || forename_index.nil? || username_index.nil? || email_index.nil?
            integrity = false
          else

            #looping through rows in the csv(every row is one user), starting from index 1(beacuse index 0 is headers)
            for i in 1...(file.length)

              #get information about the user to add to the module
              current_user_from_csv = file[i].split(',')

              add_surname = current_user_from_csv[surname_index]
              add_forename = current_user_from_csv[forename_index]
              add_username = current_user_from_csv[username_index]
              add_email = current_user_from_csv[email_index]

              if(add_surname != nil && add_surname.length != 0) ||
                (add_forename != nil && add_forename.length != 0) ||
                (add_username != nil && add_username.length != 0) ||
                (add_email != nil && add_email.length != 0)

                #if any of the forename, surname, username or email fields are missing, set integrity to false
                if (add_forename.nil? || add_surname.nil? || add_username.nil? || add_email.nil? ||
                  add_forename.length == 0 || add_surname.length == 0 || add_username.length == 0 || add_email.length == 0)

                  integrity = false
                  break
                end

                #if university of sheffield domain missing from email set integrity to false
                if add_email.include?("@sheffield.ac.uk") == false
                  integrity = false
                  break
                end
              end
            end
          end


          #if data is fine in the csv, add users to the database
          if integrity
            #looping through rows in the csv(every row is one user), starting from index 1(beacuse index 0 is headers)
            for i in 1...(file.length)

              #get information about the user to add to the module
              current_user_from_csv = file[i].split(',')

              add_surname = current_user_from_csv[surname_index]
              add_forename = current_user_from_csv[forename_index]
              add_username = current_user_from_csv[username_index]
              add_email = current_user_from_csv[email_index]

              if ((add_surname == nil || add_surname.length == 0) ||
                (add_forename == nil || add_forename.length == 0) ||
                (add_username == nil || add_username.length == 0) ||
                (add_email == nil || add_email.length == 0))

                next
              end

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

      return integrity
    end
  # :nocov:

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

  def self.approve_teams(module_id)
    waiting_teams = Team.joins(:list_module)
                        .where("list_modules.id = ? AND teams.status = ?",
                                module_id,
                                "waiting_for_approval").update_all(status: "active")
  end

  def self.all_approved(module_id)
    unapproved_teams = Team.joins(:list_module)
                           .where("teams.status = ? AND list_modules.id = ?",
                           "waiting_for_approval",
                           module_id)

    if unapproved_teams.length == 0
      return true
    else
      return false
    end
  end

  def self.has_active_teams(module_id)
    active_teams = Team.joins(:list_module)
                        .where("teams.status = ? AND list_modules.id = ?",
                        "active",
                        module_id)

    if active_teams.length != 0
      return true
    else
      return false
    end
  end

  def self.get_future_feedback_periods(module_id, current_time)
    all_feedback_periods = FeedbackDate.where(list_module_id: module_id)

    future_f_periods = []

    for i in 0...all_feedback_periods.length
      if all_feedback_periods[i].start_date > current_time
        future_f_periods.append(all_feedback_periods[i])
      end
    end

    return future_f_periods
  end
  
  def self.get_teams_for_user(module_id, username)

    inactive_teams = Team.joins(:users)
                          .where("teams.list_module_id = ? AND
                                  users.username = ?",
                                  module_id,
                                  username)

    return inactive_teams
  end

  def self.get_inactive_teams_for_user(module_id, username)

    inactive_teams = Team.joins(:users)
                          .where("teams.list_module_id = ? AND
                                  teams.status = ? AND
                                  users.username = ?",
                                  module_id,
                                  "inactive",
                                  username)

    return inactive_teams
  end

  def self.get_modules_for_years(years, username)
    inactive_modules = ListModule.joins(:users)
                                  .where("users.username = ? AND
                                          list_modules.years = ?", 
                                          username,
                                          years)
                                  .group(:id)
                                  
    return inactive_modules
  end

  def self.get_inactive_modules_for_years(years, username)
    inactive_modules = ListModule.joins(:teams, :users)
                                  .where("teams.status = ? AND
                                          users.username = ? AND
                                          list_modules.years = ?", 
                                          "inactive",
                                          username,
                                          years)
                                  .group(:id)
                                  
    return inactive_modules
  end

  def self.get_mod_leads(module_id)
    mod_leads = User.joins(:list_modules)
                    .where("list_modules.id = ? AND 
                            user_list_modules.privilege = ?",
                            module_id, 
                            "module_leader")

    return mod_leads
  end

  #get all teaching assistants and module leaders for a module(User objects)
  def self.get_ta_and_mod_lead(module_id)
    ta_and_mod_lead = User.joins(:list_modules)
                          .where("list_modules.id = ? AND 
                                  (user_list_modules.privilege = ? OR 
                                  user_list_modules.privilege LIKE ?)",
                                  module_id,
                                  "module_leader",
                                  "%teaching_assistant%")

    return ta_and_mod_lead
  end

  #get all teaching assistants and module leaders for a module(full name and email)
  def self.get_ta_and_mod_lead_names_username(module_id)
    ta_and_mod_lead = User.joins(:list_modules)
                          .where("list_modules.id = ? AND 
                                  (user_list_modules.privilege = ? OR 
                                  user_list_modules.privilege LIKE ?)",
                                  module_id,
                                  "module_leader",
                                  "%teaching_assistant%")

    result = []

    for i in 0...ta_and_mod_lead.length
      result.append(ta_and_mod_lead[i].givenname + " " + ta_and_mod_lead[i].sn + " - " + ta_and_mod_lead[i].username)
    end

    return result
  end
end
