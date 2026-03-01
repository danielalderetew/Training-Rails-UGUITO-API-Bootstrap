shared_examples 'responds with ok status' do
  it 'responds with OK status' do
    expect(response).to have_http_status(:ok)
  end
end
