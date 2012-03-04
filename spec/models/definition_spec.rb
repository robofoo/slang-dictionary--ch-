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
    end
  end
end
