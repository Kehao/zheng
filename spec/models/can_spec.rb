#encoding: utf-8
require 'spec_helper'

describe Can do
  let(:abilities) do 
    { 
      project: {view: 1, edit: 1},
      issue:   {view: 1, delete: '1'},
      commit:  {view: 0, edit: '0'} # 向后兼容测试, 因为只存储有的权限
    }
  end
  let(:can) { Can.new(abilities) }

  describe "#method_missing" do
    it "should return true if exist an ability" do
      can.project.view.should be_true
      can.project.edit.should be_true
    end

    it "should return false if not exist an ability" do
      can.project.delete.should be_false
      can.issue.edit.should be_false
    end

    it "should return a blank Can instance if not exist a resoure in abilities and also can call chain" do
      can.bug.should be_a_kind_of(Can)
      can.bug.read.should be_false
    end
     
    it "should return false if a resource ability not access(compatible test)" do
      can.commit.view.should be_false
      can.commit.edit.should be_false
    end
  end
end
