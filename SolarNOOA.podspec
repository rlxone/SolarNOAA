Pod::Spec.new do |s|
  s.name = 'SolarNOAA'
  s.version = '1.0'
  s.license = 'MIT'
  s.summary = '🌞 Calculation of local times of sunrise, solar noon, sunset, azimuth, elevation based on the calculation procedure by NOAA'
  s.homepage = 'https://github.com/rlxone/SolarNOAA'
  s.authors = { 'Dmitry Medyuho' => 'rlxone@icloud.com' }
  s.source = { :git => 'https://github.com/rlxone/SolarNOAA.git', :tag => s.version }
  s.documentation_url = 'https://github.com/rlxone/SolarNOAA'

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Sources/*.swift'
end