#
# Be sure to run `pod lib lint XBChatModule.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "XBChatModule"
  s.version          = "0.1.2.1"
  s.summary          = "Integrated XMPP and JSQMessageController"
  s.description      = <<-DESC
                       Using XMPPFramework & JSQMessageController, super easy to use
                       DESC
  s.homepage         = "https://github.com/EugeneNguyen/XBChatModule"
  s.license          = 'MIT'
  s.author           = { "eugenenguyen" => "xuanbinh91@gmail.com" }
  s.source           = { :git => "https://github.com/EugeneNguyen/XBChatModule.git", :tag => s.version.to_s }

  s.xcconfig                   = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2'}
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'XBChatModule' => ['Pod/Assets/*.png']
  }

  s.social_media_url = 'https://twitter.com/LIBRETeamStudio'
  s.library = 'xml2'
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'XMPPFramework'
  s.dependency 'JSQMessagesViewController'
  s.dependency 'SDWebImage'
end