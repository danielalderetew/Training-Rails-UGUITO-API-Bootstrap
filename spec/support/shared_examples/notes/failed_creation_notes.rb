shared_examples 'failed with unprocessable entity and message' do
  before do
    post :create, params: create_params
  end

  it 'returns status code unprocessable entity' do
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'returns the expected error message' do
    expect(response_body['error'])
      .to eq(expected_message)
  end
end


