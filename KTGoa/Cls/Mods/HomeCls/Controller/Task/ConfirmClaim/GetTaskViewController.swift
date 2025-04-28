//
//  GetTaskViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/20.
//

import UIKit

class GetTaskViewController: BasClasVC {
    
    var model: TaskDescModel?
    var config: GetTaskConfig?
    var registDataSource:  [PayDepositModel] = []
    var channelDataSource: [PayDepositModel] = []
    var fansDataSource:   [PayDepositModel] = []
    var chatDataSource:   [GetTaskConfigItem] = []
    var receivedSuccess = false
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let model = param as? TaskDescModel {
            self.model = model
        }
    }
    
    var receiveCount: Int = 0
    var channel: String = ""
    var fansLevel: String = ""
    var socialUrl: String = ""
    var socialCover: String = ""
    var image1: UIImage?
    var image2: UIImage?
    var image3: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        mutateLoadConfig(model?.surCount ?? 0)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        registCollectionView.snp.updateConstraints { make in
            let height = registCollectionView.collectionViewLayout.collectionViewContentSize.height
            make.height.equalTo(height)
        }
        
        if model?.isReVery == true {
            channelCollectionView.snp.updateConstraints { make in
                let height = channelCollectionView.collectionViewLayout.collectionViewContentSize.height
                make.height.equalTo(height)
            }
            fansCollectionView.snp.updateConstraints { make in
                let height = fansCollectionView.collectionViewLayout.collectionViewContentSize.height
                make.height.equalTo(height)
            }
            chatCollectionView.snp.updateConstraints { make in
                let height = chatCollectionView.collectionViewLayout.collectionViewContentSize.height
                make.height.equalTo(height)
            }
        }
    }
    
    func updateBottomBtnState() {
        if model?.isReVery == true {
            guard receiveCount > 0, !channel.isEmpty, !fansLevel.isEmpty, !socialUrl.isEmpty,
                  chatDataSource.first(where: { $0.text.isEmpty }) == nil,
                  image1 != nil, image2 != nil, image3 != nil else {
                bottomBtn.isSelected = false
                return
            }
        } else {
            guard receiveCount > 0 else {
                bottomBtn.isSelected = false
                return
            }
        }
        
        bottomBtn.isSelected = true
    }
    
    func keyboardReturn(_ text: String, forItem item: GetTaskConfigItem) {
        item.text = text
        self.socialUrl = chatDataSource
            .map({ item in
                var dict: [String: Any] = [:]
                dict["type"] = item.value
                dict["url"] = item.text
                return dict
            })
            .toJSON() ?? ""
        self.updateBottomBtnState()
    }
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = true
        if #available(iOS 13.0, *) {
            view.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    lazy var arcView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCustomCoRadius([.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 16)
        return view
    }()
    
    lazy var registTitle: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#666666")
        lab.font = UIFontReg(14)
        lab.text = "quantityAvailableForRegistration".homeLocalizable()
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var layout1: LeftAlignedColFlowLayout = {
        let lay = LeftAlignedColFlowLayout()
        lay.minimumLineSpacing = 18
        lay.minimumInteritemSpacing = 13
        lay.estimatedItemSize = .init(width: (screW - 30 - 18*2)/3.0, height: 55)
        return lay
    }()
    
    lazy var layout2: LeftAlignedColFlowLayout = {
        let lay = LeftAlignedColFlowLayout()
        lay.minimumLineSpacing = 18
        lay.minimumInteritemSpacing = 13
        lay.estimatedItemSize = .init(width: (screW - 30 - 18*2)/3.0, height: 55)
        return lay
    }()
    
    lazy var layout3: LeftAlignedColFlowLayout = {
        let lay = LeftAlignedColFlowLayout()
        lay.minimumLineSpacing = 18
        lay.minimumInteritemSpacing = 13
        lay.estimatedItemSize = .init(width: (screW - 30 - 18*2)/3.0, height: 55)
        return lay
    }()
    
    lazy var registCollectionView: UICollectionView = {
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout1)
        col.showsVerticalScrollIndicator = false
        col.showsHorizontalScrollIndicator = false
        col.gt.register(cellClass: PayDepositCell.self)
        return col
    }()
    
    lazy var channelTitle: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#666666")
        lab.font = UIFontReg(14)
        lab.text = "mainSourceOfRegistrationQuantitymultipleSelections".homeLocalizable()
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var channelCollectionView: UICollectionView = {
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout2)
        col.showsVerticalScrollIndicator = false
        col.showsHorizontalScrollIndicator = false
        col.gt.register(cellClass: PayDepositCell.self)
        return col
    }()
    
    lazy var fansTitle: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#666666")
        lab.font = UIFontReg(14)
        lab.text = "howManyFansDoYouHave".homeLocalizable()
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var fansCollectionView:UICollectionView = {
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout3)
        col.showsVerticalScrollIndicator = false
        col.showsHorizontalScrollIndicator = false
        col.gt.register(cellClass: PayDepositCell.self)
        return col
    }()
    
    lazy var chatHomeTitle: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#666666")
        lab.font = UIFontReg(14)
        lab.text = "yourSocialHomepageLink".homeLocalizable()
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var layout4: UICollectionViewFlowLayout = {
        let lay = UICollectionViewFlowLayout()
        lay.minimumLineSpacing = 16
        lay.itemSize = .init(width: screW - 30, height: 55)
        return lay
    }()
    
    lazy var chatCollectionView: UICollectionView = {
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout4)
        col.showsVerticalScrollIndicator = false
        col.showsHorizontalScrollIndicator = false
        col.gt.register(cellClass: GetTaskChatHomeCell.self)
        col.isScrollEnabled = false
        return col
    }()
    
    lazy var updateImgTitle: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#666666")
        lab.font = UIFontReg(14)
        lab.text = "homepageScreenshot".homeLocalizable()
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var addImg1View: CommentUpdateImgView = {
        let view = CommentUpdateImgView()
        view.tapAddPhotoBlock = { [weak self] image in
            guard let self = self, let image = image as? UIImage else { return }
            self.image1 = image
            self.updateBottomBtnState()
        }
        view.tapImageBlock = { [weak self] in
            guard let self = self else { return }
            PhotoBroView.showWithImages(nil, images: [self.image1 ?? UIImage()])
        }
        view.clearBlock = { [weak self] in
            guard let self = self else { return }
            self.image1 = nil
            self.updateBottomBtnState()
        }
        return view
    }()
    
    lazy var addImg2View: CommentUpdateImgView = {
        let view = CommentUpdateImgView()
        view.tapAddPhotoBlock = { [weak self] image in
            guard let self = self, let image = image as? UIImage else { return }
            self.image2 = image
            self.updateBottomBtnState()
        }
        view.tapImageBlock = { [weak self] in
            guard let self = self else { return }
            PhotoBroView.showWithImages(nil, images: [self.image2 ?? UIImage()])
        }
        view.clearBlock = { [weak self] in
            guard let self = self else { return }
            self.image2 = nil
            self.updateBottomBtnState()
        }
        return view
    }()
    
    lazy var addImg3View: CommentUpdateImgView = {
        let view = CommentUpdateImgView()
        view.tapAddPhotoBlock = { [weak self] image in
            guard let self = self, let image = image as? UIImage else { return }
            self.image3 = image
            self.updateBottomBtnState()
        }
        view.tapImageBlock = { [weak self] in
            guard let self = self else { return }
            PhotoBroView.showWithImages(nil, images: [self.image3 ?? UIImage()])
        }
        view.clearBlock = { [weak self] in
            guard let self = self else { return }
            self.image3 = nil
            self.updateBottomBtnState()
        }
        return view
    }()
    
    lazy var bottomBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("confirmClaim".homeLocalizable(), for: .normal)
        btn.setTitleColor(.black.withAlphaComponent(0.5), for: .normal)
        btn.setTitleColor(.black.withAlphaComponent(0.5), for: .highlighted)
        btn.setTitleColor(.black, for: .selected)
        btn.setBackgroundImage(UIColor.hexStrToColor("#FFDA00", 0.5).transform(), for: .normal)
        btn.setBackgroundImage(UIColor.hexStrToColor("#FFDA00", 0.5).transform(), for: .highlighted)
        btn.setBackgroundImage(UIColor.appColor.transform(), for: .selected)
        btn.gt.setCornerRadius(8)
        return btn
    }()
}
