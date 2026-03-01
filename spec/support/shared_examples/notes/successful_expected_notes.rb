shared_examples 'returns successful expected notes' do
  it 'responds with notes' do
    expect(response_body['notes'].map { |n| n['id'] }).to match_array(expected_notes.map(&:id))
  end

  it_behaves_like 'responds with ok status'
end

shared_examples 'returns successful empty notes' do
  it 'responds with empty array' do
    expect(response_body['notes']).to be_empty
  end

  it_behaves_like 'responds with ok status'
end

shared_examples 'returns successful notes in order' do
  it 'responds with notes' do
    expect(response_body['notes'].map { |n| n['id'] }).to eq(expected_notes.map(&:id))
  end

  it_behaves_like 'responds with ok status'
end
