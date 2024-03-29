#
# Be sure to run `pod lib lint BRProgressDiscount.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BRProgressDiscount'
  s.version          = '0.0.5'
  s.summary          = '折扣进度'

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

  #  s.description      = <<

  s.homepage         = 'https://github.com/burning-git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'burning_git@163.com' => 'burning_git@163.com' }
  s.source           = { :git => 'https://github.com/burning-git/BRProgressDiscountView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, "9.0"
  s.swift_version = '4.2'
  s.source_files = 'BRProgressDiscountViewProject/BRProgressDiscountView/**/*'
  
  # s.resource_bundles = {
  #   'BRProgressDiscount' => ['BRProgressDiscount/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

end 
