require 'board'

describe Board do
  let(:horizontal_ship) { double :ship, size: 4, direction: :H, gets_got: nil, has_sunk?: nil }
  let(:vertical_ship) { double :ship, size: 4, direction: :V, gets_got: nil, has_sunk?: nil }
  let(:small_ship) { double :ship, size: 2, direction: :H, gets_got: nil, has_sunk?: nil }

  it 'has place_ship method' do
    expect(subject).to respond_to :place_ship
  end

  describe '#place_ship' do
    it 'takes a ship' do
      expect(subject).to respond_to(:place_ship).with(2).argument
    end

    it 'doesn\'t let physical location go off board' do
      expect { subject.place_ship(horizontal_ship, 'A10') }.to raise_error 'Location not on board'
    end

    it "doesn't let ships overlap" do
      subject.place_ship(horizontal_ship, 'A1')
      expect { subject.place_ship(horizontal_ship, 'A2') }.to raise_error 'Overlap'
    end

    it 'places a ship on the board' do
      subject.place_ship(horizontal_ship, 'A1')
      expect(subject.ships.keys.include?(horizontal_ship)).to be true
    end

    it 'should generate cell locations from start point horizontally' do
      subject.place_ship(horizontal_ship, 'A1')
      expect(subject.ships.values.include?(['A1','A2','A3','A4'])).to be true
    end

    it 'should generate cell location from start point vertically' do
      subject.place_ship(vertical_ship, 'A1')
      expect(subject.ships.values.include?(['A1', 'B1', 'C1', 'D1'])).to be true
    end
  end

  it 'has a fire method' do
    expect(subject).to respond_to :fire
  end

  describe '#fire' do
    it 'has a position as an argument' do
      expect(subject).to respond_to(:fire).with(1).argument
    end

    it "returns 'Miss!' if a ship doesn't exist at that location" do
      subject.place_ship(horizontal_ship, 'A1')
      expect(subject.fire('B2')).to eq 'Miss!'
    end

    it "returns 'HIT!' if a ship does exist at that location" do
      subject.place_ship(horizontal_ship, 'A1')
      expect(subject.fire('A1')).to eq 'HIT!'
    end

    it "should record hits" do
      subject.place_ship(horizontal_ship, "A1")
      subject.fire("A1")
      expect(subject.recorded_shots).to include "A1" => "H"
    end

    it "should record misses" do
      subject.fire("A1")
      expect(subject.recorded_shots).to include "A1" => "M"
    end

    it "should only be able to hit cell once" do
      subject.fire("A1")
      expect(subject.fire("A1")).to eq "Location already targeted."
    end

    xit "should announce ship sinkings" do
      subject.place_ship(small_ship, "A1")
      subject.fire("A1")
      allow(small_ship).to receive(:has_sunk) { true }
      expect(subject.fire("A2")).to eq "You sunk my battleship!"
    end

    xit "should remove sunk ships from board" do
      subject.place_ship(small_ship, "A1")
      subject.fire("A1")
      subject.fire("A2")
      allow(small_ship).to receive(:has_sunk) {true}
      expect(subject.ships.include?(small_ship)).to be false
    end
  end
end


