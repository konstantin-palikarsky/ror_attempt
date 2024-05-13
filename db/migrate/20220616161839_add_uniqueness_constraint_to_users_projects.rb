class AddUniquenessConstraintToUsersProjects < ActiveRecord::Migration[7.0]
  def change
    add_index :projects_users, [:user_id, :project_id], unique: true
  end
end
