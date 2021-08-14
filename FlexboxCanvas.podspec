#
# Be sure to run `pod lib lint FlexboxCanvas.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FlexboxCanvas'
  s.version          = '0.2.0'
  s.summary          = 'A UI development framework based on XML description and flexbox layout for iOS.'
  
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.description      = <<-DESC
1. Flexbox layout;
2. XML describe UI;
3. Layout algorithm is customizable;
4. Virtual view element: <Box>;
5. XML element attributes support variables;
6. <View> element support events;
7. <View> element can describe native view by `nativeView` prop attribute;
8. Native code can refer to <View> element by `onRef` event attribute.
                       DESC
  
  s.homepage         = 'https://github.com/mymong/FlexboxCanvas'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mymong' => 'mymong@163.com' }
  s.source           = { :git => 'https://github.com/mymong/FlexboxCanvas.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '8.0'
  
  s.source_files = 'FlexboxCanvas/*.h'
  s.public_header_files = 'FlexboxCanvas/*.h'
  
  s.subspec 'Foundation' do |p|
    p.source_files = 'FlexboxCanvas/Foundation/**/*'
    p.dependency 'TBXML', '~> 1.5'
  end
  
  s.subspec 'Node_Yoga_1_14' do |p|
    p.source_files = 'FlexboxCanvas/Node_Yoga_1_14'
    p.dependency 'FlexboxCanvas/Foundation'
    p.dependency 'Yoga', '~> 1.14'
  end
  
end
