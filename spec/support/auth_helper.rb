module AuthHelper
  def generate_access_token_for(user = nil)
    token = Doorkeeper::AccessToken.create(resource_owner_id: user.id,
                                           refresh_token: SecureRandom.hex(32),
                                           expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
                                           scopes: '')
    token.token
  end
end
