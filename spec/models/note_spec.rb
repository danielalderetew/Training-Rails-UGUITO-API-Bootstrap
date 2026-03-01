require 'rails_helper'

shared_examples 'calculates correctly content length' do
  let(:note) { create(:note, word_count: content_count_words, user: user) }

  context 'with short content' do
    let(:max_words) { user.utility.short_content_limit }
    let(:content_count_words) { Faker::Number.within(range: 1..max_words) }

    it { expect(note.content_length).to eq('short') }
  end

  context 'with medium content' do
    let(:min_words) { user.utility.short_content_limit + 1 }
    let(:max_words) { user.utility.medium_content_limit }
    let(:content_count_words) { Faker::Number.within(range: min_words..max_words) }

    it { expect(note.content_length).to eq('medium') }
  end

  context 'with long content' do
    let(:min_words) { user.utility.medium_content_limit + 1 }
    let(:max_words) { user.utility.medium_content_limit + 100 }
    let(:content_count_words) { Faker::Number.within(range: min_words..max_words) }

    it { expect(note.content_length).to eq('long') }
  end
end

shared_examples 'a valid note' do |type|
  let(:note) { build(:note, note_type: type, word_count: content_count_words, user: user) }

  it "is valid as a #{type}" do
    expect(note).to be_valid
  end
end

shared_examples 'an invalid note' do |type|
  let(:note) { build(:note, note_type: type, word_count: content_count_words, user: user) }

  it "is invalid as a #{type}" do
    expect(note).not_to be_valid
  end
end

RSpec.describe Note, type: :model do
  subject(:note) { build(:note) }

  let(:south_user) { create(:user, :south) }
  let(:north_user) { create(:user, :north) }

  %i[title content note_type].each do |value|
    it { is_expected.to validate_presence_of(value) }
  end

  it { is_expected.to belong_to(:user) }

  it { is_expected.to define_enum_for(:note_type).with_values(critique: 0, review: 1) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe '#word_count' do
    context 'when content notes have random words' do
      subject(:note) { create(:note, word_count: content_word_count) }

      let(:content_word_count) { Faker::Number.within(range: 1..100) }

      it 'returns the word count of the content' do
        expect(subject.word_count).to eq(content_word_count)
      end
    end
  end

  describe '#content_length' do
    context 'when user is North' do
      let(:user) { north_user }

      it_behaves_like 'calculates correctly content length'
    end

    context 'when user is South' do
      let(:user) { south_user }

      it_behaves_like 'calculates correctly content length'
    end
  end

  describe '#validate_review_content' do
    context 'when user is North' do
      let(:user) { north_user }

      context 'with short content' do
        let(:min_words) { 1 }
        let(:max_words) { user.utility.short_content_limit }
        let(:content_count_words) { Faker::Number.within(range: min_words..max_words) }

        it_behaves_like 'a valid note', :review
        it_behaves_like 'a valid note', :critique
      end

      context 'with medium content' do
        let(:min_words) { user.utility.short_content_limit + 1 }
        let(:max_words) { user.utility.medium_content_limit }
        let(:content_count_words) { Faker::Number.within(range: min_words..max_words) }

        it_behaves_like 'an invalid note', :review
        it_behaves_like 'a valid note', :critique
      end

      context 'with long content' do
        let(:min_words) { user.utility.medium_content_limit + 1 }
        let(:max_words) { min_words + 80 }
        let(:content_count_words) { Faker::Number.within(range: min_words..max_words) }

        it_behaves_like 'an invalid note', :review
        it_behaves_like 'a valid note', :critique
      end
    end

    context 'when user is South' do
      let(:user) { south_user }

      context 'with short content' do
        let(:min_words) { 1 }
        let(:max_words) { user.utility.short_content_limit }
        let(:content_count_words) { Faker::Number.within(range: min_words..max_words) }

        it_behaves_like 'a valid note', :review
        it_behaves_like 'a valid note', :critique
      end

      context 'with medium content' do
        let(:min_words) { user.utility.short_content_limit + 1 }
        let(:max_words) { user.utility.medium_content_limit }
        let(:content_count_words) { Faker::Number.within(range: min_words..max_words) }

        it_behaves_like 'an invalid note', :review
        it_behaves_like 'a valid note', :critique
      end

      context 'with long content' do
        let(:min_words) { user.utility.medium_content_limit + 1 }
        let(:max_words) { min_words + 80 }
        let(:content_count_words) { Faker::Number.within(range: min_words..max_words) }

        it_behaves_like 'an invalid note', :review
        it_behaves_like 'a valid note', :critique
      end
    end
  end
end
