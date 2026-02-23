require 'rails_helper'

RSpec.describe Note, type: :model do
  
  subject(:note) { build(:note, note_type_trait, content_trait, user_trait) }

  let(:note_type_trait) { :critique }
  let(:content_trait) { :short_content }
  let(:user_trait) { :north }

  shared_examples 'calculates correctly' do |content_trait_value, expected_length|
    let(:content_trait) { content_trait_value }
    let(:note_type_trait) { :critique }
    it { expect(note.content_length).to eq(expected_length) }
  end

  shared_examples 'a valid note' do |content_trait_value|
    let(:content_trait) { content_trait_value }
    it { is_expected.to be_valid }
  end
  
  shared_examples 'an invalid note' do |content_trait_value|
    let(:content_trait) { content_trait_value }
    it { is_expected.not_to be_valid }
  end

  %i[title content note_type].each do |value|
    it { is_expected.to validate_presence_of(value) }
  end
  

  it { is_expected.to belong_to(:user) }
  
  it { is_expected.to define_enum_for(:note_type).with_values(critique: 0, review: 1) }


  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe '#word_count' do
    it 'returns the word count of the content' do
      expect(subject.word_count).to eq(subject.content.split.count)
    end
  end

  describe '#content_length' do
    
    context 'when user is North' do
      let(:user_trait) { :north }

      it_behaves_like 'calculates correctly', :short_content, 'short'
      it_behaves_like 'calculates correctly', :medium_content, 'medium'
      it_behaves_like 'calculates correctly', :long_content, 'long'
    end
    
    context 'when user is South' do
      let(:user_trait) { :south }

      it_behaves_like 'calculates correctly', :short_content, 'short'    
      it_behaves_like 'calculates correctly', :medium_content, 'medium'    
      it_behaves_like 'calculates correctly', :long_content, 'long'
    end


  end

  describe '#validate_review_content' do
    context 'when user is North' do
      let(:user_trait) { :north }

      context 'and note is a review' do
        let(:note_type_trait) { :review }

        it_behaves_like 'a valid note', :short_content
        it_behaves_like 'an invalid note', :medium_content
        it_behaves_like 'an invalid note', :long_content
      end

      context 'and note is a critique' do
        let(:note_type_trait) { :critique }

        it_behaves_like 'a valid note', :short_content
        it_behaves_like 'a valid note', :medium_content
        it_behaves_like 'a valid note', :long_content
      end
    end

  context 'when user is South' do
    let(:user_trait) { :south }

    context 'and note is a review' do
      let(:note_type_trait) { :review }

      it_behaves_like 'a valid note', :short_content
      it_behaves_like 'an invalid note', :medium_content
      it_behaves_like 'an invalid note', :long_content
    end

    context 'and note is a critique' do
      let(:note_type_trait) { :critique }

      it_behaves_like 'a valid note', :short_content
      it_behaves_like 'a valid note', :medium_content
      it_behaves_like 'a valid note', :long_content
    end
  end
    
  end

end
