Pod::Spec.new do |spec|
  spec.name = 'SolarNOAA'
  spec.version = '1.0'
  spec.license = 'MIT'
  spec.summary = '🌞 Calculation of local times of sunrise, solar noon, sunset, azimuth, elevation based on the calculation procedure by NOAA'
  spec.homepage = 'https://github.com/rlxone/SolarNOAA'
  spec.authors = { 'Dmitry Medyuho' => 'rlxone@icloud.com' }
  spec.source = { :git => 'https://github.com/rlxone/SolarNOAA.git', :tag => spec.version }
  spec.documentation_url = 'https://github.com/rlxone/SolarNOAA'

  spec.ios.deployment_target = '9.0'
  spec.osx.deployment_target = '10.9'
  spec.tvos.deployment_target = '9.0'
  spec.watchos.deployment_target = '2.0'

  spec.swift_version = '5.0'

  spec.source_files = 'Sources/*.swift'
end