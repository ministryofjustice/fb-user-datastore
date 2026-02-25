class UserDataController < ApplicationController
  before_action :verify_jwt_subject!

  def show
    user_data = UserData.find_by!(record_retrieval_params)

    render json: ::UserDataPresenter.new(user_data), status: :ok
  end

  # To keep things simple and fast on the client, we'll transparently
  # handle create or update in one method, called via POST
  def create_or_update
    user_data = UserData.find_or_initialize_by(record_retrieval_params)
    success_status = user_data.persisted? ? :ok : :created

    user_data.payload = params[:payload]
    user_data.save!

    render json: {}, status: success_status, format: :json
  end

  private

  def verify_jwt_subject!
    unless @jwt_payload['sub'] == record_retrieval_params[:user_identifier]
      raise Concerns::JWTAuthentication::SubjectMismatchError
    end
  end

  def record_retrieval_params
    {
      user_identifier: params[:user_id],
      service_slug: params[:service_slug]
    }
  end
end
