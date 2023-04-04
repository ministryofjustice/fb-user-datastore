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

  def save_progress_params
    params.permit!
    params[:save_and_return].to_h
  end

  def destroy
  end
end
