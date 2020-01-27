class Assignment < ApplicationRecord
  belongs_to :metric
  belongs_to :test

  validates :test_id, uniqueness: {scope: [:metric_id, :test_slot]}
end
