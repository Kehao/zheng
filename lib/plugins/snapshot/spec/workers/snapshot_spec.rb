#encoding: utf-8
require 'spec_helper'
describe Snapshot do
  let(:crime){FactoryGirl.create(:crime)}

  it "file storage" do  

   test_file_path = "#{RAILS_ROOT}/spec/test.txt"
   File.open(test_file_path,"w") do |file|  
      file.puts "Line 1"  
   end  
   File.exist?(test_file_path).should be_true
   
   root = "#{RAILS_ROOT}/t"

   storage = Snapshot::Storage::File.new(root)

   storage.store(test_file_path)

   File.exist?(test_file_path).should be_false

   File.exist?(root + "/test.txt").should be_true

   storage.retrieve("test.txt").should == root + "/test.txt"

   storage.remove("test.txt")

   File.exist?(root + "/test.txt").should be_false

   storage.clear
   
  end

  it "court params" do 
    expect { 
      Snapshot::Court.new(:invalid=>123)
    }.to raise_error(ArgumentError)

  expect { 
      Snapshot::Court.new(:orig_url=>"test")
    }.to raise_error(Snapshot::NoKeyProvided)

    expect { 
      Snapshot::Court.new(:orig_url=>"test",:party_number=>"party_number",:case_id=>"case_id")
    }. to_not raise_error
  end

  it "court snapshot" do
    snapshot=Snapshot::Court.new(:orig_url=>crime.orig_url,:party_number=>crime.party_number,:case_id=>crime.id)
    snapshot.run
    File.exist?(snapshot.storage.retrieve(crime.id.to_s + ".png")).should be_true
  end
end
