# encoding: UTF-8
require 'spec_helper'

describe Mysql2::Statement do
  before :each do
    @client = Mysql2::Client.new DatabaseCredentials['root']
  end

  it "should create a statement" do
    statement = nil
    lambda { statement = @client.prepare 'SELECT 1' }.should_not raise_error
    statement.should be_kind_of Mysql2::Statement
  end

  it "should raise an exception when server disconnects" do
    @client.close
    lambda { @client.prepare 'SELECT 1' }.should raise_error(Mysql2::Error)
  end

  it "should tell us the param count" do
    statement = @client.prepare 'SELECT ?, ?'
    statement.param_count.should == 2

    statement2 = @client.prepare 'SELECT 1'
    statement2.param_count.should == 0
  end

  it "should tell us the field count" do
    statement = @client.prepare 'SELECT ?, ?'
    statement.field_count.should == 2

    statement2 = @client.prepare 'SELECT 1'
    statement2.field_count.should == 1
  end
end
