module Waluigi
	module Python
		require 'pycall/import'
		Luigi = PyCall.import_module('luigi')
		WaluigiFacade = PyCall.import_module('waluigi_facade')
	end

	require 'waluigi/helpers'
	require 'waluigi/task'
	require 'waluigi/launcher'

	def self.run *args
		Waluigi::Launcher.instance.run args
	end
end