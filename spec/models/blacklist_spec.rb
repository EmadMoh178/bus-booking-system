require 'rails_helper'

RSpec.describe Blacklist, type: :model do
  it 'is valid with a token' do
    blacklist = Blacklist.new(token: 'sampletoken123')
    expect(blacklist).to be_valid
  end

  it 'is invalid without a token' do
    blacklist = Blacklist.new(token: nil)
    expect(blacklist).to_not be_valid
  end

  it 'is invalid with a duplicate token' do
    Blacklist.create(token: 'sampletoken123')
    blacklist = Blacklist.new(token: 'sampletoken123')
    expect(blacklist).to_not be_valid
  end
end
