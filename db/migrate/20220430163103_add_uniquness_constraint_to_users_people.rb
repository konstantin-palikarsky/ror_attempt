class AddUniqunessConstraintToUsersPeople < ActiveRecord::Migration[7.0]
  def change
    add_index :people_users, [:user_id, :person_id], unique: true
  end
end
