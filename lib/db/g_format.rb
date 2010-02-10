module Db
	class GFormat < GScript::GsBase
		attr_reader :result

		def initialize(fmt, args = {})
			@args = args
			@format = fmt
			@result = self.send(fmt)
		end

		private
		def updown
			item, diff = _get_args(:item, :diff)
			# <actor>の<item>が<diff>{増加｜減少}しました
			sprintf("%sの%sが%s%sしました",
							item.actor.name, item.name, diff.abs,
							diff < 0 ? '減少' : '増加')
		end
		def _get_args(*args)
			args.map do |a|
				unless @args[a]
					raise GScript::RuleError, _e("GFormat '#{@format} requires argument '#{a}'")
				end
				@args[a]
			end
		end
	end
end
