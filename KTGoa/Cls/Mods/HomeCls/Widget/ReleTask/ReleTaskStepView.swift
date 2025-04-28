//
//  ReleTaskStepView.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/25.
//

import UIKit

public typealias ReleTaskStepViewCllImg  = (_ any: UIImage?) -> ()

class ReleTaskStepView: UIView, GTNibLoadable {
    
    @IBOutlet weak var steplab: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addPic: UIButton!
    
    @IBOutlet weak var addPicImg: UIImageView!
    @IBOutlet weak var deleStepBtn: UIButton!
    @IBOutlet weak var clearIMgBtn: UIButton!
    
    var addImage: UIImage?
    
    var callDelStepBlock: CallBackVoidBlock?
    var callEditStepBlock: CallBackVoidBlock?

    var callResult: ReleTaskStepViewCllImg?

    override func layoutSubviews() {
        super.layoutSubviews()
        steplab.layer.cornerRadius = 6
        steplab.clipsToBounds = true;
    }
    
    @IBAction func editClick(_ sender: Any) {
       getTopController().view.gt.keyboardEnd()
        callEditStepBlock?()
    }
    
    @IBAction func addPicClick(_ sender: Any) {
        PictureTl.shared.showAlertPic()
        PictureTl.shared.callImgBlock = { [weak self] img in
            self?.clearIMgBtn.isHidden = false
            self?.addPicImg.isHidden = false
            self?.addPicImg.image = img
            self?.callResult?(img)
           getTopController().view.gt.keyboardEnd()
        }
    }
    
    @IBAction func delButtonClick(_ sender: Any) {
        callDelStepBlock?()
    }
    
    @IBAction func delImgCLick(_ sender: Any) {
        clearIMgBtn.isHidden = true
        addPicImg.isHidden = true
        addPicImg.image = nil
        addImage = nil
        callResult?(nil)
    }
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        addPic.gt.setImageTitlePos(.imgTop, spacing: 13)
    }
    
}
