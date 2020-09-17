class ApplicationController < ActionController::Base
  before_action { request.variant = :ios if platform.ios_app? }

  private

  helper_method def platform
    @platform ||= ApplicationPlatform.new(request.user_agent)
  end
end
