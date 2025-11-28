module Api
  module V1
    module Auth
      class RegistrationsController < Api::V1::BaseController
        def create
          user = User.new(sign_up_params)
          user.save!

          render json: response_payload(user), status: :created
        end

        private

        def sign_up_params
          params.require(:user).permit(:first_name, :middle_name, :last_name, :email, :password)
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
