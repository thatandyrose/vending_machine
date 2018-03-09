require 'spec_helper'

describe '#test' do
  it 'should correctly process the data file' do
    test = build :hello
    expect(test.name).to eq 'john'
  end
end