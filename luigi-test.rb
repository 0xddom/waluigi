require_relative 'waluigi'

class MyOtherTask
	include Waluigi::Task

	def complete
		true
	end
end

class MyTask
	include Waluigi::Task

	requires MyOtherTask.build
	output luigi.LocalTarget.new './testfile'

	def run
		puts "-" * 50
		puts "Running a waluigi task"
		puts "-" * 50
	end
end

Waluigi.run "MyTask", "--local-scheduler"