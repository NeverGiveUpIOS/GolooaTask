//
//  GetTask_Col.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/7.
//

import Foundation

extension GetTaskViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == registCollectionView {
            return registDataSource.count
        } else if collectionView == channelCollectionView {
            return channelDataSource.count
        } else if collectionView == fansCollectionView {
            return fansDataSource.count
        } else {
            return chatDataSource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == chatCollectionView {
            let cell = collectionView.gt.dequeueReusableCell(cellType: GetTaskChatHomeCell.self, cellForRowAt: indexPath)
            cell.bind(model: chatDataSource[indexPath.row])
            cell.callBlock = { [weak self] text in
                guard let self = self else { return }
                self.keyboardReturn(text, forItem: self.chatDataSource[indexPath.row])
            }
            return cell
        } else {
            let cell = collectionView.gt.dequeueReusableCell(cellType: PayDepositCell.self, cellForRowAt: indexPath)
            if collectionView == registCollectionView {
                cell.bind(model: registDataSource[indexPath.row])
            } else if collectionView == channelCollectionView {
                cell.bind(model: channelDataSource[indexPath.row])
            } else if collectionView == fansCollectionView {
                cell.bind(model: fansDataSource[indexPath.row])
            }
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == registCollectionView {
            self.registCollectionView.deselectItem(at: indexPath, animated: false)
            let model = registDataSource[indexPath.row]
            if !model.isEnabled { return }
            registDataSource.forEach({ $0.isSelected = false })
            model.isSelected = true
            registDataSource[indexPath.row] = model
            self.receiveCount = Int(model.value) ?? 0
            self.registCollectionView.reloadData()
            self.updateBottomBtnState()
        } else if collectionView == channelCollectionView {
            self.channelCollectionView.deselectItem(at: indexPath, animated: false)
            let model = channelDataSource[indexPath.row]
            model.isSelected = !model.isSelected
            self.channel = channelDataSource
                .filter({ $0.isSelected })
                .map({ $0.value })
                .joined(separator: ",")
            channelDataSource[indexPath.row] = model
            self.channelCollectionView.reloadData()
            self.updateBottomBtnState()
        } else if collectionView == fansCollectionView {
            self.fansCollectionView.deselectItem(at: indexPath, animated: false)
            let model = fansDataSource[indexPath.row]
            if !model.isEnabled { return }
            fansDataSource.forEach({ $0.isSelected = false })
            model.isSelected = true
            fansDataSource[indexPath.row] = model
            self.fansLevel = model.value
            self.fansCollectionView.reloadData()
            self.updateBottomBtnState()
        } else {
            self.chatCollectionView.deselectItem(at: indexPath, animated: false)
        }
        
    }
    
}
