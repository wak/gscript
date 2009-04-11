# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def myh(s)
    h(s).gsub(/ |\n|\t/) {|matched|
      case matched
      when ' ': '&nbsp;'
      when "\n": '<br>'
      when "\t": ' '*4
      end
    }
  end
end
