require 'spec_helper'

describe Definition do
  describe "#pinyin" do
    it 'nicely formats pinyin_original with spaces' do
      new_def = Factory.create(:definition, pinyin_original:'ni3hao3ma5')
      new_def.pinyin.should == 'ni3 hao3 ma5'
    end
  end

  describe "pinyin_for_search field" do
    it 'gets created' do
      new_def = Factory.create(:definition, pinyin_original:'ni3hao3ma5')
      new_def.pinyin_for_search.should == 'nihaoma'
    end
  end

  describe "#up_score" do
    it 'adds score by one' do
      new_def = Factory.create(:definition)
      new_def.score.should == 0
      new_def.up_score
      new_def.score.should == 1
    end
  end

  describe "#down_score" do
    it 'lowers score by one' do
      new_def = Factory.create(:definition)
      new_def.score.should == 0
      new_def.down_score
      new_def.score.should == -1
    end
  end

  describe "create new definition" do
    it 'does not allow invalid status' do
      lambda do
        invalid_word = Factory.create(:definition, status:'invalid')
      end.should raise_error
    end

    it 'strips pinyin of tone markers' do
      new_def = Factory.create(:definition)
      new_def.pinyin_for_search.match(/\d/).should == nil
    end
  end

  context "logged in user" do
    describe ".random_unconfirmed" do
      before(:all) do
        @user1 = Factory.create(:user)
        Factory.create(:definition, email:@user1.email)
        Factory.create(:definition)
        Factory.create(:definition)
      end

      after(:all) do
        [Definition, User].each do |i|
          i.destroy_all
        end
      end
    
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

    describe "#accept" do
      before(:each) do
        @def1 = Factory.create(:definition)
      end

      before(:all) do
        @user1 = Factory.create(:user)
        @user2 = Factory.create(:user)
        @user3 = Factory.create(:user)
        @user4 = Factory.create(:user)
      end

      after(:all) do
        [Definition, User].each do |i|
          i.destroy_all
        end
      end

      it 'upgrade status if score is high enough' do
        @def1.status.should == 'raw'

        @def1.accept(@user4)
        @def1.status.should == 'reviewed'
        @def1.score.should == 1
      end
      
      #it 'downgrade status if score is low enough' do
        #@def1.reject(@user1)
        #@def1.reject(@user2)
        #@def1.reject(@user3)
        #@def1.status.should == 'raw'

        #@def1.reject(@user4)
        #@def1.status.should == 'flagged'
      #end
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
