require_relative '../dayThree/three'

RSpec.describe DayThree do
  context "daythree" do
    it "Should return Correct data" do
      wire_one = 'R8,U5,L5,D3'
      wire_two = 'U7,R6,D4,L4'
      d = DayThree.new(wire_one, wire_two)
      x = d.run
      expect(x[:p1]).to eq 6
    end
  end
end