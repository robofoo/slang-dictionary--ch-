require 'spec_helper'

describe Definition do
  describe ".random_set" do
    it 'gets a random set of definitions' do
      def1 = Factory.create(:definition, :status => 'reviewed')
      def2 = Factory.create(:definition, :status => 'reviewed')
      def3 = Factory.create(:definition, :status => 'reviewed')
      def4 = Factory.create(:definition, :status => 'reviewed')
      def5 = Factory.create(:definition, :status => 'reviewed')
      def6 = Factory.create(:definition, :status => 'reviewed')
      def7 = Factory.create(:definition, :status => 'reviewed')
      def8 = Factory.create(:definition, :status => 'reviewed')
      def9 = Factory.create(:definition, :status => 'reviewed')

      subset = Definition.where(:status => 'reviewed')
      random_set1 = Definition.random_subset(subset, 2)
      random_set2 = Definition.random_subset(subset, 2)

      random_set1.count.should == 2
      # if it matches it could just be a fluke
      random_set1.should_not == random_set2
    end

    it 'errors if definition count is smaller than size' do
      expect do
        def1 = Factory.create(:definition, :status => 'reviewed')
        def2 = Factory.create(:definition, :status => 'reviewed')
        def3 = Factory.create(:definition, :status => 'reviewed')

        subset = Definition.where(:status => 'reviewed')
        random_set = Definition.random_subset(subset, 3)
        random_set.count.should == 3
      end.to raise_error
    end
  end

  describe "#upvote(user)" do
    it 'votes up and updates score' do
      user = Factory.create(:user)
      new_def = Factory.create(:definition)
      old_score = new_def.score
      old_vote_count = new_def.votes.count

      new_def.upvote(user)
      new_def.score.should == old_score + 1
      new_def.votes.count.should == old_vote_count + 1
    end

    it 'clears votes if already voted for' do
      user = Factory.create(:user)
      new_def = Factory.create(:definition)
      old_score = new_def.score
      old_vote_count = new_def.votes.count
      new_def.upvote(user)
      new_def.score.should == old_score + 1
      new_def.votes.count.should == old_vote_count + 1

      new_def.upvote(user)
      new_def.score.should == old_score
      new_def.votes.count.should == old_vote_count
    end
  end

  describe "#downvote(user)" do
    it 'votes down and updates score' do
      user = Factory.create(:user)
      new_def = Factory.create(:definition)
      old_score = new_def.score
      old_vote_count = new_def.votes.count

      new_def.downvote(user)
      new_def.score.should == old_score - 1
      new_def.votes.count.should == old_vote_count + 1
    end

    it 'clears votes if already voted for' do
      user = Factory.create(:user)
      new_def = Factory.create(:definition)
      old_score = new_def.score
      old_vote_count = new_def.votes.count
      new_def.downvote(user)
      new_def.score.should == old_score - 1
      new_def.votes.count.should == old_vote_count + 1

      new_def.downvote(user)
      new_def.score.should == old_score
      new_def.votes.count.should == old_vote_count
    end
  end

  describe "#upvote(user) after a #downvote(user)" do
    it 'properly updates score' do
      user = Factory.create(:user)
      new_def = Factory.create(:definition)
      new_def.downvote(user)
      new_def.score.should == -1

      new_def.upvote(user)
      new_def.score.should == 1
    end
  end

  describe "#downvote(user) after a #upvote(user)" do
    it 'properly updates score' do
      user = Factory.create(:user)
      new_def = Factory.create(:definition)
      new_def.upvote(user)
      new_def.score.should == 1

      new_def.downvote(user)
      new_def.score.should == -1
    end
  end

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

    it 'is all lowercase' do
      new_def = Factory.create(:definition, pinyin_original:'Ni3Hao3Ma5')
      new_def.pinyin_for_search.should == 'nihaoma'
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
        @user5 = Factory.create(:user)
        @user6 = Factory.create(:user)
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
      
      it 'downgrade status if score is low enough' do
        @def1.reject(@user1)
        @def1.reject(@user2)
        @def1.reject(@user3)
        @def1.reject(@user4)
        @def1.reject(@user5)
        @def1.status.should == 'raw'

        @def1.reject(@user6)
        @def1.status.should == 'flagged'
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
