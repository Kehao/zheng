require 'spec_helper'

describe "Sidekiq perform_async" do
  it "should incr jobs size when call perform_async" do
    expect { 
      SpiderWorker.perform_async(1) 
    }.to change(SpiderWorker.jobs, :size).by(1)

    expect { 
      ListFileWorker.perform_async(1) 
      ListFileWorker.perform_async(2) 
    }.to change(ListFileWorker.jobs, :size).by(2)
  end
end
