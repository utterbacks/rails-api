class AuthTokenService 
  HMAC_SECRET = 'mysecretkey'
  ALGORITHM_TYPE = 'HS256'
  class << self
    def call(user_id)
      payload = {user_id: user_id}

      JWT.encode payload, HMAC_SECRET, ALGORITHM_TYPE
    end

    def decode(token)
      decoded_token = JWT.decode token, HMAC_SECRET, true, {algorithm: ALGORITHM_TYPE}
      decoded_token[0]['user_id']
    end
  end
end
