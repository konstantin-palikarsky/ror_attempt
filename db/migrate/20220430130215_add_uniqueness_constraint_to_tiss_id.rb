class AddUniquenessConstraintToTissId < ActiveRecord::Migration[7.0]
  def change
    add_index :people, [:tiss_id], unique: true, name: 'uniq_tiss_id_per_person'
  end
end
