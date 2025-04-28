//
//  DenounceViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/29.
//

import UIKit

enum AccuseType: Int {
    case one = 0        // 单聊
    case group = 1      // 群聊
}

class AccuseViewController: BasClasVC {
    
    var type: AccuseType = .one
    var toUserId: String = ""
    lazy var typesList: [AccuseTypeModel] = []
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let dict = param as? [String: Any],
           let typeValue = dict["type"] as? Int,
           let type = AccuseType(rawValue: typeValue),
           let toUserId = dict["toUserId"] as? String {
            self.type = type
            self.toUserId = toUserId
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        mutateLoadData(type: type)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.snp.updateConstraints { make in
            let height = collectionView.collectionViewLayout.collectionViewContentSize.height
            make.height.equalTo(height)
        }
    }
    
    
    private func buildUI() {
        
        navTitle(type == .one ? "reportUser".msgLocalizable() : "reportGroupChat".msgLocalizable())
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(imageTitle)
        scrollView.addSubview(picturesView)
        scrollView.addSubview(explainTitle)
        scrollView.addSubview(textView)
        view.addSubview(bottomBtn)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-20 - 52 - safeAreaBt)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.leading.equalTo(15)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.width.equalTo(screW - 30)
            make.height.equalTo(0)
        }
        
        imageTitle.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(40)
            make.leading.equalTo(15)
        }
        
        picturesView.snp.makeConstraints { make in
            make.top.equalTo(imageTitle.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
        
        explainTitle.snp.makeConstraints { make in
            make.top.equalTo(picturesView.snp.bottom).offset(40)
            make.leading.equalTo(15)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(explainTitle.snp.bottom).offset(10)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.width.equalTo(screW - 30)
            make.height.equalTo(140)
            make.bottom.equalTo(-70)
        }
        
        bottomBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-20 - safeAreaBt)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(52)
        }
    }
    
    private func updateBottomBtnState() {
        guard typesList.first(where: { $0.isSelected }) != nil else {
            bottomBtn.isSelected = false
            return
        }
        guard picturesView.selectedItems.count > 0, self.textView.text.trimmingCharacters(in: .whitespaces).count > 0 else {
            bottomBtn.isSelected = false
            return
        }
        
        bottomBtn.isSelected = true
    }
    
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.text = "reasonForReporting".msgLocalizable()
        lab.font = UIFontMedium(15)
        lab.textColor = .black
        return lab
    }()
    
    private lazy var layout: LeftAlignedColFlowLayout = {
        let lay = LeftAlignedColFlowLayout()
        lay.minimumLineSpacing = 10
        lay.minimumInteritemSpacing = 10
        lay.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return lay
    }()
    
    private lazy var collectionView: UICollectionView = {
        let col =  UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.showsVerticalScrollIndicator = false
        col.showsHorizontalScrollIndicator = false
        col.gt.register(cellClass: AccuseTypeCell.self)
        col.delegate = self
        col.dataSource = self
        return col
    }()
    
    private lazy var imageTitle: UILabel = {
        let lab = UILabel()
        lab.text = "provideImageExplanation".msgLocalizable()
        lab.font = UIFontMedium(15)
        lab.textColor = .black
        return lab
    }()
    
    private lazy var picturesView = UploadPicturesView()
    
    private lazy var explainTitle: UILabel = {
        let lab = UILabel()
        lab.text = "additionalExplanationOptional".msgLocalizable()
        lab.font = UIFontMedium(15)
        lab.textColor = .black
        return lab
    }()
    
    private lazy var textView: UITextView = {
        let text = UITextView()
        text.font = .systemFont(ofSize: 14)
        text.textColor = .black
        text.gt.setCornerRadius(10)
        text.backgroundColor = .xf2
        text.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        text.returnKeyType = .done
        text.delegate = self
        return text
    }()
    
    private lazy var bottomBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("submit".msgLocalizable(), for: .normal)
        btn.setTitleColor(.hexStrToColor("#666666"), for: .normal)
        btn.setTitleColor(.hexStrToColor("#666666"), for: .highlighted)
        btn.setTitleColor(.black, for: .selected)
        btn.titleLabel?.font = UIFontSemibold(16)
        btn.setBackgroundImage(UIColor.hexStrToColor("#FFDA00", 0.6).transform(), for: .normal)
        btn.setBackgroundImage(UIColor.hexStrToColor("#FFDA00", 0.6).transform(), for: .highlighted)
        btn.setBackgroundImage(UIColor.appColor.transform(), for: .selected)
        btn.gt.setCornerRadius(8)
        btn.gt.handleClick { [weak self] button in
            self?.mutateAccuse()
        }
        return btn
    }()
}

// MARK: - UITextViewDelegate
extension AccuseViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let currentText = textView.text ?? ""
        if currentText.count > 200 {
            let limitText = String(currentText.prefix(200))
            self.textView.text = limitText
        }
        
        updateBottomBtnState()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
        // 检查新文本是否超出最大字符数
        return newText.count <= 200
    }
    
}

extension AccuseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.gt.dequeueReusableCell(cellType: AccuseTypeCell.self, cellForRowAt: indexPath)
        if typesList.count > 0 {
            cell.bind(model: typesList[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        typesList.forEach({ $0.isSelected = false })
        let model = typesList[indexPath.row]
        model.isSelected = true
        typesList[indexPath.row] = model
        self.collectionView.reloadData()
    }
    
}

// MARK: - Data
extension AccuseViewController {
    
    /// 获取举报 "举报类型"
    private func mutateLoadData(type: AccuseType) {
        var params: [String: Any] = [:]
        params["type"] = type.rawValue
        NetAPI.MessageAPI.accuseType.reqToListHandler(parameters: params, model: AccuseTypeModel.self, listKey: "", success: { [weak self] list, _ in
            list.first?.isSelected = true
            self?.typesList = list
            self?.collectionView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.view.setNeedsLayout()
                self?.view.layoutIfNeeded()
            }
        }, failed: { error in
            print("error: \(error)")
        })
        
    }
    
    /// 提交举报
    private func mutateAccuse() {
        guard let typeId = typesList.first(where: { $0.isSelected })?.id else {
            return
        }
        
        let selPics = picturesView.selectedItems.map({$0.image ?? UIImage()})
        
        var params: [String: Any] = [:]
        params["type"] = type.rawValue
        params["typeId"] = typeId
        params["toUserId"] = toUserId
        params["content"] = textView.text.trimmingCharacters(in: .whitespaces)
        let group = DispatchGroup()
        if selPics.count > 0 {
            group.enter()
            AliyunOSSHelper.shared.update(images: selPics) { result, imageUrls in
                if result, imageUrls.count == selPics.count {
                    params["images"] = imageUrls.joined(separator: ",")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            NetAPI.MessageAPI.accuse.reqToJsonHandler(parameters: params) { _ in
                RoutinStore.dismiss()
                ToastHud.showToastAction(message: "submissionSuccessful".msgLocalizable())
            } failed: { error in
                debugPrint("error: \(error)")
            }
        }
        
    }
}
