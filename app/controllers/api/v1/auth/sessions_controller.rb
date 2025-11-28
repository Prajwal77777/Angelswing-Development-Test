module Api
  module V1
    module Auth
      class SessionsController < Api::V1::BaseController
        def create
          user = User.find_by(email: signin_params[:email]&.downcase)

          unless user&.authenticate(signin_params[:password])
            return render_error(
              status: :unauthorized,
              code: "invalid_credentials",
              message: "Invalid email or password"
            )
          end

          render json: response_payload(user), status: :ok
        end

        private

        def signin_params
          params.require(:user).permit(:email, :password)
        end

        def response_payload(user)
          {
            user: UserSerializer.new(user).as_json,
            token: JsonWebToken.encode(user_id: user.id)
          }
        end
      end
    end
  end
end
