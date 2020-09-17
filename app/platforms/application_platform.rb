class ApplicationPlatform < PlatformAgent
  def ios_app?
    match? /RecItRalph iOS/
  end

  def bridge_name
    :ios if ios_app?
  end
end
