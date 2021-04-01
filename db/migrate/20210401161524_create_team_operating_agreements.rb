class CreateTeamOperatingAgreements < ActiveRecord::Migration[6.0]
  def change
    create_table :team_operating_agreements do |t|
      t.string :project_name
      t.string :module_name
      t.string :module_leader
      t.string :team_name
      t.string :start_date
      t.string :end_date

      t.string :team_mission
      t.string :team_communications
      t.string :decision_making
      t.string :meetings
      t.string :personal_courtesies

      t.datetime :last_opened
      t.datetime :last_edited
   
      t.belongs_to :team, index: true, foreign_key: true

      t.timestamps
    end
  end
end
