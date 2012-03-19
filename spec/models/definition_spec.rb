require 'spec_helper'

describe Definition do
  let(:word) { Factory.create(:definition) }

  describe "create new definition" do
    it 'does not allow invalid status' do
      lambda do
        invalid_word = Factory.create(:definition, status:'invalid')
      end.should raise_error
    end
  end

  context "anon user" do
    describe "create new definition" do
      it 'creates code' do
        word.code.should_not == nil
      end

      it 'has an email address' do
        word.email.should_not == nil
      end

      it "defaults status to 'raw'" do
        word.status.should == 'raw'
      end
    end

    describe "check definition" do
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
