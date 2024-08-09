class CreateUserAssessments < ActiveRecord::Migration[7.1]
  def change
    create_table :user_assessments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :assessment, null: false, foreign_key: true
      t.integer :score
      t.datetime :attempted_at
      t.timestamps
    end
  end
end
