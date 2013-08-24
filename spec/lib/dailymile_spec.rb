require "spec_helper"
require "dailymile"

describe Dailymile, "create_msg"  do
  it "returns json message for dailymile api - run" do
    s = Dailymile.create_entry("run 2km 15mins good sample message")
    s["message"].should eq("sample message")
    s["workout"]["activity_type"].should eq("running")
    s["workout"]["completed_at"].to_date.should eq(Time.now.to_date)
    s["workout"]["distance"]["value"].should eq("2")
    s["workout"]["distance"]["units"].should eq("kilometers")
    s["workout"]["duration"].should eq(15*60)
    s["workout"]["felt"].should eq("good")
  end

  it "returns json message for dailymile api - walk" do
    s = Dailymile.create_entry("walk 100m 1min sample message")
    s["message"].should eq("sample message")
    s["workout"]["activity_type"].should eq("walking")
    s["workout"]["completed_at"].to_date.should eq(Time.now.to_date)
    s["workout"]["distance"]["value"].should eq("100")
    s["workout"]["distance"]["units"].should eq("meters")
    s["workout"]["duration"].should eq(60)
    s["workout"]["felt"].should eq("good")
  end

  it "returns json message for dailymile api - cycling" do
    s = Dailymile.create_entry("BIKE 1mil 1min sample message")
    s["message"].should eq("sample message")
    s["workout"]["activity_type"].should eq("cycling")
    s["workout"]["completed_at"].to_date.should eq(Time.now.to_date)
    s["workout"]["distance"]["value"].should eq("1")
    s["workout"]["distance"]["units"].should eq("miles")
    s["workout"]["duration"].should eq(60)
    s["workout"]["felt"].should eq("good")
  end

  it "returns json message for dailymile api - swimming" do
    s = Dailymile.create_entry("Swim 4.5km 2.1hrs sample message")
    s["message"].should eq("sample message")
    s["workout"]["activity_type"].should eq("swimming")
    s["workout"]["completed_at"].to_date.should eq(Time.now.to_date)
    s["workout"]["distance"]["value"].should eq("4.5")
    s["workout"]["distance"]["units"].should eq("kilometers")
    s["workout"]["duration"].should eq(2.1*3600)
    s["workout"]["felt"].should eq("good")
  end

  it "returns json message for dailymile api - fitness" do
    s = Dailymile.create_entry("FIT 2.1hrs sample message")
    s["message"].should eq("sample message")
    s["workout"]["activity_type"].should eq("fitness")
    s["workout"]["completed_at"].to_date.should eq(Time.now.to_date)
    s["workout"]["distance"].should eq(nil)
    s["workout"]["duration"].should eq(2.1*3600.0)
    s["workout"]["felt"].should eq("good")
  end

  it "returns json message for dailymile api - float duration" do
    s = Dailymile.create_entry("RUN 21.5km 2.5hrs sample message")
    s["message"].should eq("sample message")
    s["workout"]["activity_type"].should eq("running")
    s["workout"]["completed_at"].to_date.should eq(Time.now.to_date)
    s["workout"]["distance"]["value"].should eq("21.5")
    s["workout"]["distance"]["units"].should eq("kilometers")
    s["workout"]["duration"].should eq(2.5*3600)
    s["workout"]["felt"].should eq("good")
  end

  # format: RUN 1km/10min good message
  it "returns json message for dailymile api - short format" do
    s = Dailymile.create_entry("RUN 1km/10min good message")
    s["message"].should eq("message")
    s["workout"]["activity_type"].should eq("running")
    s["workout"]["completed_at"].to_date.should eq(Time.now.to_date)
    s["workout"]["distance"]["value"].should eq("1")
    s["workout"]["distance"]["units"].should eq("kilometers")
    s["workout"]["duration"].should eq(10*60)
    s["workout"]["felt"].should eq("good")
  end

  # format: RUN 1km/10min good message
  it "returns json message for dailymile api - short format" do
    s = Dailymile.create_entry("RUN 1mil/10min good message")
    s["message"].should eq("message")
    s["workout"]["activity_type"].should eq("running")
    s["workout"]["completed_at"].to_date.should eq(Time.now.to_date)
    s["workout"]["distance"]["value"].should eq("1")
    s["workout"]["distance"]["units"].should eq("miles")
    s["workout"]["duration"].should eq(10*60)
    s["workout"]["felt"].should eq("good")
  end
end
