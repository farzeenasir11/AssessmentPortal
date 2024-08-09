class CreateUserResults < ActiveRecord::Migration[7.1]
  def change
    create_table :user_results do |t|
      t.references :user_assessment, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true
      t.boolean :correct, default: false
      t.timestamps
    end
  end
end
