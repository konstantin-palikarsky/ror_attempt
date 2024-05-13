class AddUniquenessConstraintToAnnotations < ActiveRecord::Migration[7.0]
  def change
    add_index :annotations, [:user_id, :annot_id, :annotation_type], unique: true
  end
end
