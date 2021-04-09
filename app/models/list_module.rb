# == Schema Information
#
# Table name: list_modules
#
#  id          :bigint           not null, primary key
#  code        :string
#  created_by  :string
#  description :string
#  name        :string
#  semester    :string
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


  has_many :user_list_modules
  has_many :users, through: :user_list_modules
  has_many :teams


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

  #method for importing csv files and adding users to modules
  def self.import(file, module_id)
    integrity = true
    if file != nil
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

          current_user = User.find_or_create_by(givenname: current_user_from_csv['Forename'],
                                                sn: current_user_from_csv['Surname'],
                                                username: current_user_from_csv['Student Username'],
                                                email: current_user_from_csv['Email'])

          UserListModule.find_or_create_by(user_id: current_user.id,
                                          list_module_id: module_id,
                                          privilege: "student")
        end
      end
    end
  end
  
end
