# encoding:utf-8
require 'spec_helper'
describe SkyeyePower::CompanyAccount do
  let(:admin)     {create(:admin)}
  let(:r_admin)   {create(:r_admin)}
  let(:member)    {create(:member)}
  let(:r_member)  {create(:r_member)}
  let(:cs_manager){create(:cs_manager)}
  let(:cs)        {create(:cs)}
  let(:cs_supporter){create(:cs_supporter)}
  let(:r_cs_supporter){create(:r_cs_supporter)}
  let(:status1) {
    Workflow::Status.create("name"=>"已提供水号",
                            "is_default"=>true,
                            "description"=>"有提供水电号权限的用户提供水电号")
  }

  let(:status2) {
    Workflow::Status.create("name"=>"开始编辑",
                            "is_default"=>false,
                            "description"=>"相关工作人员查询水电信息")
  }

  let(:status3) {
    Workflow::Status.create("name"=>"已编辑完成,等待审核",
                            "is_default"=>false,
                            "description"=>"等待审核")
  }
  let(:status4) {
    Workflow::Status.create("name"=>"已审核",
                            "is_default"=>false,
                            "description"=>"\t审核完成")
  }
  let(:status5) {
    Workflow::Status.create("name"=>"发回重新编辑",
                            "is_default"=>false,
                            "description"=>"审核不能过,发回重新编辑")
  }
  let(:tracker){
    Workflow::Tracker.create("name"=>"水电账单",
                            "description"=>"水电账单")
  }
  let(:account){
    SkyeyePower::WaterCompanyAccount.create("type"=>"SkyeyePower::WaterCompanyAccount",
                                            "description"=>"fgdgdfg",
                                            "water_number"=>"123452"
                                           )
  }
  
  it "should build trace if a account track a tracker" do
    expect { 
      account.trace=Workflow::Trace.new(
        :tracker_id=>tracker.id,
        :status_id=>status1.id,
        :assigned_to_id=> member.id)
    }.to change(Workflow::Trace, :count).by(1)
  end

  it "should return new statuses allowd to user" do
    r_admin.workflows.build(:tracker_id => tracker.id, :old_status_id => status1.id, :new_status_id => status2.id, 
                          :author => false, :assignee => false)

    r_admin.workflows.build(:tracker_id => tracker.id, :old_status_id => status1.id, :new_status_id => status3.id, 
                          :author => false, :assignee => false)
    r_admin.save
   
    workflows=status1.find_new_statuses_allowed_to([r_admin], tracker, false, false)
    workflows.should have(2).items

    workflows=status1.find_new_statuses_allowed_to([r_member], tracker, false, false)
    workflows.should have(0).items

  end

  it "author/assignee" do
    account.author=cs_supporter
    cs_supporter.role.workflows.build(:tracker_id => tracker.id, :old_status_id => status1.id, :new_status_id => status2.id, 
                          :author => false, :assignee => false)
    cs_supporter.role.workflows.build(:tracker_id => tracker.id, :old_status_id => status1.id, :new_status_id => status3.id, 
                          :author => true, :assignee => false)
    cs_supporter.role.save

    workflows=status1.find_new_statuses_allowed_to([cs_supporter.role], tracker, false, false)
    workflows.should have(1).items

    workflows=status1.find_new_statuses_allowed_to([cs_supporter.role], tracker, true, false)
    workflows.should have(2).items
  end

  it "TrackableAdditions new_statuses_allowed_to" do

  end


end
