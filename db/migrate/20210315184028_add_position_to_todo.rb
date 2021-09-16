class AddPositionToTodo < ActiveRecord::Migration[6.1]
  def change
    add_column :todos, :position, :integer
  end
end
