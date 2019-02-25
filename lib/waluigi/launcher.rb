module Waluigi
	class Launcher
		include Singleton

		attr_reader :tasks, :luigi, :waluigi

		def initialize
			@tasks = []
		end

		def run args
			tasks.each { |task| register_facade task }
			Waluigi::Python::Luigi.run(args)
		end

		private def register_facade task
			Waluigi::Python::WaluigiFacade.register_task_facade task.new, task.name
		end
	end
end