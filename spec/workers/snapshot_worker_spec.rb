#encoding: utf-8
require 'spec_helper'

describe SnapshotWorker do
  COMPANY_ROOT= ->(id){ "#{Rails.root}/public/certs/#{id}" }
  COMPANY_IDINFO_OUT = ->(id){  "#{COMPANY_ROOT.call(id)}/#{id}.png" }

  PERSON_ROOT      = ->(id){ "#{Rails.root}/public/crimes/#{id}" }

  let(:cert) { create(:cert) }
  let(:qqw1){ create(:qqw1) }
  let(:crime){create(:crime)}

 # it "should get a snapshot of the cert,perform_one" do
 #   root_path = COMPANY_ROOT.call(qqw1.regist_id)
 #   path = COMPANY_IDINFO_OUT.call(qqw1.regist_id)
 #   FileUtils.rm_r root_path if File.exist? path
 #   (File.exist? path).should be_false
 #   SnapshotWorker::Idinfo::perform_one(qqw1.id)
 #   (File.exist? path).should be_true
 #   qqw1.reload.snapshot_path.should ==  path
 # end

 # it "should get two snapshots of certs,perform_all" do
 #   root_path1 = COMPANY_ROOT.call(cert.regist_id)
 #   path1 = COMPANY_IDINFO_OUT.call(cert.regist_id)
 #   FileUtils.rm_r root_path1 if File.exist? path1
 #   (File.exist? path1).should be_false

 #   root_path2 = COMPANY_ROOT.call(qqw1.regist_id)
 #   path2 = COMPANY_IDINFO_OUT.call(qqw1.regist_id)
 #   FileUtils.rm_r root_path2 if File.exist? path2
 #   (File.exist? path2).should be_false

 #   SnapshotWorker::Idinfo::perform_all("Cert")

 #   (File.exist? path1).should be_true
 #   (File.exist? path2).should be_true
 # end

  it "should get a snapshot of the crime,perform_one" do
    root_path=PERSON_ROOT.call(crime.party_number)
    out= "#{root_path}/#{SnapshotWorker::Court::conv_path crime.case_id}.png"
    FileUtils.rm_r root_path if File.exist? out
    (File.exist? out).should be_false
    SnapshotWorker::Court::perform_one(crime.id)
    (File.exist? out).should be_true
    crime.reload.snapshot_path.should ==  out
  end

#it "should get a snapshot of the crime,perform_all" do
#    root_path=PERSON_ROOT.call(crime.party_number)
#    out= "#{root_path}/#{SnapshotWorker::Court::conv_path crime.case_id}.png"
#    FileUtils.rm_r root_path if File.exist? out
#    (File.exist? out).should be_false
#    SnapshotWorker::Court::perform_all("Crime")
#    (File.exist? out).should be_true
#    crime.reload.snapshot_path.should ==  out
#  end

end
