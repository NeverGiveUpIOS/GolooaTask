//
//  TaskBaseStepCell.swift
//  Golaa
//
//  Created by duke on 2024/5/16.
//

import UIKit

class TaskBaseStepCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() {
        contentView.addSubview(stepLabel)
        
        stepLabel.snp.makeConstraints { make in
            make.leading.equalTo(19)
            make.top.equalTo(3)
            make.width.equalTo(40)
            make.height.equalTo(23)
        }
    }
    
    var model: TaskStepModel?
    func bind(_ model: TaskStepModel) {
        self.model = model
        self.stepLabel.text = "No.\(model.stepNum)"
    }
    
    lazy var stepLabel: UILabel = {
        let lab = UILabel()
        lab.backgroundColor = .hexStrToColor("#5B6FA3")
        lab.textColor = .white
        lab.font = UIFontReg(12)
        lab.textAlignment = .center
        lab.gt.setCornerRadius(11.5)
        return lab
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
      
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }

}
