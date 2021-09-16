class CreateTodos < ActiveRecord::Migration[6.1]
  def change
    create_table :todos do |t|
      t.string :title
      t.references :project, null: false, foreign_key: true
      t.boolean :complete, default: false
      t.date :deadline 

      t.timestamps
    end
  end
end
