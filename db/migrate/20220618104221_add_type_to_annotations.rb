class AddTypeToAnnotations < ActiveRecord::Migration[7.0]
  def change
    add_column :annotations, :type, :string
  end
end
