require 'rails_helper'

describe AuthTokenService do
  describe '.call' do
    let(:token) { described_class.call(1)}
    it 'returns auth token' do
      decoded_token = JWT.decode(token, described_class::HMAC_SECRET, true, { algorithm: described_class::ALGORITHM_TYPE })
      expect(decoded_token).to eq(
        [
          {"user_id"=> 1},
          {"alg"=>"HS256"}
        ]
      )
    end
  end
end