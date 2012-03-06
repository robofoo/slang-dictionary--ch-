require 'spec_helper'

describe Definition do
  context "anon user" do
    describe "create new definition" do
      let(:word) { Factory.create(:definition) }

      it 'creates code' do
        word.code.should_not == nil
      end

      it 'has an email address' do
        word.email.should_not == nil
      end

      it 'defaults visibility to false' do
        word.visible.should == false
      end

      it 'defaults reviewed to false' do
        word.reviewed.should == false
      end
    end

    describe "check definition" do
      let(:word) { Factory.create(:definition) }

      # code should not change after user verifies submission
      it 'keeps same code' do
        original_code = word.code
        word.save
        word.reload
        original_code.should == word.code
      end
    end
  end
end
