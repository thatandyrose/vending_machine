require 'spec_helper'
require 'test'

describe '#test' do
  it 'should correctly process the data file' do
    expect(Hello.new.say).to eq 'Hello'  
  end
end