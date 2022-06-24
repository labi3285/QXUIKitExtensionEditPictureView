//
//  QXEditPicturesView.swift
//  Project
//
//  Created by labi3285 on 2019/11/27.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import QXUIKitExtension
import QXUIKitExtensionPictureView
import QXDSImageBrowse
import TZImagePickerController
import QXConsMaker

open class QXEditPicturesView: QXArrangeView {
    
    public var isGifEnabled: Bool = false
    
    public var isCameraOnly: Bool = false

    public var respondChange: ((_ images: [QXImage]) -> ())?

    public let maxPickCount: Int
    
    public let isAddButtonAtLast: Bool
    
    open var itemSize: QXSize {
        set {
            for e in pictureViews {
                e.fixSize = newValue
            }
            addView.fixSize = newValue
        }
        get {
            return addView.fixSize ?? QXSize.zero
        }
    }
        
    public var pictures: [QXImage] {
        set {
            for e in pictureViews {
                e.isDisplay = false
            }
            addView.isDisplay = newValue.count < maxPickCount
            for (i, e) in newValue.enumerated() {
                if i < maxPickCount {
                    let v = pictureViews[i]
                    v.isDisplay = true
                    v.image = e
                }
            }
            qxSetNeedsLayout()
        }
        get {
            return pictureViews.compactMap { $0.isDisplay ? $0.image : nil }
        }
    }
        
    public lazy var closeButtons: [QXImageButton] = {
        return (0..<self.maxPickCount).map { (i) -> QXImageButton in
            let e = QXImageButton()
            e.padding = QXEdgeInsets(3, 3, 7, 7)
            e.fixSize = QXSize(30, 30)
            e.imageView.placeHolderImage = QXUIKitExtensionEditPictureViewResources.shared.image("icon_close_red")
            e.respondClick = { [weak self] in
                if let s = self {
                    s.pictureViews[i].image = nil
                    s.pictureViews[i].isDisplay = false
                    let pics = s.pictures
                    s.pictures = pics
                    s.addView.isDisplay = s.pictures.count < s.maxPickCount
                    s.qxSetNeedsLayout()
                    s.respondChange?(s.pictures)
                }
            }
            return e
        }
    }()
    public lazy var pictureViews: [QXPictureView] = {
        return (0..<self.maxPickCount).map { (i) -> QXPictureView in
            let e = QXPictureView()
            e.uiImageView.contentMode = .scaleAspectFill
            e.clipsToBounds = true
            e.fixSize = QXSize(90, 90)
            e.isDisplay = false
            e.respondPreview = { [weak self] in
                self?.handlePreview(i)
            }
            e.addSubview(self.closeButtons[i])
            self.closeButtons[i].IN(e).RIGHT.TOP.MAKE()
            return e
        }
    }()
    public lazy var addView: QXImageButton = {
        let e = QXImageButton()
        e.fixSize = QXSize(90, 90)
        e.imageView.contentMode = .scaleAspectFill
        e.clipsToBounds = true
        e.imageView.placeHolderImage = QXUIKitExtensionEditPictureViewResources.shared.image("icon_add_pic")
        e.respondClick = { [weak self] in
            if let s = self {
                let c = s.maxPickCount - s.pictures.compactMap({ $0.phAsset == nil ? $0 : nil }).count                
                if s.isCameraOnly {
                    switch AVCaptureDevice.authorizationStatus(for: .video) {
                    case .notDetermined, .authorized:
                        let cameraPicker = UIImagePickerController()
                        cameraPicker.delegate = self
                        cameraPicker.sourceType = .camera
                        s.uiViewController?.present(cameraPicker, animated: true, completion: nil)
                    default:
                        let alert = QXAlertController.confirm("提示", "您的相机访问受限，请检查设置", QXAction("去设置", {
                            QXDevice.openUrl(UIApplication.openSettingsURLString, s.uiViewController)
                        }), "取消")
                        s.uiViewController?.present(alert, animated: true, completion: nil)
                    }
                } else {
                    if let vc = TZImagePickerController(maxImagesCount: c, delegate: self) {
                        vc.allowPickingGif = s.isGifEnabled
                        vc.allowTakePicture = true
                        vc.showSelectedIndex = true
                        vc.alwaysEnableDoneBtn = true
                        vc.allowPickingVideo = false
                        let b = NSMutableArray()
                        for e in s.pictures {
                            if let e = e.phAsset {
                                b.add(e)
                            }
                        }
                        vc.selectedAssets = b
                        s.uiViewController?.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
        return e
    }()
    
    open func handlePreview(_ currentIndex: Int) {
        var items: [DSImageScrollItem] = []
        var newIndex: Int = 0
        for (i, view) in pictureViews.enumerated() {
            if view.isDisplay {
                let item = DSImageScrollItem()
                item.localImage = view.image?.uiImage
                item.largeImageURL = view.image?.url?.nsURL
                let thumbView = view.uiImageView
                item.largeImageSize = thumbView.size
                item.thumbView = thumbView
                item.isVisibleThumbView = true
                items.append(item)
                if i < currentIndex {
                     newIndex += 1
                }
            }
        }
        let view = DSImageShowView(items: items, type: .showTypeDefault)
        var container = uiViewController?.navigationController?.view
        if container == nil {
            container = uiViewController?.view
        }
        let thumbView = pictureViews[currentIndex].uiImageView
        if container != nil {
            view?.presentfromImageView(thumbView, toContainer: container, index: newIndex, animated: true, completion: {
            })
        }
    }
    
    public required init(maxPickCount: Int, isAddButtonAtLast: Bool) {
        self.maxPickCount = maxPickCount
        self.isAddButtonAtLast = isAddButtonAtLast
        super.init()
        if (isAddButtonAtLast) {
            views = pictureViews + [addView]
        } else {
            views = [addView] + pictureViews
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
            
}

extension QXEditPicturesView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let image = QXImage(uiImage)
            self.pictures.append(image)
            qxSetNeedsLayout()
            respondChange?(pictures)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension QXEditPicturesView: TZImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        var arr: [QXImage] = []
        for (i, photo) in photos!.enumerated() {
            let image = QXImage(photo)
            if let asset = assets[i] as? PHAsset {
                image.setPHAsset(asset)
            }
            arr.append(image)
        }
        self.pictures = self.pictures.compactMap({ $0.phAsset == nil ? $0 : nil }) + arr
        qxSetNeedsLayout()
        //respondChangeSize?()
        respondChange?(pictures)
    }
    public func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
    }

    public func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingGifImage animatedImage: UIImage!, sourceAssets asset: PHAsset!) {
        let image = QXImage(animatedImage)
        if let asset = asset {
           image.setPHAsset(asset)
        }
        if (isAddButtonAtLast) {
            self.pictures = self.pictures + [image]
        } else {
            self.pictures = [image] + self.pictures
        }
        qxSetNeedsLayout()
        //tableView?.setNeedsUpdate()
        respondChange?(pictures)
    }
    
}
