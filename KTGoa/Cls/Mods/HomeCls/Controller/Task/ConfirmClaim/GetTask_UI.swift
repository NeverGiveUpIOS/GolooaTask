//
//  GetTask_UI.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/7.
//

import Foundation

extension GetTaskViewController {
    
    func buildUI() {
        navTitle("confirmClaim".homeLocalizable())
        navBagColor(.xf2)
        view.backgroundColor = .xf2
        view.addSubview(scrollView)
        scrollView.addSubview(arcView)
        scrollView.addSubview(registTitle)
        scrollView.addSubview(registCollectionView)
        if model?.isReVery == true {
            scrollView.addSubview(channelTitle)
            scrollView.addSubview(channelCollectionView)
            scrollView.addSubview(fansTitle)
            scrollView.addSubview(fansCollectionView)
            scrollView.addSubview(chatHomeTitle)
            scrollView.addSubview(chatCollectionView)
            scrollView.addSubview(updateImgTitle)
            scrollView.addSubview(addImg1View)
            scrollView.addSubview(addImg2View)
            scrollView.addSubview(addImg3View)
        }
        view.addSubview(bottomBtn)
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-54 - 52 - safeAreaBt)
        }
        
        arcView.snp.makeConstraints { make in
            make.top.equalTo(14.5)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(screW)
            make.bottom.equalTo(500)
        }
        
        registTitle.snp.makeConstraints { make in
            make.top.equalTo(47.5)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.width.equalTo(screW - 30)
        }
        
        registCollectionView.snp.makeConstraints { make in
            make.top.equalTo(registTitle.snp.bottom).offset(10)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.width.equalTo(screW - 30)
            make.height.equalTo(0)
        }
        
        if model?.isReVery == true {
            channelTitle.snp.makeConstraints { make in
                make.top.equalTo(registCollectionView.snp.bottom).offset(32.5)
                make.leading.equalTo(15)
                make.trailing.equalTo(-15)
                make.width.equalTo(screW - 30)
            }
            
            channelCollectionView.snp.makeConstraints { make in
                make.top.equalTo(channelTitle.snp.bottom).offset(10)
                make.leading.equalTo(15)
                make.trailing.equalTo(-15)
                make.width.equalTo(screW - 30)
                make.height.equalTo(0)
            }
            
            fansTitle.snp.makeConstraints { make in
                make.top.equalTo(channelCollectionView.snp.bottom).offset(32.5)
                make.leading.equalTo(15)
                make.trailing.equalTo(-15)
                make.width.equalTo(screW - 30)
            }
            
            fansCollectionView.snp.makeConstraints { make in
                make.top.equalTo(fansTitle.snp.bottom).offset(10)
                make.leading.equalTo(15)
                make.trailing.equalTo(-15)
                make.width.equalTo(screW - 30)
                make.height.equalTo(0)
            }
            
            chatHomeTitle.snp.makeConstraints { make in
                make.top.equalTo(fansCollectionView.snp.bottom).offset(40)
                make.leading.equalTo(15)
                make.trailing.equalTo(-15)
                make.width.equalTo(screW - 30)
            }
            
            chatCollectionView.snp.makeConstraints { make in
                make.top.equalTo(chatHomeTitle.snp.bottom).offset(22)
                make.leading.equalTo(15)
                make.trailing.equalTo(-15)
                make.width.equalTo(screW - 30)
                make.height.equalTo(0)
            }
            
            updateImgTitle.snp.makeConstraints { make in
                make.top.equalTo(chatCollectionView.snp.bottom).offset(42)
                make.leading.equalTo(15)
                make.trailing.equalTo(-15)
                make.width.equalTo(screW - 30)
            }
            
            let itemWidth = (screW - 4*15)/3.0
            addImg1View.snp.makeConstraints { make in
                make.top.equalTo(updateImgTitle.snp.bottom).offset(18)
                make.leading.equalTo(15)
                make.width.equalTo(itemWidth)
                make.height.equalTo(itemWidth)
            }
            addImg2View.snp.makeConstraints { make in
                make.top.equalTo(updateImgTitle.snp.bottom).offset(18)
                make.leading.equalTo(addImg1View.snp.trailing).offset(15)
                make.width.equalTo(itemWidth)
                make.height.equalTo(itemWidth)
            }
            addImg3View.snp.makeConstraints { make in
                make.top.equalTo(updateImgTitle.snp.bottom).offset(18)
                make.leading.equalTo(addImg2View.snp.trailing).offset(15)
                make.width.equalTo(itemWidth)
                make.height.equalTo(itemWidth)
                make.bottom.equalTo(-65)
            }
        }
        
        bottomBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-54 - safeAreaBt)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(52)
        }
    }
    
    func bind(_ config: GetTaskConfig) {
        self.config = config
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
}
