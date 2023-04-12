class SaveAndReturnController < ApplicationController
  def create
    @saved_form = SavedForm.new(save_progress_params.except(:validation_context).except(:errors))
    render json: {}, status: :bad_request, format: :json and return if !@saved_form.valid?

    if @saved_form.save!
      render json: { id: @saved_form.id }, status: :created, format: :json
    else
      render json: {}, status: :error, format: :json
    end
  end
  
  def show
    @saved = SavedForm.find(params[:uuid])

    render json: {}, status: :not_found, format: :json if @saved == nil and return

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

  def save_progress_params
    params.permit!
    params[:save_and_return].to_h
  end

  def destroy
  end
end
