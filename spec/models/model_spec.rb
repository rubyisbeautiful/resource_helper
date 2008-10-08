require File.dirname(__FILE__) + '/../spec_helper'

describe "an ActiveResource with ActiveRecord compatability" do
  
  %w( all first last ).each do |m|
    it "should have a '#{m}' class method" do
      Dummy.respond_to?(m).should be_true
    end
  end
  
end

describe "ActiveResource" do  
  describe '#all' do
    before(:all) do
      @dummy_one = mock(Dummy)
      @dummy_two = mock(Dummy)
    end
    it "should return all records" do
      Dummy.stub!(:find_every).and_return([@dummy_one, @dummy_two])
      Dummy.all.class.should == Array
      Dummy.all.length.should == 2
    end
  end
  
  describe '#first' do
    it "should return the first record" do
      @dummy_one = mock(Dummy)
      @dummy_two = mock(Dummy)
      Dummy.should_receive(:find_every).twice.and_return([@dummy_one, @dummy_two])
      every = Dummy.send(:find_every)
      every.should_not be_nil
      first = Dummy.first
      first.should_not be_nil
      first.should == @dummy_one
    end
  end
  
  describe '#last' do
    it "should return the first record" do
      @dummy_one = mock(Dummy)
      @dummy_two = mock(Dummy)
      Dummy.should_receive(:find_every).twice.and_return([@dummy_two, @dummy_one])
      every = Dummy.send(:find_every)
      every.should_not be_nil
      last = Dummy.first
      last.should_not be_nil
      last.should == @dummy_two
    end
  end
  
end
      

class Dummy < ActiveResource::Base
  require File.join(File.dirname(__FILE__), '../..', 'lib/resource_helper/active_resource_extensions')
  include ResourceHelper::ActiveResourceExtensions
end