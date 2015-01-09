Pod::Spec.new do |s|

  s.name         = "mango-ios"
  s.version      = "0.1.0"
  s.summary      = "This is the iOS SDK that allows interaction with Mango API."

  s.description  = <<-DESC
                   This is the iOS SDK that allows interaction with Mango API.
                   For more information https://developers.getmango.com
                   DESC

  s.homepage     = "https://developers.getmango.com"
  s.license      = { :type => "MIT", :file => "LICENSE.MD" }

  s.authors    = { 'Ezequiel Becerra' => 'ezequiel.becerra@gmail.com', 'Gonzalo Larralde' => 'gonzalolarralde@gmail.com' }
  s.social_media_url   = "https://twitter.com/getmango"

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/mango/mango-ios.git", :tag => "0.1.0" }

  s.source_files  = "mango-ios/src/*.{h,m}"
  s.public_header_files = "mango-ios/src/*.{h,m}"

  s.requires_arc = true
  s.dependency "AFNetworking", "~> 2.5"

end
