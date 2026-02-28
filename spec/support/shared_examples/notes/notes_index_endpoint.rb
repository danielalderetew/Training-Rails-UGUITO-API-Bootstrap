shared_examples 'returns expected notes' do
  it 'responds with notes' do
    expect(response_body['notes'].map { |n| n['id'] }).to match_array(expected_notes.map(&:id))
  end
end

shared_examples 'returns empty notes' do
  it 'responds with empty array' do
    expect(response_body['notes']).to be_empty
  end
end

shared_examples 'returns notes in order' do
  it 'responds with notes' do
    expect(response_body['notes'].map { |n| n['id'] }).to eq(expected_notes.map(&:id))
  end
end
