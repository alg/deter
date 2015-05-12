require 'services/deter_lab/abstract_test'

class DeterLab::ExperimentsTest < DeterLab::AbstractTest

  LAYOUT = "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+CjxleHBlcmltZW50PgogPHZlcnNpb24+MS4wPC92ZXJzaW9uPgogPHN1YnN0cmF0ZXM+CiAgPG5hbWU+bGluazI8L25hbWU+CiAgPGNhcGFjaXR5PgogICA8cmF0ZT4xMDAwMDAuMDAwMDAwPC9yYXRlPgogICA8a2luZD5tYXg8L2tpbmQ+CiAgPC9jYXBhY2l0eT4KIDwvc3Vic3RyYXRlcz4KIDxzdWJzdHJhdGVzPgogIDxuYW1lPmxpbmswPC9uYW1lPgogIDxjYXBhY2l0eT4KICAgPHJhdGU+MTAwMDAwLjAwMDAwMDwvcmF0ZT4KICAgPGtpbmQ+bWF4PC9raW5kPgogIDwvY2FwYWNpdHk+CiA8L3N1YnN0cmF0ZXM+CiA8c3Vic3RyYXRlcz4KICA8bmFtZT5saW5rMTwvbmFtZT4KICA8Y2FwYWNpdHk+CiAgIDxyYXRlPjEwMDAwMC4wMDAwMDA8L3JhdGU+CiAgIDxraW5kPm1heDwva2luZD4KICA8L2NhcGFjaXR5PgogPC9zdWJzdHJhdGVzPgogPGVsZW1lbnRzPgogIDxjb21wdXRlcj4KICAgPG5hbWU+ZDwvbmFtZT4KICAgPGludGVyZmFjZT4KICAgIDxzdWJzdHJhdGU+bGluazI8L3N1YnN0cmF0ZT4KICAgIDxuYW1lPmluZjAwMDwvbmFtZT4KICAgIDxjYXBhY2l0eT4KICAgICA8cmF0ZT4xMDAwMDAuMDAwMDAwPC9yYXRlPgogICAgIDxraW5kPm1heDwva2luZD4KICAgIDwvY2FwYWNpdHk+CiAgIDwvaW50ZXJmYWNlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT50eXBlPC9hdHRyaWJ1dGU+" +
           "CiAgICA8dmFsdWU+cGM8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICAgPGF0dHJpYnV0ZT4KICAgIDxhdHRyaWJ1dGU+dGVzdGJlZDwvYXR0cmlidXRlPgogICAgPHZhbHVlPmRldGVyPC92YWx1ZT4KICAgPC9hdHRyaWJ1dGU+CiAgIDxhdHRyaWJ1dGU+CiAgICA8YXR0cmlidXRlPmZhaWx1cmVhY3Rpb248L2F0dHJpYnV0ZT4KICAgIDx2YWx1ZT5mYXRhbDwvdmFsdWU+CiAgIDwvYXR0cmlidXRlPgogIDwvY29tcHV0ZXI+CiA8L2VsZW1lbnRzPgogPGVsZW1lbnRzPgogIDxjb21wdXRlcj4KICAgPG5hbWU+YTwvbmFtZT4KICAgPGludGVyZmFjZT4KICAgIDxzdWJzdHJhdGU+bGluazA8L3N1YnN0cmF0ZT4KICAgIDxuYW1lPmluZjAwMDwvbmFtZT4KICAgIDxjYXBhY2l0eT4KICAgICA8cmF0ZT4xMDAwMDAuMDAwMDAwPC9yYXRlPgogICAgIDxraW5kPm1heDwva2luZD4KICAgIDwvY2FwYWNpdHk+CiAgIDwvaW50ZXJmYWNlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT50eXBlPC9hdHRyaWJ1dGU+CiAgICA8dmFsdWU+cGM8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICAgPGF0dHJpYnV0ZT4KICAgIDxhdHRyaWJ1dGU+dGVzdGJlZDwvYXR0cmlidXRlPgogICAgPHZhbHVlPmRlc2t0b3A8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICAgPGF0dHJpYnV0ZT4KICAgIDxhdHRyaWJ1dGU+ZmFpbHVyZWFjdGlvbjwvYXR0cmlidXRlPgogICAgPHZhbHVlPmZhdGFsPC92YWx1ZT4KICAgPC9hdHRyaWJ1dGU+CiAgPC9jb21wdXRlcj4KIDwvZWxlbWVudHM+" +
           "CiA8ZWxlbWVudHM+CiAgPGNvbXB1dGVyPgogICA8bmFtZT5iPC9uYW1lPgogICA8aW50ZXJmYWNlPgogICAgPHN1YnN0cmF0ZT5saW5rMDwvc3Vic3RyYXRlPgogICAgPG5hbWU+aW5mMDAwPC9uYW1lPgogICAgPGNhcGFjaXR5PgogICAgIDxyYXRlPjEwMDAwMC4wMDAwMDA8L3JhdGU+CiAgICAgPGtpbmQ+bWF4PC9raW5kPgogICAgPC9jYXBhY2l0eT4KICAgPC9pbnRlcmZhY2U+CiAgIDxpbnRlcmZhY2U+CiAgICA8c3Vic3RyYXRlPmxpbmsxPC9zdWJzdHJhdGU+CiAgICA8bmFtZT5pbmYwMDE8L25hbWU+CiAgICA8Y2FwYWNpdHk+CiAgICAgPHJhdGU+MTAwMDAwLjAwMDAwMDwvcmF0ZT4KICAgICA8a2luZD5tYXg8L2tpbmQ+CiAgICA8L2NhcGFjaXR5PgogICA8L2ludGVyZmFjZT4KICAgPGF0dHJpYnV0ZT4KICAgIDxhdHRyaWJ1dGU+dHlwZTwvYXR0cmlidXRlPgogICAgPHZhbHVlPnBjPC92YWx1ZT4KICAgPC9hdHRyaWJ1dGU+CiAgIDxhdHRyaWJ1dGU+CiAgICA8YXR0cmlidXRlPnRlc3RiZWQ8L2F0dHJpYnV0ZT4KICAgIDx2YWx1ZT5kZXRlcjwvdmFsdWU+CiAgIDwvYXR0cmlidXRlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT5mYWlsdXJlYWN0aW9uPC9hdHRyaWJ1dGU+CiAgICA8dmFsdWU+ZmF0YWw8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICA8L2NvbXB1dGVyPgogPC9lbGVtZW50cz4KIDxlbGVtZW50cz4KICA8Y29tcHV0ZXI+CiAgIDxuYW1lPmM8L25hbWU+CiAgIDxpbnRlcmZhY2U+CiAgICA8c3Vic3RyYXRlPmxpbmsyPC9zdWJzdHJhdGU+" +
           "CiAgICA8bmFtZT5pbmYwMDA8L25hbWU+CiAgICA8Y2FwYWNpdHk+CiAgICAgPHJhdGU+MTAwMDAwLjAwMDAwMDwvcmF0ZT4KICAgICA8a2luZD5tYXg8L2tpbmQ+CiAgICA8L2NhcGFjaXR5PgogICA8L2ludGVyZmFjZT4KICAgPGludGVyZmFjZT4KICAgIDxzdWJzdHJhdGU+bGluazE8L3N1YnN0cmF0ZT4KICAgIDxuYW1lPmluZjAwMTwvbmFtZT4KICAgIDxjYXBhY2l0eT4KICAgICA8cmF0ZT4xMDAwMDAuMDAwMDAwPC9yYXRlPgogICAgIDxraW5kPm1heDwva2luZD4KICAgIDwvY2FwYWNpdHk+CiAgIDwvaW50ZXJmYWNlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT50eXBlPC9hdHRyaWJ1dGU+CiAgICA8dmFsdWU+cGM8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICAgPGF0dHJpYnV0ZT4KICAgIDxhdHRyaWJ1dGU+dGVzdGJlZDwvYXR0cmlidXRlPgogICAgPHZhbHVlPmRldGVyPC92YWx1ZT4KICAgPC9hdHRyaWJ1dGU+CiAgIDxhdHRyaWJ1dGU+CiAgICA8YXR0cmlidXRlPmZhaWx1cmVhY3Rpb248L2F0dHJpYnV0ZT4KICAgIDx2YWx1ZT5mYXRhbDwvdmFsdWU+CiAgIDwvYXR0cmlidXRlPgogIDwvY29tcHV0ZXI+CiA8L2VsZW1lbnRzPgogPGVsZW1lbnRzPgogIDxyZWdpb24+CiAgICA8bmFtZT5SPC9uYW1lPgogICA8aW50ZXJmYWNlPgogICAgPHN1YnN0cmF0ZT5saW5rMjwvc3Vic3RyYXRlPgogICAgPG5hbWU+aW5mMDAwPC9uYW1lPgogICAgPGNhcGFjaXR5PgogICAgIDxyYXRlPjEwMDAwMC4wMDAwMDA8L3JhdGU+CiAgICAgPGtpbmQ+" +
           "bWF4PC9raW5kPgogICAgPC9jYXBhY2l0eT4KICAgPC9pbnRlcmZhY2U+CiAgIDxpbnRlcmZhY2U+CiAgICA8c3Vic3RyYXRlPmxpbmsxPC9zdWJzdHJhdGU+CiAgICA8bmFtZT5pbmYwMDE8L25hbWU+CiAgICA8Y2FwYWNpdHk+CiAgICAgPHJhdGU+MTAwMDAwLjAwMDAwMDwvcmF0ZT4KICAgICA8a2luZD5tYXg8L2tpbmQ+CiAgICA8L2NhcGFjaXR5PgogICA8L2ludGVyZmFjZT4KICAgIDxsZXZlbD4yPC9sZXZlbD4KICAgIDxmcmFnbmFtZT5mcmFnbWVudDE8L2ZyYWduYW1lPgogIDwvcmVnaW9uPgogPC9lbGVtZW50cz4KIDxmcmFnbWVudHM+CiAgIDxuYW1lPmZyYWdtZW50MTwvbmFtZT4KICA8dG9wb2xvZ3k+CiA8c3Vic3RyYXRlcz4KICA8bmFtZT5saW5rMjwvbmFtZT4KICA8Y2FwYWNpdHk+CiAgIDxyYXRlPjEwMDAwMC4wMDAwMDA8L3JhdGU+CiAgIDxraW5kPm1heDwva2luZD4KICA8L2NhcGFjaXR5PgogPC9zdWJzdHJhdGVzPgogPHN1YnN0cmF0ZXM+CiAgPG5hbWU+bGluazA8L25hbWU+CiAgPGNhcGFjaXR5PgogICA8cmF0ZT4xMDAwMDAuMDAwMDAwPC9yYXRlPgogICA8a2luZD5tYXg8L2tpbmQ+CiAgPC9jYXBhY2l0eT4KIDwvc3Vic3RyYXRlcz4KIDxzdWJzdHJhdGVzPgogIDxuYW1lPmxpbmsxPC9uYW1lPgogIDxjYXBhY2l0eT4KICAgPHJhdGU+MTAwMDAwLjAwMDAwMDwvcmF0ZT4KICAgPGtpbmQ+bWF4PC9raW5kPgogIDwvY2FwYWNpdHk+CiA8L3N1YnN0cmF0ZXM+CiA8ZWxlbWVudHM+" +
           "CiAgPGNvbXB1dGVyPgogICA8bmFtZT5kPC9uYW1lPgogICA8aW50ZXJmYWNlPgogICAgPHN1YnN0cmF0ZT5saW5rMjwvc3Vic3RyYXRlPgogICAgPG5hbWU+aW5mMDAwPC9uYW1lPgogICAgPGNhcGFjaXR5PgogICAgIDxyYXRlPjEwMDAwMC4wMDAwMDA8L3JhdGU+CiAgICAgPGtpbmQ+bWF4PC9raW5kPgogICAgPC9jYXBhY2l0eT4KICAgPC9pbnRlcmZhY2U+CiAgIDxhdHRyaWJ1dGU+CiAgICA8YXR0cmlidXRlPnR5cGU8L2F0dHJpYnV0ZT4KICAgIDx2YWx1ZT5wYzwvdmFsdWU+CiAgIDwvYXR0cmlidXRlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT50ZXN0YmVkPC9hdHRyaWJ1dGU+CiAgICA8dmFsdWU+ZGV0ZXI8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICAgPGF0dHJpYnV0ZT4KICAgIDxhdHRyaWJ1dGU+ZmFpbHVyZWFjdGlvbjwvYXR0cmlidXRlPgogICAgPHZhbHVlPmZhdGFsPC92YWx1ZT4KICAgPC9hdHRyaWJ1dGU+CiAgPC9jb21wdXRlcj4KIDwvZWxlbWVudHM+CiA8ZWxlbWVudHM+CiAgPGNvbXB1dGVyPgogICA8bmFtZT5hPC9uYW1lPgogICA8aW50ZXJmYWNlPgogICAgPHN1YnN0cmF0ZT5saW5rMDwvc3Vic3RyYXRlPgogICAgPG5hbWU+aW5mMDAwPC9uYW1lPgogICAgPGNhcGFjaXR5PgogICAgIDxyYXRlPjEwMDAwMC4wMDAwMDA8L3JhdGU+CiAgICAgPGtpbmQ+bWF4PC9raW5kPgogICAgPC9jYXBhY2l0eT4KICAgPC9pbnRlcmZhY2U+CiAgIDxhdHRyaWJ1dGU+" +
           "CiAgICA8YXR0cmlidXRlPnR5cGU8L2F0dHJpYnV0ZT4KICAgIDx2YWx1ZT5wYzwvdmFsdWU+CiAgIDwvYXR0cmlidXRlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT50ZXN0YmVkPC9hdHRyaWJ1dGU+CiAgICA8dmFsdWU+ZGVza3RvcDwvdmFsdWU+CiAgIDwvYXR0cmlidXRlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT5mYWlsdXJlYWN0aW9uPC9hdHRyaWJ1dGU+CiAgICA8dmFsdWU+ZmF0YWw8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICA8L2NvbXB1dGVyPgogPC9lbGVtZW50cz4KIDxlbGVtZW50cz4KICA8Y29tcHV0ZXI+CiAgIDxuYW1lPmI8L25hbWU+CiAgIDxpbnRlcmZhY2U+CiAgICA8c3Vic3RyYXRlPmxpbmswPC9zdWJzdHJhdGU+CiAgICA8bmFtZT5pbmYwMDA8L25hbWU+CiAgICA8Y2FwYWNpdHk+CiAgICAgPHJhdGU+MTAwMDAwLjAwMDAwMDwvcmF0ZT4KICAgICA8a2luZD5tYXg8L2tpbmQ+CiAgICA8L2NhcGFjaXR5PgogICA8L2ludGVyZmFjZT4KICAgPGludGVyZmFjZT4KICAgIDxzdWJzdHJhdGU+bGluazE8L3N1YnN0cmF0ZT4KICAgIDxuYW1lPmluZjAwMTwvbmFtZT4KICAgIDxjYXBhY2l0eT4KICAgICA8cmF0ZT4xMDAwMDAuMDAwMDAwPC9yYXRlPgogICAgIDxraW5kPm1heDwva2luZD4KICAgIDwvY2FwYWNpdHk+CiAgIDwvaW50ZXJmYWNlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT50eXBlPC9hdHRyaWJ1dGU+CiAgICA8dmFsdWU+" +
           "cGM8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICAgPGF0dHJpYnV0ZT4KICAgIDxhdHRyaWJ1dGU+dGVzdGJlZDwvYXR0cmlidXRlPgogICAgPHZhbHVlPmRldGVyPC92YWx1ZT4KICAgPC9hdHRyaWJ1dGU+CiAgIDxhdHRyaWJ1dGU+CiAgICA8YXR0cmlidXRlPmZhaWx1cmVhY3Rpb248L2F0dHJpYnV0ZT4KICAgIDx2YWx1ZT5mYXRhbDwvdmFsdWU+CiAgIDwvYXR0cmlidXRlPgogIDwvY29tcHV0ZXI+CiA8L2VsZW1lbnRzPgogPGVsZW1lbnRzPgogIDxjb21wdXRlcj4KICAgPG5hbWU+YzwvbmFtZT4KICAgPGludGVyZmFjZT4KICAgIDxzdWJzdHJhdGU+bGluazI8L3N1YnN0cmF0ZT4KICAgIDxuYW1lPmluZjAwMDwvbmFtZT4KICAgIDxjYXBhY2l0eT4KICAgICA8cmF0ZT4xMDAwMDAuMDAwMDAwPC9yYXRlPgogICAgIDxraW5kPm1heDwva2luZD4KICAgIDwvY2FwYWNpdHk+CiAgIDwvaW50ZXJmYWNlPgogICA8aW50ZXJmYWNlPgogICAgPHN1YnN0cmF0ZT5saW5rMTwvc3Vic3RyYXRlPgogICAgPG5hbWU+aW5mMDAxPC9uYW1lPgogICAgPGNhcGFjaXR5PgogICAgIDxyYXRlPjEwMDAwMC4wMDAwMDA8L3JhdGU+CiAgICAgPGtpbmQ+bWF4PC9raW5kPgogICAgPC9jYXBhY2l0eT4KICAgPC9pbnRlcmZhY2U+CiAgIDxhdHRyaWJ1dGU+CiAgICA8YXR0cmlidXRlPnR5cGU8L2F0dHJpYnV0ZT4KICAgIDx2YWx1ZT5wYzwvdmFsdWU+" +
           "CiAgIDwvYXR0cmlidXRlPgogICA8YXR0cmlidXRlPgogICAgPGF0dHJpYnV0ZT50ZXN0YmVkPC9hdHRyaWJ1dGU+CiAgICA8dmFsdWU+ZGV0ZXI8L3ZhbHVlPgogICA8L2F0dHJpYnV0ZT4KICAgPGF0dHJpYnV0ZT4KICAgIDxhdHRyaWJ1dGU+ZmFpbHVyZWFjdGlvbjwvYXR0cmlidXRlPgogICAgPHZhbHVlPmZhdGFsPC92YWx1ZT4KICAgPC9hdHRyaWJ1dGU+CiA8L2NvbXB1dGVyPgo8L2VsZW1lbnRzPgo8ZWxlbWVudHM+CiAgPHJlZ2lvbj4KICAgIDxuYW1lPlI8L25hbWU+CiAgIDxpbnRlcmZhY2U+CiAgICA8c3Vic3RyYXRlPmxpbmsyPC9zdWJzdHJhdGU+CiAgICA8bmFtZT5pbmYwMDA8L25hbWU+CiAgICA8Y2FwYWNpdHk+CiAgICAgPHJhdGU+MTAwMDAwLjAwMDAwMDwvcmF0ZT4KICAgICA8a2luZD5tYXg8L2tpbmQ+CiAgICA8L2NhcGFjaXR5PgogICA8L2ludGVyZmFjZT4KICAgPGludGVyZmFjZT4KICAgIDxzdWJzdHJhdGU+bGluazE8L3N1YnN0cmF0ZT4KICAgIDxuYW1lPmluZjAwMTwvbmFtZT4KICAgIDxjYXBhY2l0eT4KICAgICA8cmF0ZT4xMDAwMDAuMDAwMDAwPC9yYXRlPgogICAgIDxraW5kPm1heDwva2luZD4KICAgIDwvY2FwYWNpdHk+CiAgIDwvaW50ZXJmYWNlPgogICAgPGxldmVsPjI8L2xldmVsPgogICAgPGZyYWduYW1lPmZyYWdtZW50MTwvZnJhZ25hbWU+CiAgPC9yZWdpb24+CjwvZWxlbWVudHM+CjwvdG9wb2xvZ3k+" +
           "CjxpZm1hcD48aW5uZXI+YTwvaW5uZXI+PG91dGVyPmluZjAwMDwvb3V0ZXI+PC9pZm1hcD4KPGlmbWFwPjxpbm5lcj5kPC9pbm5lcj48b3V0ZXI+aW5mMDAxPC9vdXRlcj48L2lmbWFwPgo8L2ZyYWdtZW50cz4KPC9leHBlcmltZW50Pgo="

  test "getting experiments" do
    VCR.use_cassette "deterlab/experiments/view-experiments" do
      login

      create_experiment
      list = view_experiments
      remove_experiment

      assert_equal [
        Experiment.new("SPIdev:Test", @username, [
          ExperimentACL.new("SPIdev:SPIdev", [ "MODIFY_EXPERIMENT_ACCESS", "READ_EXPERIMENT", "MODIFY_EXPERIMENT" ]),
          ExperimentACL.new("bfdh:bfdh", [ "MODIFY_EXPERIMENT_ACCESS", "READ_EXPERIMENT", "MODIFY_EXPERIMENT" ])
        ], [])
      ], list
    end
  end

  test "experiment profile" do
    VCR.use_cassette "deterlab/experiments/experiment-profile" do
      login

      create_experiment
      profile = DeterLab.get_experiment_profile(@username, "SPIdev:Test")
      remove_experiment

      assert_equal [
        ProfileField.new("description", "string", false, "READ_WRITE", "Description", nil, nil, "0", "Custom description")
      ], profile
    end
  end

  # test "getting experiments for a certain project" do
  #   VCR.use_cassette "deterlab/experiments/view-experiments-for-project" do
  #     login 'user_with_multiple_projects'
  #     list = view_experiments("Bravo")
  #     assert_equal [ 'Bravo:BCone' ], list.map(&:id), "No filtering by experiment name"
  #   end
  # end

  # test "getting experiment with aspects" do
  #   VCR.use_cassette "deterlab/experiments/view-experiment-aspects" do
  #     login 'user_with_aspects'
  #   end
  # end

  test "creating experiments" do
    VCR.use_cassette "deterlab/experiments/create-experiment" do
      login

      pid   = "SPIdev"
      ename = "Test"
      eid   = "#{pid}:#{ename}"

      assert create_experiment(pid, ename), "Could not create an experiment"
      experiment = view_experiments(pid).find { |e| e.id == eid }
      assert remove_experiment(pid, ename), "Could not delete the experiment"
      assert experiment, "Experiment was added, but was not found"
    end
  end

  test "creating user experiments" do
    VCR.use_cassette "deterlab/experiments/create-experiment-user" do
      login

      eid = "UserExperiment"
      assert DeterLab.create_experiment(@username, @username, eid, { description: "Custom description" })

      ex = DeterLab.view_experiments(@username).find { |e| e.id == "#{@username}:#{eid}" }
      assert_not_nil ex
    end
  end

  test "getting experiments profile description" do
    VCR.use_cassette "deterlab/experiments/get-profile-description" do
      fields = DeterLab.get_experiment_profile_description
      assert_equal [ ProfileField.new("description", "string", false, "READ_WRITE", "Description", nil, nil, "0", nil) ], fields
    end
  end

  test "adding aspects to expeiment" do
    VCR.use_cassette "deterlab/experiments/add-experiment-aspects" do
      login
      assert create_experiment("SPIdev", "TestAspects3"), "Could not create an experiment"
      res = DeterLab.add_experiment_aspects(@username, "SPIdev:TestAspects3", [ { type: 'layout', data: LAYOUT } ])
      assert_equal "layout000", res.first[:name]
    end
  end

  test "removing aspects from experiment" do
    VCR.use_cassette "deterlab/experiments/remove-experiment-aspects" do
      eid = "TestAspects12"

      login
      assert create_experiment("SPIdev", eid), "Could not create an experiment"

      res = DeterLab.add_experiment_aspects(@username, "SPIdev:#{eid}", [ { type: 'layout', data: LAYOUT } ])
      aspect = res.find { |a| a[:name] !~ %r{.*/.*} }

      res = DeterLab.remove_experiment_aspects(@username, "SPIdev:#{eid}", [ { name: aspect[:name], type: 'layout' } ])
      assert_equal({
        "layout000"                    => true,
        "layout000/full_layout"        => true,
        "layout000/fragment/fragment1" => true,
        "layout000/namemap/R/R-0"      => true,
        "layout000/namemap/R"          => true,
        "layout000/minimal_layout"     => true
      }, res)
    end
  end

  test "run experiment" do
    VCR.use_cassette "deterlab/experiments/run-experiment" do
      login

      assert_raise DeterLab::RequestError do
        DeterLab.realize_experiment(@username, @username, "SPIdev:TestAspects4")
      end
    end
  end

  test "change experiment ACL" do
    VCR.use_cassette "deterlab/experiments/change-experiment-acl" do
      login
      eid = "TestChangeACL4"

      assert create_experiment("SPIdev", eid), "Could not create an experiment"

      # add addams
      assert_equal({
        "aadams:aadams"               => true
      }, DeterLab.change_experiment_acl(@username, "SPIdev:#{eid}", [
        ExperimentACL.new("aadams:aadams", [ "MODIFY_EXPERIMENT_ACCESS", "READ_EXPERIMENT", "MODIFY_EXPERIMENT" ])
      ]))

      # add bberkley, update SPIdev group, remove owner
      assert_equal({
        "bberkley:bberkley"           => true,
        "SPIdev:SPIdev"               => true,
        "#{@username}:#{@username}"   => true
      }, DeterLab.change_experiment_acl(@username, "SPIdev:#{eid}", [
        ExperimentACL.new("bberkley:bberkley", [ "MODIFY_EXPERIMENT_ACCESS", "READ_EXPERIMENT", "MODIFY_EXPERIMENT" ]),
        ExperimentACL.new("SPIdev:SPIdev", [ "READ_EXPERIMENT", "MODIFY_EXPERIMENT" ]),
        ExperimentACL.new("#{@username}:#{@username}", [])
      ]))

      acl = DeterLab.view_experiments(@username, regex: "^SPIdev:#{eid}$").first.acl.map(&:circle_id)
      assert_equal [ "bberkley:bberkley", "SPIdev:SPIdev", "aadams:aadams" ], acl
    end
  end

  # test "updating aspect" do
  #   VCR.use_cassette "deterlab/experiments/change-experiment-aspects" do
  #     ename = "TestAspects17"

  #     login
  #     assert create_experiment("SPIdev", ename), "Could not create an experiment"

  #     eid = "SPIdev:#{ename}"
  #     DeterLab.add_experiment_aspects(@username, eid, [ { type: 'layout', data: LAYOUT } ])

  #     ex = DeterLab.view_experiments(@username).find { |e| e.id == eid }
  #     aspects = ex.aspects

  #     ex.aspects.find { |a| a.name == "layout000" }.raw_data = "new_data"

  #     # res = DeterLab.change_experiment_aspects(@username, eid, ex.aspects)
  #     # puts res.inspect

  #     res = DeterLab.remove_experiment_aspects(@username, eid, [ { name: aspect[:name], type: 'layout' } ])
  #   end
  # end

  private

  def create_experiment(pid = "SPIdev", eid = "Test")
    DeterLab.create_experiment(@username, pid, eid, { description: "Custom description" })
  end

  def remove_experiment(pid = "SPIdev", eid = "Test")
    DeterLab.remove_experiment(@username, "#{pid}:#{eid}")
  end

  def view_experiments(pid = "SPIdev")
    DeterLab.view_experiments(@username, project_id: "SPIdev")
  end

end
