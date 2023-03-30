class SaveAndReturnController < ApplicationController
  def create
    @saved_form = SavedForm.new(params)
    
    @saved_form.save!

    render json: { id: @saved_form.uuid }, status: :created, format: :json
  end

  def destroy
  end
end
