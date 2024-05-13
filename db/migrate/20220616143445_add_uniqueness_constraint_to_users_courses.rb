class AddUniquenessConstraintToUsersCourses < ActiveRecord::Migration[7.0]
  def change
    add_index :courses_users, [:user_id, :course_id], unique: true
  end
end
