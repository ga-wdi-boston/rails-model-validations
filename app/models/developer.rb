class Developer < ActiveRecord::Base
  has_many :companies, through: :jobs
  has_many :jobs
end
