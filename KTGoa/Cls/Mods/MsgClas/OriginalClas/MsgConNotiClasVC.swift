//
//  MsgConNotiClasVC.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/24.
//

import UIKit

class MsgConNotiClasVC: BasTableViewVC {
    
    var list = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navTitle("Notificações")
        setupEmptyView(list)
        tabRegisterNib(tabCell: MsgClasCell.self)
        
        ToastHud.showToastAction()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ToastHud.hiddenToastAction()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.gt.dequeueReusableCell(cellType: MsgClasCell.self, cellForRowAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
