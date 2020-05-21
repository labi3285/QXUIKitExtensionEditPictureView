//
//  QXEditPicturesView.swift
//  Project
//
//  Created by labi3285 on 2019/11/27.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import QXUIKitExtension
import TZImagePickerController
import QXConsMaker

open class QXEditPicturesView: QXArrangeView {
    
    public var isGifEnabled: Bool = false

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
    public lazy var pictureViews: [QXImageButton] = {
        return (0..<self.maxPickCount).map { (i) -> QXImageButton in
            let e = QXImageButton()
            e.imageView.contentMode = .scaleAspectFill
            e.clipsToBounds = true
            e.fixSize = QXSize(90, 90)
            e.isDisplay = false
            e.respondClick = { [weak self] in
                if let s = self {
                    let a = NSMutableArray()
                    let b = NSMutableArray()
                    var i: Int = 0
                    for e in s.pictures {
                        if let e = e.uiImage {
                            a.add(e)
                        }
                        if let e = e.phAsset {
                            b.add(e)
                        }
                    }
                    if let vc = TZImagePickerController(selectedAssets: b, selectedPhotos: a, index: i) {
                        vc.allowPickingGif = s.isGifEnabled
                        vc.allowPickingVideo = false
                        s.uiViewController?.present(vc, animated: true, completion: nil)
                    }
                }
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
                if let vc = TZImagePickerController(maxImagesCount: s.maxPickCount, delegate: self) {
                    vc.allowPickingGif = s.isGifEnabled
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
        return e
    }()
    
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
        self.pictures = arr
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
