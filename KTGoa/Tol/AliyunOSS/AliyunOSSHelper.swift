//
//  AliyunOSSHelper.swift
//  Golaa
//
//  Created by duke on 2024/5/15.
//

import UIKit
import AliyunOSSiOS
import CommonCrypto

enum AliyunOSSType: String {
    case userImg            = "avatar" // 用户头像
    case publishAuth        = "publishAuth" // 发布者认证
    case liaoImg            = "chatPhoto" // 相册
    case taskBz             = "taskStep" // 用户认证
    case jubao              = "complain" // 举报
    case taskLogo           = "taskCover" // 任务LOGO
}

class AliyunOSSHelper: NSObject {
    static let shared = AliyunOSSHelper()
    private var client: OSSClient?

    override init() {
        super.init()
        setup()
    }
    
    /// - 初始化配置
    func setup() {
        // ...
    }
    
    private func initClient(_ model: STSTokenModel) {
        let provider = OSSFederationCredentialProvider {
            let token = OSSFederationToken()
            token.tAccessKey = model.acceId
            token.tSecretKey = model.acceSec
            token.tToken = model.secToken
            token.expirationTimeInGMTFormat = model.exp
            return token
        }
        client = OSSClient(endpoint: model.endPoint, credentialProvider: provider)
    }
    
    private func fetchSTSToken(_ type: AliyunOSSType, completion: ((STSTokenModel) -> Void)?) {
        var params: [String: Any] = [:]
        params["bizType"] = type.rawValue
        NetAPI.OSSAPI.getToken.reqToJsonHandler(false, parameters: params) { [weak self] data in
            if let json = data.data["token"] as? [String: Any], let model = STSTokenModel.deserialize(from: json) {
                self?.initClient(model)
                completion?(model)
            }
        } failed: { error in
            debugPrint("error: \(error.localizedDescription)")
        }
    }
    
    /// - 上传图片
    func update(images: [UIImage], type: AliyunOSSType = .userImg, showToast: Bool = true, completion: ((Bool, [String]) -> Void)?) {
        if showToast { ToastHud.showToastAction() }
        fetchSTSToken(type) { [weak self] model in
            DispatchQueue.global().async { [weak self] in
                let group = DispatchGroup()
                var filePaths: [String] = []
                var result = true
                images.forEach { [weak self] image in
                    guard let self = self else { return }
                    // 压缩图片
                    guard let data = image.compress(100000) else {
                        DispatchQueue.main.async {
                            if showToast { ToastHud.hiddenToastAction() }
                            completion?(false, [])
                        }
                        return
                    }
                    
                    group.enter()
                    // 创建 OSS 文件上传请求
                    let request = OSSPutObjectRequest()
                    request.bucketName = model.buck
                    request.uploadingData = data
                    request.objectKey = self.getOSSObjectKey(data, fileExtension: "png")
                    let task = self.client?.putObject(request)
                    task?.continue({ task in
                        if let error = task.error {
                            result = false
                            debugPrint("error = \(error.localizedDescription)")
                        } else {
                            let urlPath = model.domain + request.objectKey
                            filePaths.append(urlPath)
                        }
                        group.leave()
                        return
                    }).waitUntilFinished()
                }
                
                group.notify(queue: .main) {
                    if showToast { ToastHud.hiddenToastAction() }
                    if images.count != filePaths.count || !result {
                        completion?(false, [])
                        return
                    }
                    completion?(true, filePaths)
                }
            }
        }
    }
    
    /// - 上传文件
    /// mp4 -> "mp4"
    func update(_ data: Data, fileExtension: String, type: AliyunOSSType = .userImg, showToast: Bool = true, completion: ((Bool, String) -> Void)?) {
        if showToast { ToastHud.showToastAction() }
        fetchSTSToken(type) { [weak self] model in
            guard let self = self else { return }
            let request = OSSPutObjectRequest()
            request.bucketName = model.buck
            request.uploadingData = data
            request.objectKey = self.getOSSObjectKey(data, fileExtension: fileExtension)
            let task = self.client?.putObject(request)
            task?.continue({ task in
                if showToast { ToastHud.hiddenToastAction() }
                if let error = task.error {
                    completion?(false, "")
                    debugPrint("error = \(error.localizedDescription)")
                } else {
                    let urlPath = model.domain + request.objectKey
                    completion?(true, urlPath)
                }
                return
            }).waitUntilFinished()
        }
    }
}

extension AliyunOSSHelper {
    
    /// - 获取 OSS objectKey
    private func getOSSObjectKey(_ data: Data, fileExtension: String) -> String {
        let md5 = data.md5
        return md5 + "." + fileExtension
    }
}

extension UIImage {
    
    /// - 图片压缩
    func compress(_ maxLength: Int) -> Data? {
        var compress: CGFloat = 0.9
        let maxCompress: CGFloat = 0.1
        guard var imageData = jpegData(compressionQuality: compress) else {
            return nil
        }
        while (imageData.count) > maxLength && compress > maxCompress {
            compress -= 0.1
            if let data = jpegData(compressionQuality: compress) {
                imageData = data
            }
        }
        return imageData
    }
}

extension Data {
    
    /// md5
    var md5: String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_MD5($0.baseAddress, CC_LONG(self.count), &digest)
        }
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
