module Waluigi
	module Task
		def self.included(task)
			Launcher.instance.tasks << task
			task.instance_variable_set :@ctx, HelperCtx.new
			task.extend TaskDefinitionHelper
			task.send :include, TaskHelper
		end
	end
end