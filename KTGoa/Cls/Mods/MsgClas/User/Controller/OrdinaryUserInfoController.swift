//
//  MsgOrdinaryUserInfoController.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/20.
//

import UIKit

class OrdinaryUserInfoController: BasClasVC {
    
    lazy var contentView = MsgOrdinaryUserInfoView()
    
    var userId = ""
    
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        guard let userId = param as? String else { return  }
        self.userId = userId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backItem(.backWhite)
        view.insertSubview(contentView, at: 0)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        getUserInfo()
    }

}

// MARK: - 绑定数据
extension OrdinaryUserInfoController {
    
    private func getUserInfo() {
        UserReq.userInfo(userId) { [weak self] userInfo in
            guard let model = userInfo else { return }
            self?.contentView.info = model
        }
    }
    
}
