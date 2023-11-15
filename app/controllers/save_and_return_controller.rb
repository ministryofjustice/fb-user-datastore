class SaveAndReturnController < ApplicationController
  before_action :check_saved_form_exists, except: [:create]

  def create
    saved_form = SavedForm.new(save_progress_params)

    if saved_form.save
      render json: { id: saved_form.id }, status: :created
    else
      render json: {}, status: :internal_server_error
    end
  end

  def show
    saved = existing_saved_form

    if saved.attempts >= 3
      render json: {}, status: :bad_request
    elsif saved.invalidated?
      render json: {}, status: :unprocessable_entity
    else
      render json: saved.to_json, status: :ok
    end
  end

  def increment
    saved = existing_saved_form

    if saved.attempts >= 3 || saved.invalidated?
      render json: {}, status: :unprocessable_entity
    else
      saved.increment_attempts!
      render json: {}, status: :ok
    end
  end

  def invalidate
    saved = existing_saved_form

    if saved.invalidated?
      render json: {}, status: :unprocessable_entity
    else
      saved.invalidate_user_fields!
      render json: {}, status: :accepted
    end
  end

  private

  def save_progress_params
    params.slice!(
      :email, :page_slug, :service_slug, :user_id, :user_token, :service_version,
      :secret_question, :secret_answer, :secret_question_text, :user_data_payload
    ).permit!
  end

  def existing_saved_form
    @_existing_saved_form ||= SavedForm.find_by(id: params[:uuid])
  end

  def check_saved_form_exists
    render json: {}, status: :not_found unless existing_saved_form
  end
end
