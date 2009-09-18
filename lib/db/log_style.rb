module Db
  class LogStyle < GScript::GsBase
    GScript::GsLog.add_style(:send_money, :succeed,
                             :requires => [:from, :to, :much]) {|actor, args|
      f, t, m = args[:from], args[:to], args[:much]
      case actor
      when f
        "#{t}へ#{m}の送金．"
      when t
        "#{f}から#{m}の送金．"
      else
        "#{f}から#{t}へ#{m}の送金．"
      end
    }
    GScript::GsLog.add_style(:auto_log, :succeed) {|actor, args|
      "神様降臨"
    }
  end
end

