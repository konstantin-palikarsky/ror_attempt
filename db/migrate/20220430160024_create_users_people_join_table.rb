class CreateUsersPeopleJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :people, :users
  end
end
