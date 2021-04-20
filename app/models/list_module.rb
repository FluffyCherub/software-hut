# == Schema Information
#
# Table name: list_modules
#
#  id          :bigint           not null, primary key
#  code        :string
#  created_by  :string
#  description :string
#  level       :integer
#  name        :string
#  semester    :string
#  team_type   :string           default("random")
#  years       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ListModule < ApplicationRecord
  validates :name , presence: true
  validates :code , presence: true
  validates :description , presence: true
  validates :semester , presence: true
  validates :years , presence: true
  validates :created_by , presence: true
  validates :level , presence: true


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

  def self.users_in_module(module_id)
    in_module = User.joins(:list_modules).where("list_modules.id = ?",
                                                 module_id)

    return in_module
  end

  def self.students_in_module(module_id)
    in_module = User.joins(:list_modules).where("list_modules.id = ? AND user_list_modules.privilege = ?",
                                                 module_id,
                                                 "student")

    return in_module
  end

  def self.privilege_for_module(username, module_id)
    privilege = UserListModule.joins(:user).where("users.username = ? AND
                                                   user_list_modules.list_module_id = ?",
                                                   username,
                                                   module_id).first.privilege

    return privilege
  end

  #method for importing csv files and adding users to modules
  def self.import(file, module_id)
    transaction do 
      integrity = true
      allowed_file_types = ["text/csv", "application/vnd.ms-excel"]
      if file != nil && allowed_file_types.include?(file.content_type)
        csv_usernames = []

        CSV.foreach(file.path, headers: true, skip_blanks: true) do |row|
          current_user_from_csv = row.to_hash
          add_forename = current_user_from_csv['Forename']
          add_surname = current_user_from_csv['Surname']
          add_username = current_user_from_csv['Student Username']
          add_email = current_user_from_csv['Email']

          if add_email.include?("@sheffield.ac.uk") == false
            integrity = false
            break
          end

          if add_forename.nil? || add_surname.nil? || add_username.nil? || add_email.nil?
            integrity = false
            break
          end
        end

        #if fieleds arent empty add users to the database
        if integrity
          CSV.foreach(file.path, headers: true, skip_blanks: true) do |row|
            current_user_from_csv = row.to_hash
            add_forename = current_user_from_csv['Forename']
            add_surname = current_user_from_csv['Surname']
            add_username = current_user_from_csv['Student Username']
            add_email = current_user_from_csv['Email']
            if (User.is_user_in_system(add_username) == true) && (User.is_user_in_module(add_username, module_id) == true) && (ListModule.privilege_for_module(add_username, module_id) == "suspended")
              User.change_privilege_user_module(add_username, module_id, "student")
            elsif (User.is_user_in_system(add_username) == true) && (User.is_user_in_module(add_username, module_id) == false)
              UserListModule.create(user_id: User.get_user_id(add_username),
                                    list_module_id: module_id,
                                    privilege: "student")
            elsif (User.is_user_in_system(add_username) == false) 
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

  def self.num_students_in_mod(module_id)
    students_num = UserListModule.where(list_module_id: module_id,
                                        privilege: "student")

    return students_num.length
  end

  def self.set_team_type(module_id, new_team_type)
    current_module = ListModule.where(id: module_id)

    current_module.update(team_type: new_team_type)
  end
end
