# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'iteam_ny' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

<<<<<<< HEAD
  pod 'AgoraRtcEngine_iOS', '~> 3.1.0'  
  pod 'Tabman', '~>2.11'
  pod 'Firebase/Database'

post_install do |installer|
     installer.pods_project.targets.each do |target|
         target.build_configurations.each do |config|
             config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
             config.build_settings['EXCLUDED_ARCHS[sdk=watchsimulator*]'] = 'arm64'
             config.build_settings['EXCLUDED_ARCHS[sdk=appletvsimulator*]'] = 'arm64'
             config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
             config.build_settings['ENABLE_BITCODE'] = 'NO'
         end
     end
 end


  # Pods for iteam_ny
=======
  # Pods for iteam_ny
  pod 'AgoraRtcEngine_iOS', '~> 3.1.0'
  pod 'Tabman', '~>2.11'  
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'

>>>>>>> origin
end

