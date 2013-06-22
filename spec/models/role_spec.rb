require 'spec_helper'

describe Role do
  it " has_ability_item? " do
    role=Role.create(
      "name"=>"test1", 
      "description"=>"test1 description",
      "capability"=>{
      "can"=>
      {"crime"=>{"view"=>"1", "snapshot"=>"1"}, 
        "cert" =>{"view"=>"0", "snapshot"=>"1"}, 
        "bill" =>{"view"=>"1", "snapshot"=>"0"},
        "relationship"=>{"view"=>"0"}, 
        "seek"=>{"search"=>"0"}, 
        "test"=>{"test"=>"0"}
      }
    }
    )
   role.has_ability_item?(:crime,:view).should be_true
   role.has_ability_item?(:crime1,:view).should_not be_true
   role.has_ability_item?(:crime,:view1).should_not be_true
   role.has_ability_item?(:crime1,:view1).should_not be_true

  end
end
