//
//  QXSettingTitlePictureCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import QXUIKitExtension
import QXConsMaker
import TZImagePickerController

open class QXSettingTitlePictureCell: QXSettingCell {

    public final lazy var titleLabel: QXLabel = {
        let e = QXLabel()
        e.numberOfLines = 1
        e.minHeight = 999
        e.alignmentY = .top
        e.padding = QXEdgeInsets(10, 0, 10, 0)
        e.font = QXFont(fmt: "16 #333333")
        return e
    }()

    public final lazy var pictureView: QXEditPictureView = {
        let e = QXEditPictureView()
        e.fixSize = QXSize(90, 90)
        return e
    }()
        
    public final lazy var layoutView: QXStackView = {
        let e = QXStackView()
        e.alignmentY = .center
        e.alignmentX = .left
        e.viewMargin = 10
        e.padding = QXEdgeInsets(5, 15, 5, 15)
        e.views = [self.titleLabel, QXFlexSpace(), self.pictureView]
        return e
    }()
    
    required public init() {
        super.init()
        contentView.addSubview(layoutView)
        layoutView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        fixHeight = 120
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
