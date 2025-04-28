//
//  PayDeposit_Col.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/7.
//

import Foundation

extension PayDepositViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return zfList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.gt.dequeueReusableCell(cellType: PayDepositCell.self, cellForRowAt: indexPath)
        if zfList.count > 0 {
            cell.bind(model: zfList[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: false)
         zfList.forEach({ $0.isSelected = false })
        let model = zfList[indexPath.row]
        model.isSelected = true
        zfList[indexPath.row] = model
        self.collectionView.reloadData()
        if let select = zfList.first(where: { $0.isSelected }) {
            self.earnestLabel.text = String(format: "$ %.02f", (Double(self.model?.price ?? "") ?? 0) * (Double(select.value) ?? 0))
            self.model?.count = Int(select.value) ?? 0
            if let item = config?.zfPlatforms.first(where: { $0.type == .coin }) {
                self.coinLabel.text = String(format: "%d%@", Int(Double(item.jinbiToUSD) * (Double(self.model?.price ?? "") ?? 0) * (Double(select.value) ?? 0)), "coins".globalLocalizable())
            }
        }
    }
}
