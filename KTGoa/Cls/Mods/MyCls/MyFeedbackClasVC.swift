//
//  MyFeedbackClasVC.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/25.
//

import UIKit

class MyFeedbackClasVC: BasClasVC, UITextViewDelegate {

    @IBOutlet weak var textPlaceText: UILabel!
    @IBOutlet weak var inputNumber: UILabel!
    @IBOutlet weak var edutTextView: UILabel!
    @IBOutlet weak var addPicImg: UIImageView!
    @IBOutlet weak var addPic: UIButton!
    @IBOutlet weak var clearPicBtn: UIButton!
    
    var addImage: UIImage?
    var editText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navTitle("Feedback")
    }
    
    
    @IBAction func clearBtnClick(_ sender: Any) {
        addPicImg.isHidden = true
        clearPicBtn.isHidden = true
    }
    
    /// 选择相册
    @IBAction func addPicClick(_ sender: Any) {
        PictureTl.shared.showAlertPic()
        PictureTl.shared.callImgBlock = { [weak self] img in
            self?.addImage = img
            self?.addPicImg.image = img
            self?.addPicImg.isHidden = false
            self?.clearPicBtn.isHidden = false
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let str = (textView.text as NSString).replacingCharacters(in: range, with: text)
        textPlaceText.isHidden = str.count > 0
        inputNumber.text = "\(str.count)/200"
        editText = str
        return str.count >= 200 ? false : true
    }
    
    
    @IBAction func commitClick(_ sender: Any) {
        if editText.count <= 0 {
            ToastHud.showToastAction(message: "Insira o conteúdo do feedback")
            return
        }
        
        guard let _ = addImage else {
            ToastHud.showToastAction(message: "Adicione fotos de feedback")
            return
        }
        
        ToastHud.showToastAction()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            ToastHud.hiddenToastAction()
            ToastHud.showToastAction(message: "Feedback bem-sucedido, aguardando revisão", 3)
            self?.gt.disCurrentVC()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.gt.keyboardEnd()
    }
    
}
