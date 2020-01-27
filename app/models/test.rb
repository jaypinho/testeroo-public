class Test < ApplicationRecord
  has_many :results, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :metrics, through: :assignments

  def most_recent_test
    results.where.not(:completed_at => nil).order(completed_at: :desc).first
  end

end
