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
    
    public var isEnableGif: Bool = false

    public var respondChange: ((_ images: [QXImage]) -> ())?

    public let maxPickCount: Int
    
    public let isAddButtonAtLast: Bool
        
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
            return pictureViews.compactMap { $0.image }
        }
    }
        
    public lazy var closeButtons: [QXImageButton] = {
        return (0..<self.maxPickCount).map { (i) -> QXImageButton in
            let e = QXImageButton()
            e.padding = QXEdgeInsets(5, 5, 5, 5)
            e.fixSize = QXSize(30, 30)
            e.image = QXUIKitExtensionResources.shared.image("icon_close_red")
            e.respondClick = { [weak self] in
                if let s = self {
                    s.pictureViews[i].image = nil
                    s.pictureViews[i].isDisplay = false
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
            e.tag = i
            e.fixSize = QXSize(100, 100)
            e.isDisplay = false
            e.respondClick = { [weak self] in
                if let s = self {
                    let a = NSMutableArray()
                    let b = NSMutableArray()
                    for e in s.pictures {
                        if let e = e.uiImage {
                            a.add(e)
                        }
                        if let e = e.phAsset {
                            b.add(e)
                        }
                    }
                    if let vc = TZImagePickerController.init(selectedAssets: b, selectedPhotos: a, index: i) {
                        vc.allowPickingGif = s.isEnableGif
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
        e.fixSize = QXSize(100, 100)
        e.imageView.contentMode = .scaleAspectFill
        e.image = QXUIKitExtensionResources.shared.image("icon_add_pic")
        e.respondClick = { [weak self] in
            if let s = self {
                let c = s.maxPickCount - s.pictures.count
                if let vc = TZImagePickerController(maxImagesCount: c, delegate: self) {
                    vc.allowPickingGif = s.isEnableGif
                    vc.showSelectedIndex = true
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
