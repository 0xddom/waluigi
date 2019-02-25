module Waluigi
	module TaskHelper
		def output
			@python_obj.output
		end

		def input
			@python_obj.input
		end

		def method_missing m, *_args, **_kwards, &_block
			@python_obj.send m
		end
	end

	module TaskDefinitionHelper
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
					t = if param.type
						param.type 
					else 
						luigi.Parameter 
					end
					[param.name, t.new(**param.kwargs)]
				else
					[param.name, param]
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

		def build(*args, **kwargs)
			RubyTaskRequirement.new(name, args, kwargs)
		end
	end

	class HelperCtx
		attr_reader :outputs, :requirements, :parameters

		def initialize
			@outputs = []
			@requirements = []
			@parameters = []
		end
	end

	class RubyTaskRequirement
		def initialize(task, args, kwargs)
			@task = task
			@args = args
			@kwargs = kwargs
		end

		def build
			Waluigi::Python::WaluigiFacade.tasks[@task].new *@args, **@kwargs
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
end