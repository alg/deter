module DeterLab
  module Experiments

    # Returns the list of user experiments
    def get_user_experiments(uid)
      cl = client("Experiments", uid)
      response = cl.call(:view_experiments, "message" => { "uid" => uid, "listOnly" => true })
      raise Error unless response.success?

      return [response.to_hash[:view_experiments_response][:return] || []].flatten.map do |ex|
        acl = [ex[:acl] || []].flatten.map do |a|
          ExperimentACL.new(a[:circle_id], a[:permissions])
        end

        Experiment.new(ex[:experiment_id], ex[:owner], acl)
      end
    rescue Savon::SOAPFault => e
      process_error e
    end

  end
end
