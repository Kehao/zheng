require 'spec_helper'

describe "admin_stauts/edit" do
  before(:each) do
    @staut = assign(:staut, stub_model(Admin::Staut))
  end

  it "renders the edit staut form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_stauts_path(@staut), :method => "post" do
    end
  end
end
