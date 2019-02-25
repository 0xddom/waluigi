require_relative 'waluigi'

class MyOtherTask
	include Waluigi::Task

	def complete
		true
	end
end

class MyTask
	include Waluigi::Task

	parameter :msg, default: "Running a waluigi task"

	requires MyOtherTask.build
	output luigi.LocalTarget.new './testfile'

	def run
		puts "-" * 50
		puts "Message: #{msg}"
		f = output.open 'w'
		f.write msg
		f.close
		puts "-" * 50
	end
end

Waluigi.run "MyTask", "--local-scheduler"