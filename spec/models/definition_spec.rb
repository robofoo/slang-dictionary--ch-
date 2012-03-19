require 'spec_helper'

describe Definition do
  describe "create new definition" do
    it 'does not allow invalid status' do
      lambda do
        invalid_word = Factory.create(:definition, status:'invalid')
      end.should raise_error
    end
  end

  context "logged in user" do

    before(:all) do
      @user1 = Factory.create(:user)
      Factory.create(:definition, email:@user1.email)
      Factory.create(:definition, email:'user2@email.com')
      Factory.create(:definition, email:'user2@email.com')
    end

    after(:all) do
      [Definition, User].each do |i|
        i.destroy_all
      end
    end
    
    describe ".random_unconfirmed" do
      it 'does not show any definitions that are unconfirmed' do
        defs = Definition.random_unconfirmed(@user1)
        defs.count.should == 0
      end

      it 'shows only confirmed definitions' do
        # confirm all words not submitted by current user
        Definition.where('email != ?', @user1.email).each do |d|
          d.status = 'confirmed'
          d.save!
        end

        defs = Definition.random_unconfirmed(@user1)

        defs.status.should == 'confirmed'
      end

      it 'does not show definitions submitted by current user' do
        # only confirm words submitted by this user
        Definition.where(:email => @user1.email).each do |d|
          d.status = 'confirmed'
          d.save!
        end

        defs = Definition.random_unconfirmed(@user1)

        defs.empty?.should == true
      end

      it 'does not show definitions already voted on by current user' do
        # only confirm words submitted by this user
        Definition.where(:email => @user1.email).each do |d|
          d.status = 'confirmed'
          d.save!
        end

        defs = Definition.random_unconfirmed(@user1)
        defs.blank?.should == true
      end
    end
  end

  context "anon user" do
    let(:word) { Factory.create(:definition) }

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
