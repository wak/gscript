module GScript::GsAction
	class SimpleAction < GenericAction
    def setup; end
    def setup_apply; end

		def set_apply(input_actor, input_name, data)
			@apply ||= []
			@apply << {
				:actor => input_actor, :input => input_name, :data => data
			}
		end
		def start
			setup
			do_input
			@status.change(:input, :method => :apply)
		end
		def apply
      setup_apply
			@apply.each {|apply|
				if apply[:actor]
					actor = get_input(apply[:actor])
				else
					actor = @current
				end
				data  = apply[:data][get_input(apply[:input])]

				unless data
					raise GScript::RuleError, "Data not found"
				end
				data.each {|item, value|
					actor.item(item).value += value
					#_d gformat(:updown, :item => actor.item(item), :diff => value)
				}
			}
			@status.change(:finish)
		end
	end
end
