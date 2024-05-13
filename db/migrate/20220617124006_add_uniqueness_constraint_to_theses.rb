class AddUniquenessConstraintToTheses < ActiveRecord::Migration[7.0]
  def change
    add_index :theses, [:thesis_id], unique: true, name: 'uniq_thesis_id_per_thesis'

  end
end
