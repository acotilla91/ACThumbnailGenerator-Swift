Pod::Spec.new do |s|
  s.name             = 'ACThumbnailGenerator-Swift'
  s.version          = '1.0.0'
  s.summary          = 'Swift utility for extracting still images from remote video streams (e.g. HLS/.m3u8 streams).'

  s.description      = <<-DESC
ACThumbnailGenerator is an easy-to-use Swift utility for extracting still images (as UIImage) from remote video streams (e.g. HLS/.m3u8 streams) on iOS apps.
                       DESC

  s.homepage         = 'https://github.com/acotilla91/ACThumbnailGenerator-Swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alejandro Cotilla' => 'acotilla91@gmail.com' }
  s.source           = { :git => 'https://github.com/acotilla91/ACThumbnailGenerator-Swift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/acotilla91'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ACThumbnailGenerator-Swift/Classes/**/*'

end
