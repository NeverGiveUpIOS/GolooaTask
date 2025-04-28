//
//  UITableViewExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/24.
//

import UIKit

public extension GTBas where Base: UITableView {
    
    // MARK: - 创建UITableViewCell
    func dequeueReusableCell<T: UITableViewCell>(cellType: T.Type, cellForRowAt indexPath: IndexPath) -> T {
        return bas.dequeueReusableCell(withIdentifier: cellType.className, for: indexPath) as! T
    }
    
    
    // MARK: - 注册自定义cell
    func register(cellClass: UITableViewCell.Type) {
        bas.register(cellClass.self, forCellReuseIdentifier: cellClass.className)
    }
    
    // MARK: - 注册Xib自定义cell
    func register(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        bas.register(nib, forCellReuseIdentifier: nibName)
    }
    
    
}
