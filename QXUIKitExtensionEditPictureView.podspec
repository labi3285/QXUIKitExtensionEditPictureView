Pod::Spec.new do |s|

s.swift_versions = "5.0"

s.name         = "QXUIKitExtensionEditPictureView"
s.version      = "0.1.0"
s.summary      = "QXEditPictrueView UIs base on QXUIKitExtension & TZImagePickerController swift5."
s.description  = <<-DESC
UIKit extensions in swift. Just enjoy!
DESC
s.homepage     = "https://github.com/labi3285/QXUIKitExtensionEditPictureView"
s.license      = "MIT"
s.author       = { "labi3285" => "766043285@qq.com" }
s.platform     = :ios, "9.0"
s.source       = { :git => "https://github.com/labi3285/QXUIKitExtensionEditPictureView.git", :tag => "#{s.version}" }
s.source_files = "Project/QXUIKitExtensionEditPictureView/*"

s.resources = "Project/QXUIKitExtensionEditPictureView/QXUIKitExtensionEditPictureViewResources.bundle"
s.requires_arc = true

s.dependency 'QXUIKitExtension'
s.dependency 'QXUIKitExtensionPictureView'
s.dependency 'TZImagePickerController' , '~> 3.7.6'

# pod trunk push QXUIKitExtensionEditPictureView.podspec --allow-warnings

end

