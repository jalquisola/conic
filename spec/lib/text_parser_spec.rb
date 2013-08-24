require "spec_helper"
require "text_parser"

describe TextParser, "identify"  do
  it "returns Dailymile for DMYL" do
    s = TextParser.identify("DMYL run 2km 15mins good")
    s.should eq("Dailymile")
  end

  it "returns Dailymile for DMYL" do
    s = TextParser.identify("DMYL run 2km 15mins good")
    s.should eq("Dailymile")
  end
end
