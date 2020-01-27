class Result < ApplicationRecord
  belongs_to :test
  belongs_to :user

  def passed_to_string
    passed ? 'passed' : (passed.nil? ? 'didn\'t complete' : 'failed')
  end

end
