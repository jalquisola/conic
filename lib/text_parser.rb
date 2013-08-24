module TextParser
  class << self
    def identify(text)
      str = text.split(" ")
      case str.first
      when "DMYL"
        return "Dailymile"
      else
        raise ExceptionError
      end
    end
  end
end
