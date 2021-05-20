require 'rails_helper'

RSpec.describe ActionController::Base do
  context 'when there is an error' do
    controller do
      include Concerns::ErrorHandling

      def index
        raise StandardError.new
      end
    end

    it 'calls sentry with exception' do
      expect(Sentry).to receive(:capture_exception).and_return(nil)
      get :index, format: :json
    end
  end

  context 'when there is no error' do
    controller do
      include Concerns::ErrorHandling

      def index
      end
    end

    it 'does not call Sentry' do
      expect(Sentry).to_not receive(:capture_exception)
      get :index, format: :json
    end
  end
end
