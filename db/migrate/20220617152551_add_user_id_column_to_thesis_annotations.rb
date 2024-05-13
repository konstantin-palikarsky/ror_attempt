class AddUserIdColumnToThesisAnnotations < ActiveRecord::Migration[7.0]
  def change
    add_column :thesis_annotations, :user_id, :string
  end
end
