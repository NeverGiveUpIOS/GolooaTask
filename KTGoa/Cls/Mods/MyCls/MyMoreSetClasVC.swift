//
//  MyMoreSetClasVC.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/25.
//

import UIKit

class MyMoreSetClasVC: BasClasVC {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navTitle("Centro de Configurações")
        view.backgroundColor = UIColorHex("#F2F2F2")
    }
    
    @IBAction func zxAccount(_ sender: Any) {
        let alert = UIAlertController(title: "Dicas gentis", message: "Tem certeza de que deseja cancelar sua conta? Todas as suas informações serão excluídas após o cancelamento da conta", preferredStyle: .alert)
        let action = UIAlertAction(title: "Confirmar", style: .default) { [weak self] (action) in
            ToastHud.showToastAction()
             self?.zxUserAccountReq()
        }
        let canceAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
        }
        
        alert.addAction(action)
        alert.addAction(canceAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logOutClick(_ sender: Any) {
        let alert = UIAlertController(title: "Dicas gentis", message: "Tem certeza que deseja sair?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Confirmar", style: .default) { [weak self] (action) in
            ToastHud.showToastAction()
            self?.logoutReq()
        }
        let canceAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
        }
        
        alert.addAction(action)
        alert.addAction(canceAction)
        present(alert, animated: true, completion: nil)

    }
    
    private func zxUserAccountReq() {
        LoginReq.disAccountReq { isSuccess in
            
        }
    }
    
    private func logoutReq() {
        LoginReq.toLogout { isSuccess in
            
        }

    }
    
}
