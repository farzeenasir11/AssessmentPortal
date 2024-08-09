class CreateAssessments < ActiveRecord::Migration[7.1]
  def change
    create_table :assessments do |t|
      t.string :title, null: false
      t.text :description
      t.references :project, null: false, foreign_key: true
      t.timestamps
    end
  end
end
