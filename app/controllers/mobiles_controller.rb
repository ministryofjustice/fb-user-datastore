class MobilesController < ApplicationController
  def create
    supersede_existing_mobiles

    mobile_data = Mobile.new(service_slug: params[:service_slug],
                             encrypted_email: params[:encrypted_email],
                             encrypted_payload: params[:encrypted_details],
                             expires_at: expires_at)

    if mobile_data.save
      render json: { code: mobile_data.code }, status: :created
    else
      unavailable_error
    end
  end

  private

  def expires_at
    Time.now + duration
  end

  def duration
    if params[:duration]
      params[:duration].to_i.minutes
    else
      default_duration
    end
  end

  def default_duration
    30.minutes
  end

  def mobile_record_params
    {
      service_slug: params[:service_slug],
      encrypted_email: params[:encrypted_email]
    }
  end

  def supersede_existing_mobiles
    mobiles = Mobile.where(mobile_record_params)
    mobiles.update_all(validity: 'superseded')
  end

  def unavailable_error
    render json: { code: 503, name: 'unavailable' }, status: 503
  end
end