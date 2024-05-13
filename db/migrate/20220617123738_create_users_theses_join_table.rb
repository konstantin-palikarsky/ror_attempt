class CreateUsersThesesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :theses, :users
  end
end
