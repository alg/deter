require 'test_helper'

class ActivityLogTest < ActiveSupport::TestCase

  test 'adding records to user log' do
    log = ActivityLog.new("user:mark")
    log.clear
    log.add(:login, 'mark')
    log.add(:logout, 'mark')

    assert_equal [
      { action: 'logout', uid: 'mark' },
      { action: 'login',  uid: 'mark' }
    ], no_ts(log.records)
  end

  test 'adding records to experiment log' do
    log = ActivityLog.new("experiment:Alfa-Romeo:ExperimentOne")
    log.clear
    log.add(:create, 'mark')
    log.add(:profile_update, 'mark', { field: 'value' })

    assert_equal [
      { action: 'profile_update', uid: 'mark', field: 'value' },
      { action: 'create',         uid: 'mark' }
    ], no_ts(log.records)
  end

  test 'returning N last messages' do
    log = ActivityLog.new("user:mark")
    log.clear
    log.add(:login,  'mark', field: '1')
    log.add(:logout, 'mark', field: '2')
    log.add(:login,  'mark', field: '3')
    log.add(:logout, 'mark', field: '4')

    assert_equal [
      { action: 'logout', uid: 'mark', field: '4' },
      { action: 'login',  uid: 'mark', field: '3' },
      { action: 'logout', uid: 'mark', field: '2' }
    ], no_ts(log.records(3))
  end

  private

  # removes timestamp fields so it's easier to check
  def no_ts(records)
    records.map do |r|
      r.delete(:ts)
      r
    end
  end
end
