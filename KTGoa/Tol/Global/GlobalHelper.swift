//
//  GlobalHelper.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/1.
//

import UIKit

class GlobalHelper: NSObject {

    static let shared = GlobalHelper()
    
    private var vConfigure: GlobalVersionModel?
    
    var inEndGid = true

    /// 元数据
    var metas: GlobalMetas = GlobalMetas()
    
    var dataConfigure: GlobalCommonData = GlobalCommonData()

    // 处理GlobalReqType请求状态，避免连续请求
    private var requestStates = SafeDictionary<GlobalReqType, GlobalRequestState>()
    
    private override init() {
        super.init()
        inEndGid = Self.lastInEndGid
        addNotiObserver(self, #selector(onMonitoring(noti:)), "NetworkStatusChange")
        self.requestData()
    }
    
    func start() {
        FlyerLibHelper.shared.setup()
    }
    
    /// 在线客服Url
    var serviceUrl = ""
    
    /// 网路状态变化
    @objc private func onMonitoring(noti: NSNotification) {
        if let state = noti.object as? ReqReachabilityStatus {
            if state != .notReachable {
                self.requestData()
            }
        }
    }
    
    // 上一次版本的审核状态
    private static var lastInEndGid: Bool {
        if UserDefaults.standard.value(forKey: CacheKey.endGidState) != nil {
            return UserDefaults.standard.bool(forKey: CacheKey.endGidState)
        }
        // 没有历史值，设置审核中
        return true
    }
    
    // MARK: - Request
    
    func requestData() {
        getMetas()
        fetchDataCommon()
        fetchVersion()
    }
    
    private func getMetas() {
        if !canRequest(.meta) { return }
        resetRequestState(.loading, for: .meta)
        let pars = ["types": MetasType.apis]
        NetAPI.GlobalAPI.metas.reqToModelHandler(false, parameters: pars, model: GlobalMetas.self) { [weak self] model, _ in
            self?.metas = model
            self?.resetRequestState(.success, for: .meta)
        } failed: { [weak self] _ in
            self?.resetRequestState(.errorRequest, for: .meta)
        }
    }
    
    private func fetchDataCommon() {
        if !canRequest(.common) { return }
        resetRequestState(.loading, for: .common)
        NetAPI.GlobalAPI.dataCommon.reqToModelHandler(false, parameters: nil, model: GlobalCommonData.self) { [weak self] model, _ in
            self?.dataConfigure = model
            self?.resetRequestState(.success, for: .common)
        } failed: { [weak self] _ in
            self?.resetRequestState(.errorRequest, for: .common)
        }
    }
    
    // 版本请求接口
    private func fetchVersion() {
        if !canRequest(.version) { return }
        // 设置请求状态 为请求中
        resetRequestState(.loading, for: .version)
        NetAPI.GlobalAPI.dataVersion.reqToJsonHandler(false, parameters: nil, success: { [weak self] origin in
            guard let self = self else { return }
            debugPrint("fetchVersion = \(origin)")
            if origin.data.count > 0 {
                // data不为空
                if let model = GlobalVersionModel.deserialize(from: origin.data) {
                    self.vConfigure = model
                    VersionAlertView.show(model: model)
                }
            }
            
            self.resetRequestState(.success, for: .version)

            self.inEndGid = self.inEndGidResult()
            
            // 本地存储
            UserDefaults.standard.setValue(self.inEndGidResult(), forKey: CacheKey.endGidState)
            UserDefaults.standard.synchronize()
            postNotiObserver("inEndGidRelay")
        }, failed: { [weak self] error in
            // 设置请求状态
            self?.resetRequestState(.errorRequest, for: .version)
        })
    }
    
    // 审核状态 是否是审核中
    private func inEndGidResult() -> Bool {
        guard let vfig = vConfigure else {
            // 网络请求成功，没有新版，返回非审核状态 false
            return false
        }
        
        // 当前版本好跟 审核版本好相同
        if vfig.version == AppVersion {
            // 是否是审核中
            return vfig.state == 0
        }
        
        // 版本不一致，只有版本低于服务器版本，才有数据返回，所以为非审核状态 flase
        return false
    }
    
    private func canRequest(_ key: GlobalReqType) -> Bool {
        if let result = requestStates.value(for: key) {
            if result == .loading {
                return false
            } else if key == .version, result == .success {
                return false
            }
        }
        return true
    }
    
    // MARK: - RequestState
    
    private func resetRequestState(_ state: GlobalRequestState, for key: GlobalReqType) {
        requestStates.setValue(state, for: key)
    }
    

}


enum GlobalReqType: CaseIterable {
    case meta
    case common
    case version
}

enum GlobalRequestState {
    case loading
    case success
    case errorRequest
}

enum MetasType: Int, CaseIterable {
    case area               // 国家手机区号
    case gender             // 性别
    case country            // 国家
    case language           // 语言
    case channel            // 分享渠道
    
    var api: String {
        switch self {
        case .area:
            return "phoneArea"
        case .gender:
            return "gender"
        case .country:
            return "country"
        case .language:
            return "language"
        case .channel:
            return "shareChannel"
        }
    }
    
    static var apis: String {
        Self.allCases.map({$0.api}).joined(separator: ",")
    }
}

class GlobalMetas: JsonModelProtocol, Codable {
    required init() {}
    var gender: [GlobalMeta] = []
    var country: [GlobalMeta] = []
    var language: [GlobalMeta] = []
    var phoneArea: [GlobalMeta] = []
    var channel: [GlobalMeta] = []

    var areaLabels: [String] {
        phoneArea.map({"+\($0.value) \($0.label)"})
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &channel, name: "shareChannel")
    }
}

class GlobalMeta: JsonModelProtocol, Codable {
    required init() {}
    var label: String = ""
    var value: String = ""
}

class GlobalCommonData: JsonModelProtocol {
    required init() {}
    var agentCashUrl = ""
    var agentChildUrl = ""
    var agentHomeUrl = ""
    var agentIncomeUrl = ""
    var contactEmail = ""
    var goldCashUrl = ""
    var privacyPolicyUrl = ""
    var rechargeProtocolUrl = ""
    var taskCashUrl = ""
    var userAgreementUrl = ""
}

class GlobalVersionModel: JsonModelProtocol {
    var id = 0
    var version = ""                    // 服务器版本
    var state = 0                       // 0 审核中， 1 审核通过
    var link = ""
    var desc = ""
    var force = 0                       // 是否强制更新，0=默认；1=强制
    var isForce: Bool { force == 1 }    // 是否强制更新 true 是
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< state <-- ["status"]
        mapper <<< link <-- ["downloadUrl"]
        mapper <<< force <-- ["updateType"]
    }
}
