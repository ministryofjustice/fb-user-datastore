class HealthController < ActionController::API
  # used for liveness probe
  def show
    render plain: 'healthy'
  end

  def readiness
    if ActiveRecord::Base.connection && ActiveRecord::Base.connected?
      render plain: 'ready'
    end
  end
end
