class Metric < ApplicationRecord
  belongs_to :suite
  has_many :assignments, dependent: :destroy
  has_many :tests, through: :assignments

  def passed_test_slots
    ActiveRecord::Base.connection.execute("SELECT * FROM
                                                (SELECT assignments.metric_id, assignments.test_slot, results.*, rank() OVER (PARTITION BY assignments.metric_id, assignments.test_slot ORDER BY results.completed_at DESC)
                                                FROM results
                                                JOIN tests on tests.id = results.test_id
                                                JOIN assignments on assignments.test_id = tests.id WHERE assignments.metric_id = #{id} AND results.completed_at >= CURRENT_DATE - interval '#{max_days_since_last_passed_test.blank? ? (suite.max_days_since_last_passed_test.blank? ? MAX_DAYS_SINCE_LAST_PASSED_TEST : suite.max_days_since_last_passed_test) : max_days_since_last_passed_test} days' AND results.completed_at IS NOT NULL) subtable
                                              WHERE rank = 1").map {|slot| slot['passed'] ? 1 : 0}.sum
  end

  # This method, alt_passed_test_slots, should account for the scenario in which the same test is listed multiple times in the same SLOT of the same metric. (In production, this should never happen, as a user should be prevented from adding a test to a metric's slot if it already exists in that slot.)
  def alt_passed_test_slots
    arr = []
    ActiveRecord::Base.connection.execute("SELECT * FROM
                                                (SELECT assignments.metric_id, assignments.test_slot, results.*, rank() OVER (PARTITION BY assignments.metric_id, assignments.test_slot ORDER BY results.completed_at DESC)
                                                FROM results
                                                JOIN tests on tests.id = results.test_id
                                                JOIN assignments on assignments.test_id = tests.id WHERE assignments.metric_id = #{id} AND results.completed_at >= CURRENT_DATE - interval '#{max_days_since_last_passed_test.blank? ? (suite.max_days_since_last_passed_test.blank? ? MAX_DAYS_SINCE_LAST_PASSED_TEST : suite.max_days_since_last_passed_test) : max_days_since_last_passed_test} days' AND results.completed_at IS NOT NULL) subtable
                                              WHERE rank = 1").map {|slot| slot['passed'] ? arr << [slot['metric_id'], slot['test_slot'], slot['id']] : arr = arr }
    arr.uniq.count
  end

  def did_this_test_slot_pass test_slot
    result = ActiveRecord::Base.connection.execute("SELECT assignments.metric_id, assignments.test_slot, results.*
                                                FROM results
                                                JOIN tests on tests.id = results.test_id
                                                JOIN assignments on assignments.test_id = tests.id
                                                WHERE assignments.metric_id = #{id} AND assignments.test_slot = #{test_slot} AND results.completed_at >= CURRENT_DATE - interval '#{max_days_since_last_passed_test.blank? ? (suite.max_days_since_last_passed_test.blank? ? MAX_DAYS_SINCE_LAST_PASSED_TEST : suite.max_days_since_last_passed_test) : max_days_since_last_passed_test} days' AND results.completed_at IS NOT NULL ORDER BY results.completed_at DESC LIMIT 1")
    if result.count > 0 && result[0]['passed']
      true
    else
      false
    end
  end

end
