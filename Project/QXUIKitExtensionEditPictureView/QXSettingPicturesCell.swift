//
//  QXSettingPicturesCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import QXUIKitExtension
import QXConsMaker

open class QXSettingPicturesCell: QXSettingCell {
    
    open override func height(_ model: Any?) -> CGFloat? {
        picturesView.fixWidth = context.givenWidth
        return picturesView.natureSize.h
    }
    
    public final lazy var picturesView: QXEditPicturesView = {
        let e = QXEditPicturesView(maxPickCount: self.maxPickCount, isAddButtonAtLast: self.isAddButtonAtLast)
        e.padding = QXEdgeInsets(10, 15, 10, 15)
        e.respondNeedsLayout = { [weak self] in
            self?.context?.tableView?.setNeedsUpdate()
        }
        return e
    }()
    
    public let maxPickCount: Int
    public let isAddButtonAtLast: Bool

    required public init() {
        self.maxPickCount = 9
        self.isAddButtonAtLast = true
        super.init()
        contentView.addSubview(picturesView)
        picturesView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        fixHeight = nil
    }
    required public init(maxPickCount: Int, isAddButtonAtLast: Bool) {
        self.maxPickCount = maxPickCount
        self.isAddButtonAtLast = isAddButtonAtLast
        super.init()
        contentView.addSubview(picturesView)
        picturesView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        fixHeight = nil
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
