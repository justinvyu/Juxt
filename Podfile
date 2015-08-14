# Uncomment this line to define a global platform for your project
# platform :ios, '6.0'

use_frameworks!

post_install do | installer |
 require 'fileutils'
 FileUtils.cp_r('Pods/Target Support Files/Pods-Juxt/Pods-Juxt-acknowledgements.plist', 'Juxt/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end

target 'Juxt' do

	pod 'Parse'
	pod 'ParseUI'
	pod 'FBSDKCoreKit'
	pod 'FBSDKLoginKit'
	pod 'FBSDKShareKit'
	pod 'ConvenienceKit'
	pod 'LLSimpleCamera', '~> 3.0'
	pod 'TGCameraViewController'
	pod 'ParseFacebookUtils'
	pod 'AMScrollingNavbar'
	pod 'Mixpanel'
	pod 'Fabric'
	pod 'TwitterKit'
	pod 'TwitterCore'
	pod 'MPCoachMarks'
	pod 'Bond'
	pod 'SCLAlertView'
	pod 'FLAnimatedImage'

end

target 'JuxtTests' do

end
