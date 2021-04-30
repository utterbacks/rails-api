require 'rails_helper'

describe 'Authentication', type: :request do
  describe 'POST /auth' do
    let(:user) {FactoryBot.create(:user, username: 'BookSeller99', password: 'Password1')}
    it 'authenticates the client'do
      post '/api/v1/auth', params: { username: user.username, password: 'Password1'}

      expect(response).to have_http_status(:created)
      expect(response_body).to eq({
        'token'=>'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.A6ScM3oxFTv8xsngqF73oJQsHHczND0BI4sdnTOm1gE'
      })
    end

    it 'returns error when un missing' do
      post '/api/v1/auth', params: { password: 'password1'}
      
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({
        'error' => 'param is missing or the value is empty: username'
      })
    end

    it 'returns error when pw is missing'do
      post '/api/v1/auth', params: { username: 'BookSeller99'}
      
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body).to eq({
        'error' => 'param is missing or the value is empty: password'
      })
    end
    it 'returns error on incorrect pw' do 
      post '/api/v1/auth', params: { username: user.username , password: 'incorrect'}
      expect(response).to have_http_status(:unauthorized)
    end
  end
end