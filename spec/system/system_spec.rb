require 'spec_helper'

describe "Skyeye system init..." do

  context "role" do
    it "should check the default roles" do
      expect{
        Skyeye.init_role
      }.to change(Role, :count).by(2)
    end
    it "should check the default roles" do
      expect{
        Skyeye.init_role
      }.to change(Capability, :count).by(2)
    end

    it "assoc test" do
      Skyeye.init_role
      r=Role.where(id:100000).first
      r.capability.id.should == 100000
    end
  end

  context User do
    it "should create admin when users is blank" do
      User.destroy_all
      User.all.should have(0).items
      Skyeye.init_user
      User.all.should have(1).items
      User.first.role_id.should ==100001
    end

    it "should update role_id of all users" do
      user1=User.create({name: 'admin1', 
                        email: 'admin1@example.com',
                        password: 'password',
                        password_confirmation: 'password'})
      user2=User.create({name: 'admin2', 
                        email: 'admin2@example.com',
                        password: 'password',
                        password_confirmation: 'password'})
      Skyeye.init_user
      user1.reload.role_id.should ==100000
      user2.reload.role_id.should ==100000
    end
  end
end

#  require "skyeye"
#  describe Skyeye::AccessControl do
#    before do
#      Skyeye::AccessControl.permissions=nil
#    end
#
#    it "should return hashes default/test" do
#      Skyeye::AccessControl.map do |map|
#        map.permission(:cert, :view =>false,:snapshot=>true)
#        map.permission(:crime,:view =>true, :snapshot=>false)
#      end
#      dh=Skyeye::AccessControl.permissions
#      dh.key?(:default).should be_true
#      dh[:default].should have(2).items
#
#      Skyeye::AccessControl.map do |map|
#        map.permission(:cert, :view =>false,:snapshot=>true)
#        map.permission(:crime,:view =>true, :snapshot=>false)
#        map.name :test
#      end
#      dh=Skyeye::AccessControl.permissions
#      dh.key?(:test).should be_true
#      dh[:test].should have(2).items
#    end
#
#    it "other hash should has default hash" do
#      Skyeye::AccessControl.map do |map|
#        map.permission(:cert, {:view =>false,:snapshot=>true},{:public=>true,:require => false})
#        map.permission(:crime,:view =>true, :snapshot=>false)
#      end
#      dh=Skyeye::AccessControl.permissions[:default]
#      dh.should have(2).items
#
#      Skyeye::AccessControl.map do |map|
#        map.permission(:test,:view =>true, :snapshot=>false)
#        map.name :test
#      end
#      dh_test=Skyeye::AccessControl.permissions[:test]
#      dh_test.should have(3).items
#      dh.should have(2).items
#    end
#
#    it "should have options" do 
#      Skyeye::AccessControl.map do |map|
#        map.permission(:cert, {:view =>false,:snapshot=>true},{:public=>true,:require => false})
#        map.permission(:crime,:view =>true, :snapshot=>false)
#        map.name :test
#      end
#      dh_test=Skyeye::AccessControl.permissions[:test]
#      dh_test[:cert][:options][:public].should be_true
#    end
#
#    it "should have project_module options" do
#      Skyeye::AccessControl.map do |map|
#        map.project_module :normal do
#          map.permission(:cert, {:view =>false,:snapshot=>true},{:public=>true,:require => false})
#          map.permission(:crime,:view =>true, :snapshot=>false)
#        end
#        map.name :test
#      end
#      dh_test=Skyeye::AccessControl.permissions[:test]
#      dh_test[:cert][:options][:module].should == :normal
#      dh_test[:crime][:options][:module].should == :normal
#    end
#
#    it "should merge" do
#      Skyeye::AccessControl.map do |map|
#        map.permission(:cert, :view =>false,:snapshot=>true)
#        map.permission(:crime,:view =>true, :snapshot=>false)
#        map.name :test
#      end
#
#      dh_test=Skyeye::AccessControl.permissions[:test]
#      dh_test[:cert][:view].should == "0"
#
#      Skyeye::AccessControl.map do |map|
#        map.permission(:cert, :view =>true,:snapshot=>true,:actiontest=>true)
#        map.permission(:crime,:view =>true, :snapshot=>false)
#        map.permission(:new,:view =>false, :snapshot=>false)
#        map.name :test
#      end
#      dh_test=Skyeye::AccessControl.permissions[:test]
#      dh_test[:cert][:view].should == "1" 
#      dh_test[:cert][:actiontest].should == "1" 
#      dh_test[:new][:view].should == "0" 
#
#      Skyeye::AccessControl.map do |map|
#        map.project_module :normal do
#          map.permission(:cert, :view =>true,:snapshot=>true,:actiontest=>true)
#          map.permission(:crime,:view =>true, :snapshot=>false)
#        end
#        map.permission(:new,:view =>false, :snapshot=>false)
#        map.name :test
#      end
#      dh_test=Skyeye::AccessControl.permissions[:test]
#      dh_test[:cert][:options][:module].should == :normal
#    end
#  end
#end
