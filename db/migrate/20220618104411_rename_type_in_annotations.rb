class RenameTypeInAnnotations < ActiveRecord::Migration[7.0]
  def change
    rename_column :annotations, :type, :annotation_type
  end
end
