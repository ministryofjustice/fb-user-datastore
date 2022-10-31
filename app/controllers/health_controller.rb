class HealthController < ActionController::API
  # used for liveness probe
  def show
    render plain: 'healthy'
  end

  def readiness
    render plain: 'ready'
  end
end
