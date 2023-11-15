class SaveAndReturnController < ApplicationController
  def create
    @saved_form = SavedForm.new(save_progress_params)

    if @saved_form.save!
      render json: { id: @saved_form.id }, status: :created, format: :json
    else
      render json: {}, status: :error, format: :json
    end
  end

  def show
    @saved = SavedForm.find(params[:uuid])

    render json: {}, status: :not_found, format: :json if @saved == nil and return

    if @saved.attempts >= 3
      render json: {}, status: :bad_request, format: :json and return
    end

    if @saved.invalidated?
      render json: {}, status: :unprocessable_entity, format: :json and return
    end

    render json: @saved.to_json, status: :ok, format: :json
  end

  def increment
    @saved = SavedForm.find(params[:uuid])

    render json: {}, status: :not_found, format: :json if @saved == nil and return

    if @saved.attempts.to_i >= 3 || @saved.invalidated?
      render json: {}, status: :unprocessable_entity, format: :json and return
    end

    @saved.increment_attempts!

    render json: {}, status: :ok, format: :json
  end

  def invalidate
    @saved = SavedForm.find(params[:uuid])

    render json: {}, status: :not_found, format: :json if @saved == nil and return

    if @saved.invalidated?
      render json: {}, status: :unprocessable_entity, format: :json and return
    end

    @saved.invalidate_user_fields!

    render json: {}, status: :accepted, format: :json
  end

  private

  def save_progress_params
    params.slice!(
      :email, :page_slug, :service_slug, :user_id, :user_token, :service_version,
      :secret_question, :secret_answer, :secret_question_text, :user_data_payload
    ).permit!
  end
end
