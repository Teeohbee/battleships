require 'ship'

describe Ship do
  before(:each) do
    @ship = Ship.new('')
  end

  it 'can be created with a location' do
    expect(@ship.location).to be_a String
  end

  it ''
end
