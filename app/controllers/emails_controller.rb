class EmailsController < ApplicationController
  DEFAULT_DURATION = 120 # minutes

  def add
    supersede_existing_records

    return render_email_missing unless params[:encrypted_email]
    return render_details_missing unless params[:encrypted_details]

    email_data = Email.new(
      encrypted_email: params[:encrypted_email],
      service_slug: params[:service_slug],
      encrypted_payload: params[:encrypted_details],
      expires_at: expires_at,
      validity: 'valid'
    )

    if email_data.save
      return render json: { token: email_data.id }, status: :created
    else
      return unavailable_error
    end
  end

  def validate
    email = Email.find_by_id(params[:email_token])

    return render_link_invalid unless email
    return render_expired if email.expired?
    return render_used if email.used?
    return render_superseded if email.superseded?

    email.mark_as_used

    render json: { encrypted_details: email.encrypted_payload }, status: :ok
  end

  private

  def render_email_missing
    render json: { code: 401,
                   name: 'email.missing' }, status: 401
  end

  def render_details_missing
    render json: { code: 401,
                   name: 'details.missing' }, status: 401
  end

  def render_link_invalid
    render json: { code: 401,
                   name: 'token.invalid' }, status: 401
  end

  def render_expired
    render json: { code: 401,
                   name: 'token.expired'}, status: 401
  end

  def render_used
    render json: { code: 401,
                   name: 'token.used'}, status: 401
  end

  def render_superseded
    render json: { code: 401,
                   name: 'token.superseded'}, status: 401
  end

  def expires_at
    Time.now + duration
  end

  def duration
    params.fetch(:duration, DEFAULT_DURATION).to_i.minutes
  end

  def supersede_existing_records
    emails = Email.where(record_retrieval_params)
    emails.update_all(validity: 'superseded')
  end

  def record_retrieval_params
    {
      encrypted_email: params[:encrypted_email],
      service_slug: params[:service_slug]
    }
  end

  def unavailable_error
    render json: { code: 503,
                   name: 'unavailable' }, status: 503
  end
end
