class AddUniquenessConstraintToProjects < ActiveRecord::Migration[7.0]
  def change
    add_index :projects, [:project_id], unique: true, name: 'uniq_project_id_per_project'
  end
end
