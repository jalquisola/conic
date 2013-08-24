module Dailymile
  class << self
    #text format: activity_type  distance time feeling message
    def create_entry(text)
      split_str = text.split(" ")

      text.downcase!
      activity_type = get_activity_type(text)

      if activity_type == "fitness"
        message = get_message(text, activity_type)
        entry = {"message" => message, #split_str.slice(3, split_str.length).join(" "),
                 "workout" => {
                   "activity_type" => activity_type,
                   "duration" => get_duration(text),
                   "felt" => get_felt(text),
                   "completed_at" => Time.now
                 }
        }
      else
        message = get_message(text, activity_type)
        entry = {"message" => message, #split_str.slice(4, split_str.length).join(" "),
                 "workout" => {
                   "activity_type" => activity_type,
                   "distance" => get_distance(text),
                   "duration" => get_duration(text),
                   "felt" => get_felt(text),
                   "completed_at" => Time.now
                 }
        }
      end

    end

    protected
    def get_message(text, activity)
      case activity
      when "fitness"
        text.gsub(/^.*\s[0-9]*\.?[0-9]+(hr|min|sec)s?\s?(great|good|alright|blah|tired|injured)?\s?/, "")
      else
        text.gsub(/^.*\s[0-9]*\.?[0-9]+(km|mil|m|ft|)s?.?[0-9]*\.?[0-9]+(hr|min|sec)s?\s(great|good|alright|blah|tired|injured)?\s?/, "")
      end
      #text.gsub(/^.*\s[0-9]*\.?[0-9]+(km|mi|m|ft|)s?.[0-9]*\.?[0-9]+(hr|min|sec)s?\s(great|good|alright|blah|tired|injured)?\s?/, "")
    end

    def get_activity_type(text)
      if text.match(/(run|running)/)
        "running"
      elsif text.match(/(cycling|bike|biking)/)
        "cycling"
      elsif text.match(/(swim|swimming)/)
        "swimming"
      elsif text.match(/(walk|walking)/)
        "walking"
      else
        "fitness"
      end
    end

    def get_felt(text)
      match = text.match(/(good|great|alright|blah|tired|injured)/)
      if match
        felt = match.values_at(1).to_s
      end

      ["great", "good", "alright", "blah", "tired", "injured"].include?(felt) ? felt : "good"
    end

    def get_distance(text)
      distance = {"value" => 0, "units" => "kilometers"}

      if reg = text.match(/([0-9]*\.[0-9]+|[0-9]+)km/)
        distance["value"] = reg.values_at(1).first
        distance["units"] = "kilometers"
      elsif reg = text.match(/([0-9]*\.[0-9]+|[0-9]+)mil/)
        distance["value"] = reg.values_at(1).first
        distance["units"] = "miles"
      elsif reg = text.match(/([0-9]*\.[0-9]+|[0-9]+)ms?\s?/)
        distance["value"] = reg.values_at(1).first
        distance["units"] = "meters"
      elsif reg = text.match(/([0-9]*\.[0-9]+|[0-9]+)yards/)
        distance["value"] = reg.values_at(1).first
        distance["units"] = "yards"
      end
      puts text.inspect
      puts reg.inspect

      distance
    end

    def get_duration(text)
      duration = 0
      if reg = text.match(/([0-9]*\.[0-9]+|[0-9]+)hr/)
        if reg && (value = reg.values_at(1))
          duration += value.first.to_f * 3600
        end
      end

      text = text.gsub(/([0-9]*\.[0-9]+|[0-9]+)(hr|hrs)/, "")
      if reg = text.match(/([0-9]*\.[0-9]+|[0-9]+)min/)
        if reg && (value = reg.values_at(1))
          duration += value.first.to_f * 60
        end
      end

      duration
    end

  end
end
