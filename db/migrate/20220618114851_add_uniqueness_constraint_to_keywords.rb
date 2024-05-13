class AddUniquenessConstraintToKeywords < ActiveRecord::Migration[7.0]
  def change
    add_index :keywords, [:user_id, :annot_id, :kw_type], unique: true
  end
end
