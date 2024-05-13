class AddUniquenessConstraintToUsersTheses < ActiveRecord::Migration[7.0]
  def change
    add_index :theses_users, [:user_id, :thesis_id], unique: true
  end
end
