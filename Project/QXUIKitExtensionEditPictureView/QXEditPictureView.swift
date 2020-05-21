//
//  QXEditPictureView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/30.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import QXUIKitExtension
import TZImagePickerController
import QXConsMaker

open class QXEditPictureView: QXImageButton {
            
    public var isGifEnabled: Bool = false
    
    public var isEditEnabled: Bool = false
    public var editSize: QXSize = QXSize(min(UIScreen.main.bounds.height, UIScreen.main.bounds.width) - 15 * 2, min(UIScreen.main.bounds.height, UIScreen.main.bounds.width) - 15 * 2)

    open override var image: QXImage? {
        didSet {
            super.image = image
            closeButton.isHidden = image != nil
            qxSetNeedsLayout()
        }
    }
    public var respondChange: ((_ image: QXImage?) -> ())?

    public final lazy var closeButton: QXImageButton = {
        let e = QXImageButton()
        e.padding = QXEdgeInsets(3, 3, 7, 7)
        e.fixSize = QXSize(30, 30)
        e.imageView.placeHolderImage = QXUIKitExtensionEditPictureViewResources.shared.image("icon_close_red")
        e.isHidden = true
        e.respondClick = { [weak self] in
            self?.image = nil
            self?.closeButton.isHidden = true
            self?.respondChange?(nil)
        }
        return e
    }()
    
    public override init() {
        super.init()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.placeHolderImage = QXUIKitExtensionEditPictureViewResources.shared.image("icon_add_pic")
        respondClick = { [weak self] in
            if let s = self {
                if let vc = TZImagePickerController(maxImagesCount: 1, delegate: self) {
                    vc.allowPickingGif = s.isGifEnabled
                    vc.allowCrop = s.isEditEnabled
                    vc.allowPickingVideo = false
                    s.uiViewController?.present(vc, animated: true, completion: nil)
                    if s.isEnabled {
                        let x = (vc.view.frame.width - s.editSize.w) / 2
                        let y = (vc.view.frame.height - s.editSize.h) / 2
                        vc.cropRect = CGRect(x: x, y: y, width: s.editSize.w, height: s.editSize.h)
                    }
                }
            }
        }
        addSubview(closeButton)
        closeButton.IN(self).RIGHT.TOP.MAKE()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension QXEditPictureView: TZImagePickerControllerDelegate {
    
    // The picker should dismiss itself; when it dismissed these callback will be called.
    // You can also set autoDismiss to NO, then the picker don't dismiss itself.
    // If isOriginalPhoto is YES, user picked the original photo.
    // You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
    // The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
    // 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
    // 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
    // 如果isSelectOriginalPhoto为YES，表明用户选择了原图
    // 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
    // photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
    
    public func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        if let photo = photos.first {
            let image = QXImage(photo)
            if let asset = assets.first as? PHAsset {
                image.setPHAsset(asset)
            }
            self.image = image
            closeButton.isHidden = false
            respondChange?(image)
        }
    }
    public func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
    }

    // 如果用户选择了一个gif图片且allowPickingMultipleVideo是NO，下面的代理方法会被执行
    // 如果allowPickingMultipleVideo是YES，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
    public func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingGifImage animatedImage: UIImage!, sourceAssets asset: PHAsset!) {
        let image = QXImage(animatedImage)
        if let asset = asset {
            image.setPHAsset(asset)
        }
        self.image = image
        closeButton.isHidden = false
        respondChange?(image)
    }
    
}
