require 'pycall/import'
include PyCall::Import

pyimport :sys
sys.path << '.'

module Waluigi
	@@tasks = []

	def self.run(*args)
		@@tasks.each { |task| Waluigi.register_facade task }

		pyimport :luigi
		luigi.run(args)
	end

	module TaskHelper
		def output
			@python_obj.output
		end

		def input
			@python_obj.input
		end

		def method_missing(m, *_args, **_kwargs, &_block)
			@python_obj.send m	
		end
	end

	module Task
		def self.included(task)
			Waluigi.register_task task
			task.instance_variable_set :@ctx, HelperCtx.new
			m = Waluigi.create_helper_module
			task.extend m
			task.send :include, TaskHelper
		end
	end

	class HelperCtx
		attr_reader :outputs, :requirements, :luigi, :parameters
		def initialize
			@outputs = []
			@requirements = []
			@parameters = []
			@luigi = PyCall.import_module 'luigi'
		end
	end

	class RubyTaskRequirement
		def initialize(task, args, kwargs)
			@task = task
			@args = args
			@kwargs = kwargs
		end

		def build
			pyimport :waluigi
			waluigi.tasks[@task].new(*@args, **@kwargs)
		end
	end

	class RubyTaskParameter
		attr_reader :name, :type, :kwargs

		def initialize(name, type, kwargs)
			@name = name
			@type = type
			@kwargs = kwargs
		end
	end

	private 
	def self.create_helper_module
		Module.new do
			def output(o)
				@ctx.outputs << o
			end

			def requires(r)
				@ctx.requirements << r
			end

			def defined_outputs
				@ctx.outputs
			end

			def parameter(name, type:nil, **kwargs)
				@ctx.parameters << RubyTaskParameter.new(name, type, kwargs)
			end

			def defined_parameters
				pyimport :luigi
				@ctx.parameters.map do |param|
					if param.is_a? RubyTaskParameter
						t = if param.type then param.type else luigi.Parameter end
						[param.name, t.new(**param.kwargs)]
					else
						param
					end
				end
			end

			def defined_requirements
				@ctx.requirements.map do |req|
					if req.is_a? RubyTaskRequirement
						req.build
					elsif req.included_modules.include? Waluigi::Task # FIXME
						RubyTaskRequirement.new(req.name).build
					else
						req
					end
				end
			end

			def luigi
				@ctx.luigi
			end

			def build(*args, **kwargs)
				RubyTaskRequirement.new(name, args, kwargs)
			end
		end
	end

	def	self.register_task(task)
		@@tasks << task
	end

	def self.register_facade(task)
		pyimport :waluigi
		waluigi.register_task_facade task.new, task.name
	end
end

