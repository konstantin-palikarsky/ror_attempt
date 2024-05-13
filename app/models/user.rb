class User < ApplicationRecord
  has_and_belongs_to_many :people
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :theses
end
