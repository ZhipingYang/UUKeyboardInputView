Pod::Spec.new do |s|
s.name         = 'UUKeyboardInputView'
s.summary      = 'assist custom views respond keyboard as inputview liked'
s.description      = <<-DESC
UUKeyboardInputView helps some views,like button、cell、segment, which cann't respond those inputView as textField or texeView them do.
                       DESC
s.version      = '0.1.2'
s.homepage     = "https://github.com/ZhipingYang/UUKeyboardInputView"
s.license      = 'MIT'
s.authors      = { 'ZhipingYang' => 'XcodeYang@gmail.com' }
s.platform     = :ios, '8.0'
s.ios.deployment_target = '8.0'
s.source       = { :git => 'https://github.com/ZhipingYang/UUKeyboardInputView.git', :tag => s.version.to_s }

s.requires_arc = true

s.source_files = 'UUKeyboardInputView/**/*'

s.frameworks = 'UIKit'

end
