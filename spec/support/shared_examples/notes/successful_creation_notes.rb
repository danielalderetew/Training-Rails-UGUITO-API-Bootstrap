shared_examples 'returns successful created note' do
  subject(:make_request) { post :create, params: create_params }

  it 'creates a new note' do
    expect { make_request }.to change(Note, :count).by(1)
    note = user.notes.last

    expect(note.title).to eq(create_params[:note][:title])
    expect(note.note_type).to eq(create_params[:note][:note_type].to_s)
    expect(note.content).to eq(create_params[:note][:content])
  end

  it 'responds with created note' do
    make_request
    expect(response_body['message']).to eq(I18n.t('notes.created'))
  end

  it 'responds with CREATED status' do
    make_request
    expect(response).to have_http_status(:created)
  end
end
