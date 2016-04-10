require 'ship'

describe Ship do
  before(:each) do
    @ship = Ship.new(:patrol_boat, :H)
  end

  it 'generates size based on ship type' do
    expect(@ship.size).to eq 2
  end

  it 'has a size' do
    expect(@ship.size).to be_a Integer
  end

  it 'has a direction' do
    expect(@ship.direction).to be_truthy
  end

  describe '#valid_direction?' do
    it 'fails if direction is not valid' do
      expect { Ship.new(:battleship, :invalid_direction) }.to raise_error 'Direction must be :H, :V'
    end
  end

  it 'type must match one of the ship types' do
    expect { Ship.new('incorrect_type', :H) }.to raise_error 'Incorrect ship type'
  end

  it 'has a method called ship_types' do
    expect(@ship).to respond_to :ship_types
  end

  describe '#ship_types' do
    it 'returns a hash' do
      expect(@ship.ship_types).to be_a Hash
    end
  end

  it "loses hp when fired at" do
    start_hp = @ship.hp
    @ship.gets_got
    expect(@ship.hp).to eq(start_hp - 1)
  end

  it "can tell when a ship has sunk" do
    2.times { @ship.gets_got }
    expect(@ship.has_sunk?).to eq true
  end
end
