require 'spec_helper'

describe ApplicationHelper do
  describe "#tab_link_to" do
    subject { helper.tab_link_to('My Link', {:controller => 'sobre'}) }

    context "matching params" do
      before(:each) do
        params = {:controller => 'sobre', :junk => 'junk'}
        helper.stub!(:params).and_return params
      end
      it("mark tab as selected") { should have_selector('a[class=menu_select]') }
    end

    context "non-matching params" do
      before(:each) do
        params = {:controller => 'eventos', :junk => 'junk'}        
        helper.stub!(:params).and_return params
      end
      it("unmark tab") { should have_selector('a[class=menu_inicial]') }
    end

    context "url with both controller and action matching" do
      subject { helper.tab_link_to('My Link', {:controller => 'sobre', :action => 'colaboradores'}) }
      before(:each) do
        params = {:controller => 'sobre',:junk => 'junk',:action => 'colaboradores'}                
        helper.stub!(:params).and_return params
      end
      it("don't mark tab as selected") { should have_selector('a[class=menu_select]') }
    end

    context "url with both controller and action, but action doesn't match" do
      subject { helper.tab_link_to('My Link', {:controller => 'sobre', :action => 'colaboradores'}) }
      before(:each) do
        params = {:controller => 'sobre',:junk => 'junk',:action => 'index'}                        
        helper.stub!(:params).and_return params
      end
      it("don't mark tab as selected") { should have_selector('a[class=menu_inicial]') }

    end
  end
end
