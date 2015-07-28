class Job < ActiveRecord::Base
  belongs_to :company, inverse_of: :jobs
  belongs_to :developers, inverse_of: :jobs
end
