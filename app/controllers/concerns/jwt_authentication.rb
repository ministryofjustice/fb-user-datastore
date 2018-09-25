module Concerns
  module JWTAuthentication
    extend ActiveSupport::Concern

    included do
      before_action :verify_token!

      if ancestors.include?(Concerns::ErrorHandling)
        rescue_from Exceptions::TokenNotPresentError do |e|
          render_json_error :unauthorized, :token_not_present
        end
        rescue_from Exceptions::TokenNotValidError do |e|
          render_json_error :forbidden, :token_not_valid
        end
      end
    end

    private

    # may raise any of:
    #   TokenInvalidError
    #   TokenNotPresentError
    #
    def verify_token!(token: request.headers['x-access-token'],
                      args: params,
                      leeway: ENV['MAX_IAT_SKEW_SECONDS'])

      raise Exceptions::TokenNotPresentError.new unless token.present?

      begin
        hmac_secret = get_service_token(params[:service_slug])
        payload, header = decoded_token = JWT.decode(
          token,
          hmac_secret,
          true,
          {
            exp_leeway: leeway,
            algorithm: 'HS256'
          }
        )

        # NOTE: verify_iat used to be in the JWT gem, but was removed in v2.2
        # so we have to do it manually
        if (payload['iat'] - Time.current.to_i).abs > leeway
          raise Exceptions::TokenNotValidError.new
        end
      rescue StandardError => e
        raise Exceptions::TokenNotValidError.new
      end
    end

    def get_service_token(service_slug)
      ServiceTokenService.get(service_slug)
    end
  end
end