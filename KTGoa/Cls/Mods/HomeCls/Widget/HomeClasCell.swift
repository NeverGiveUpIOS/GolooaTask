//
//  HomeClasCell.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/24.
//

import UIKit

class HomeClasCell: UITableViewCell {

    @IBOutlet weak var taskImg: UIImageView!
    @IBOutlet weak var tsakname: UILabel!
    @IBOutlet weak var taskdes: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var peoNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    var model: HomeListModel? {
        didSet {
            guard let model = model else { return }
            tsakname.text = model.name
            taskdes.text = model.intro
            progress.progress = Float(CGFloat(model.receCount)/CGFloat(model.num))
            peoNumber.text = "\(model.receCount)/\(model.num)"
            taskImg.imageWithUrl(withURL: model.img)
        }
    }
    
    @IBAction func chat(_ sender: Any) {
        RoutinStore.push(.singleChat, param: model?.userId ?? "")

    }
    
    
}
