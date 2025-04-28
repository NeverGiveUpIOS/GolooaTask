//
//  PictureTl.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/25.
//

import UIKit

public typealias PictureTlCallPicBlock  = (_ img: UIImage) -> ()

class PictureTl: NSObject {
    
    var callImgBlock: PictureTlCallPicBlock?
    
    static let shared = PictureTl()

}

extension PictureTl {

    func showAlertPic() {
        let list = [
            AlertSheetConfig(title: "openTheAlbum".msgLocalizable(), sectionH: 58),
            AlertSheetConfig(title: "turnOnTheCamera".msgLocalizable(), sectionH: 54)
        ]
        AlertSheetView.show(dataSoruce: list) { [weak self] index in
            if index == 0 {
                self?.openPhotoFromLibrary()
            } else {
                self?.openPhotoWithCamera()
            }
        }
    }
}

extension PictureTl {
    
    /// 打开相册
    func openPhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
       getTopController().present(imagePicker, animated: true, completion: nil)
    }
}

extension PictureTl {
    
    /// 打开相机
    func openPhotoWithCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
           getTopController().present(imagePicker, animated: true, completion: nil)
        } else {
            // Show alert to inform the user that the camera is not available
            let alertController = UIAlertController(title: "Camera Not Available", message: "Unable to access the camera on this device.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           getTopController().present(alertController, animated: true, completion: nil)
        }
    }
}


extension PictureTl: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[.originalImage] as? UIImage {
            callImgBlock?(pickedImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the UIImagePickerController
        picker.dismiss(animated: true, completion: nil)
    }
}
