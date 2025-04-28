//
//  ReleTaskAddPicView.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/25.
//

import UIKit

class ReleTaskAddPicView: UIView, GTNibLoadable {
    
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var addPic: UIButton!
    @IBOutlet weak var addPicImg: UIImageView!
    @IBOutlet weak var clearBtn: UIButton!
    
    var callResult: ReleTaskStepViewCllImg?
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        addPic.gt.setImageTitlePos(.imgTop, spacing: 13)
    }
    
    @IBAction func addPicClick(_ sender: Any) {
       getTopController().view.gt.keyboardEnd()
        PictureTl.shared.showAlertPic()
        PictureTl.shared.callImgBlock = { [weak self] img in
            self?.addPicImg.image = img
            self?.addPicImg.isHidden = false
            self?.clearBtn.isHidden = false
            self?.callResult?(img)
        }
    }
    @IBAction func clearBtnClick(_ sender: Any) {
        addPicImg.image = nil
        addPicImg.isHidden = true
        clearBtn.isHidden = true
        callResult?(nil)
    }
    
}
