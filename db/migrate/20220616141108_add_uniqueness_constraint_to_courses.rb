class AddUniquenessConstraintToCourses < ActiveRecord::Migration[7.0]
  def change
    add_index :courses, [:number_semester], unique: true, name: 'uniq_number_semester_per_course'
  end
end
