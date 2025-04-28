//
//  OSSAPI.swift
//  Golaa
//
//  Created by duke on 2024/5/15.
//

extension NetAPI {
    struct OSSAPI {
        static let getToken = APIItem("/user/file/getToken", des: "获取STS临时通行证", m: .get)
    }
}
