module Db
  class LogStyle < GScript::GsBase
    GScript::GsLog.add_style(:send_money, :succeed,
                             :requires => [:from, :to, :much]) {|actor, args|
      f, t, m = args[:from], args[:to], args[:much]
      case actor
      when f
        "#{t}へ#{m}円の送金をしました．"
      when t
        "#{f}から#{m}円を受け取りました．"
      else
        "#{f}から#{t}へ#{m}の送金．"
      end
    }
    GScript::GsLog.add_style(:send_money, :canceled,
                             :requires => [:from, :to, :much]) {|actor, args|
      f, t, m = args[:from], args[:to], args[:much]
      case actor
      when f
        "#{t}への#{m}円の送金は拒否されました．"
      when t
        "#{f}からの#{m}円の送金を拒否しました．"
      else
        "#{f}から#{t}へ#{m}の送金は行われませんでした．．"
      end
    }
    GScript::GsLog.add_style(:auto_log, :succeed) {|actor, args|
      "神様降臨"
    }
  end
end

