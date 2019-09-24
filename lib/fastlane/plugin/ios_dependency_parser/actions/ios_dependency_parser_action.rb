# require 'versionomy'
require 'fastlane/action'
require_relative '../helper/ios_dependency_parser_helper'
require_relative '../helper/pod'

module Fastlane
	module Actions
		module SharedValues
			POD_ANALYZER_RESULTS = :POD_ANALYZER_RESULTS
		end
		class ParsePodDependenciesAction < Action
			def self.run(params)
				if !File.exists?("Podfile")
					UI.user_error!("Couldn't find Podfile in active path")
				else
					executor = FastlaneCore::CommandExecutor
					UI.message("Collecting data about your pods, this may take a while... (running 'pod outdated')")
					pod_outdated_results = executor.execute(command: "pod outdated",
						print_all: false,
					print_command: false)

					pod_results = []
					pod_version_regex = '- (?<pod_name>\S*) (?<current_version>\S*) -> (?<update_version>\S*) \(latest version (?<latest>\S*)\)'
					pod_outdated_results.each_line do |line|
						line_match = line.match(pod_version_regex)
						if line_match && line_match.captures
							pod_name = line_match.captures[0]
							current_version = line_match.captures[1]
							update_version = line_match.captures[2]
							latest = line_match.captures[3]
							pod = Pod.new(pod_name,current_version,update_version, latest)
							pod_results.push(pod)
						end
					end

					Actions.lane_context[SharedValues::POD_ANALYZER_RESULTS] = pod_results if pod_results
				end
			end

			def self.description
				"Analyzes 'pod outdated' results and structures it for further usage."
			end

			def self.authors
				["kochavi-daniel"]
			end

			def self.return_value

			end

			def self.details
				"This plugin will run 'pod outdated' and will parse its results into an array of Pod(s) which could later be used in your script"
			end

			def self.available_options
				[]
			end

			def self.is_supported?(platform)
				platform == :ios
			end
		end
	end
end
