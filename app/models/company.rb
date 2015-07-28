class Company < ActiveRecord::Base
  has_many :developers, through: :jobs
  has_many :jobs
end
