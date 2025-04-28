//
//  ReqConfig.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/5.
//

typealias JsonModelProtocol = HandyJSON

typealias ReqSuccJsonClosure = (_ JSON: Any) -> Void
typealias ReqFailedClosure = (_ error: NetworkError) -> Void
typealias ReqProgressHandler = (Progress) -> Void

typealias ReqSuccessMClosure<T: JsonModelProtocol> = (T, [String: Any]) -> Void
typealias ReqSuccessLClosure<T> = (T, [String: Any]) -> Void
typealias ReqSuccessDJlosure  = (_ originalData: ReqOriginalData) -> Void

// MARK: - 请求方式
enum ReqHTTPMethod {
    case get, post
}

// MARK: - ReqAPIProtocol
protocol ReqAPIProtocol {
    var url: String { get }
    var description: String { get }
    var method: ReqHTTPMethod { get }
}

struct APIItem: ReqAPIProtocol {
    public var url: String { NetAPI.API + urlPath }  // 域名 + path
    public let description: String // 接口名称描述
    public var method: ReqHTTPMethod
    
    private let urlPath: String  // URL的path
    
    init(_ path: String, des: String, m: ReqHTTPMethod = .get) {
        urlPath = path
        description = des
        method = m
    }
    
    init(_ path: String, m: ReqHTTPMethod) {
        self.init(path, des: "", m: m)
    }
}

// MARK: - 原始数据
struct ReqOriginalData {
    var data: [String: Any] = [:]
    var json: [String: Any] = [:]
}

// MARK: - 请求错误处理
class NetworkError {
    /// 以整数形式表示的业务代码，一般是具体的错误代码
    var code = -1
    /// 表示请求响应状态
    var status: String = ""
    /// 错误描述
    var localizedDescription: String = ""
    /// 扩展数据
    var extra: Any?
    /// 字符串类型。是服务器需要客户端执行的回调指令（函数）名称
    var callback: String?
    
    init(code: Int, status: String, desc: String, extra: Any? = nil, callback: String? = nil) {
        self.code = code
        self.localizedDescription = desc
        self.extra = extra
        self.status = status
        self.callback = callback
        ToastHud.hiddenIndicatorToastAction()
        ToastHud.hiddenToastAction()
        failhandel()
    }
    
    /// 一些错误全局处理
    private func failhandel() {
        switch status {
        case "unfinish_task":
            // 表示 还有未完成或未结算的任务
            break
        case "less_coin":
            ToastHud.showToastAction(message: localizedDescription)
        case "login":
            LoginTl.shared.logout()
            break
        case "callback":
            break
        case "group_limit":
            // 创建群数量数已达上限
            AlertPopView.show(titles: "tip".globalLocalizable(),
                              contents: "youHaveReachedTheMaximumNumber".msgLocalizable(),
                              sures: "iUnderstand".msgLocalizable(),
                              cacnces: "") {
            } cancelCompletion: {}
            break
        default:
            ToastHud.showToastAction(message: localizedDescription)
            // break
        }
    }
}
