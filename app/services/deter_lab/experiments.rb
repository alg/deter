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

    # creates an experiment
    def create_experiment(project_id, name, uid, description, owner = uid)
      cl = client("Experiments", uid)
      response = cl.call(:create_experiment, message: {
        eid: "#{project_id}:#{name}",
        owner: owner,
        accessLists: [
          { circleId: "#{project_id}:#{project_id}", permissions: 'ALL_PERMS' },
          { circleId: "#{owner}:#{owner}", permissions: 'ALL_PERMS' }
        ],
        profile: [
          { name: 'description', value: description }
        ]
      })

      return response.to_hash[:create_experiment_response][:return]
    rescue Savon::SOAPFault => e
      process_error e
    end

    # deletes an experiment
    def delete_experiment(name, uid)
      cl = client("Experiments", uid)
      response = cl.call(:remove_experiment, message: {
        eid: name
      })

      return response.to_hash[:remove_experiment_response][:return]
    rescue Savon::SOAPFault => e
      process_error e
    end

  end
end
