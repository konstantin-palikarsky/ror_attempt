class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :project_id
      t.string :title

      t.timestamps
    end
  end
end
