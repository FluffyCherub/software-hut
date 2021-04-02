class CreateTeamOperatingAgreements < ActiveRecord::Migration[6.0]
  def change
    create_table :team_operating_agreements do |t|
      t.string :project_name, default: ''
      t.string :module_name, default: ''
      t.string :module_leader, default: ''
      t.string :team_name, default: ''
      t.string :start_date, default: ''
      t.string :end_date, default: ''

      t.string :team_mission, default: ''
      t.string :team_communications, default: ''
      t.string :decision_making, default: ''
      t.string :meetings, default: ''
      t.string :personal_courtesies, default: ''

      t.string :status, default: 'in_progress'

      t.datetime :last_opened
      t.datetime :last_edited
   
      t.belongs_to :team, index: true, foreign_key: true

      t.timestamps
    end
  end
end
