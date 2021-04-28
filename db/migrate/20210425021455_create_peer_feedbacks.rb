class CreatePeerFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :peer_feedbacks do |t|
      t.string :created_by
      t.string :created_for

      t.string :status, default: 'in_progress'

      t.integer :attendance, default: 'not_set'
      t.integer :attitude, default: 'not_set'
      t.integer :qac, default: 'not_set'
      t.integer :communication, default: 'not_set'
      t.integer :collaboration, default: 'not_set'
      t.integer :leadership, default: 'not_set'
      t.integer :ethics, default: 'not_set'

      t.string :appreciate, default: ''
      t.string :request, default: ''

      t.string :appreciate_edited, default: ''
      t.string :request_edited, default: ''

      t.belongs_to :feedback_date, index: true, foreign_key: true
      
      t.timestamps
    end
  end
end
