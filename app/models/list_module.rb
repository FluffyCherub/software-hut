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
    if file != nil
      CSV.foreach(file.path, headers: true, skip_blanks: true) do |row|
        current_user_from_csv = row.to_hash

        add_email = current_user_from_csv['Email']
        if User.check_if_email(add_email) != 0
          #it is not an email, so we append sheffield.ac.uk at the end
          add_email = add_email + "@sheffield.ac.uk"
        else
          email_without_at = add_email[0, add_email.index("@")]
          add_email = email_without_at + "@sheffield.ac.uk"
        end


        current_user = User.find_or_create_by(givenname: current_user_from_csv['Forename'],
                                              sn: current_user_from_csv['Surname'],
                                              username: current_user_from_csv['Student Username'],
                                              email: add_email)

        UserListModule.find_or_create_by(user_id: current_user.id,
                                        list_module_id: module_id,
                                        privilege: "student")
      end
    end
  end
  
end
