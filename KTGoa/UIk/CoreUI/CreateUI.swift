//
//  CreateUI.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

public func createLab(_ textColor: UIColor, 
                      _ font: UIFont,
                      text: String = "", textAlignment:NSTextAlignment = .left) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = font
    label.textColor = textColor
    label.textAlignment = textAlignment
    return label
}

public func createButton(_ textColor: UIColor,
                         _ font: UIFont,
                         text: String = "",
                         state:UIControl.State = .normal) -> UIButton{
    let button = UIButton(type: .custom)
    button.title(text)
    button.font(font)
    button.textColor(textColor, state)
    return button
}

public func createButton(_ image: UIImage?,
                         state:UIControl.State = .normal) -> UIButton{
    let button = UIButton(type: .custom)
    button.image(image, state)
    return button
}

func creatTextField(_ textColor:UIColor,
                    _ font:UIFont,
                    _ placeholder:String = "",
                    text:String = "") -> UITextField{
    let textField = UITextField()
    textField.text = text
    textField.font = font
    textField.placeholder = placeholder
    return textField
}
