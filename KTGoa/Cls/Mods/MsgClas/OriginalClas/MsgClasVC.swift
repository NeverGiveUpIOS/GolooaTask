//
//  MsgClasVC.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/24.
//

import UIKit

class MsgClasVC: BasTableViewVC {
    
    var msgTitle: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hiddenNavView(true)
        
        tabRegisterNib(tabCell: MsgClasCell.self)
        tableView?.gt.y = 0
        tableView?.gt.height = screH - tabBarH

        msgTitle = createLab(.black, UIFontSemibold(24), text: "Mensagens")
        view.addSubview(msgTitle!)
        msgTitle?.frame = .init(x: 20, y: 68, width: 100, height: 20)
        msgTitle?.sizeToFit()
        
        tableView?.gt.top = msgTitle?.gt.bottom ?? 0 + 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.gt.dequeueReusableCell(cellType: MsgClasCell.self, cellForRowAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gt.pushViewController(MsgConNotiClasVC())
    }

}

