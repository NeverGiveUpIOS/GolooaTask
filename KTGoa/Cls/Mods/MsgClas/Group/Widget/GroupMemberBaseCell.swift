//
//  GroupMemberBaseCell.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/24.
//

import UIKit

class GroupMemberBaseCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() {  }
    
    // MARK: -
    // MARK: Lazy
    lazy var avatar: UIImageView = {
        let img = UIImageView()
        img.gt.setCornerRadius(50 * 0.5)
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .xf2
        return img
    }()
    
    lazy var nameLabel: UILabel = {
        let lab = UILabel()
        lab.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        lab.font = UIFontSemibold(15)
        lab.textColor = .hexStrToColor("#000000")
        return lab
    }()
}
