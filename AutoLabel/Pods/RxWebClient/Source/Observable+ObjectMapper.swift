//
//  Observable+ObjectMapper.swift
//  RxSwift_Alamofire_ObjectMapper
//
//  Created by PixelShi on 2017/6/20.
//  Copyright © 2017年 sfmDev. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper
import Result
import SwiftyJSON

let KResultCode = "resultCode"
let KErrorMsg = "errMsg"
let KBody = "body"

struct networkErrorType {
    static let notSuccessfulHTTP = (1004, "请检查网络")
    static let jsonToObjectError = (1005, "数据解析失败")
    static let resultCodeInvalidate = (1006, "数据解析失败")
    static let serverDataCodeError = (1007, "数据解析失败")
    static let paraTypeError = (1009, "数据解析失败")
}

extension Response {
    
    public func mapObject<T: BaseMappable>(_ type: T.Type) throws -> T {
        guard let object = Mapper<T>().map(JSONObject: try mapJSON()) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }

    public func mapArray<T: BaseMappable>(_ type: T.Type) throws -> [T] {
        let json = try JSONSerialization.jsonObject(with: self.data, options: [])
        guard let array = json as? [[String: Any]], let objects = Mapper<T>().mapArray(JSONArray: array) else {
            throw MoyaError.jsonMapping(self)
        }
        return objects
    }
    
    public func mapExceptionObject<T: BaseMappable>(_ type: T.Type) throws -> T {
        guard let object = Mapper<T>().map(JSONObject: try mapJSON()) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }
    
}

extension ObservableType where E == Response {

    public func mapObject<T: BaseMappable>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            
            do {
                
                let object = try response.mapObject(T.self)

                // check http status
                guard ((200...299) ~= response.statusCode) else {
                     return Observable.error(ErrorFactory.createError(code: networkErrorType.notSuccessfulHTTP.0, errorMessage: networkErrorType.notSuccessfulHTTP.1))
                }
                
                let json = JSON.init(data: response.data)
                if let code = json[KResultCode].int {
                    let errorMsg = json[KErrorMsg].string
                    if code == 0 {
                        //设置返回body
                        return Observable.just(object)
                    } else {
                        return Observable.error(ErrorFactory.createError(code: networkErrorType.serverDataCodeError.0, errorMessage: errorMsg ?? networkErrorType.serverDataCodeError.1))
                    }
                } else {
                    // resultCode 异常
                    return Observable.error(ErrorFactory.createError(code: networkErrorType.resultCodeInvalidate.0, errorMessage: networkErrorType.resultCodeInvalidate.1))
                }
            } catch {
                
                switch error {
                case MoyaError.jsonMapping(_):
                    return Observable.error(ErrorFactory.createError(code: networkErrorType.jsonToObjectError.0, errorMessage: networkErrorType.jsonToObjectError.1))
                default:
                    break
                }
                return Observable.error(MoyaError.jsonMapping(response))
            }
        }
    }

    public func mapArray<T: BaseMappable>(_ type: T.Type) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            do {
                let object = try response.mapArray(T.self)

                // check http status
                guard ((200...299) ~= response.statusCode) else {
                    return Observable.error(ErrorFactory.createError(code: networkErrorType.notSuccessfulHTTP.0, errorMessage: networkErrorType.notSuccessfulHTTP.1))
                }

                let json = JSON.init(data: response.data)
                if let code = json[KResultCode].int {
                    let errorMsg = json[KErrorMsg].string
                    if code == 0 {
                        return Observable.just(object)
                    } else {
                        return Observable.error(ErrorFactory.createError(code: networkErrorType.serverDataCodeError.0, errorMessage: errorMsg ?? networkErrorType.serverDataCodeError.1))
                    }
                } else {
                    // resultCode 异常
                    return Observable.error(ErrorFactory.createError(code: networkErrorType.resultCodeInvalidate.0, errorMessage: networkErrorType.resultCodeInvalidate.1))
                }
            } catch {
                
                switch error {
                case MoyaError.jsonMapping(_):
                    return Observable.error(ErrorFactory.createError(code: networkErrorType.jsonToObjectError.0, errorMessage: networkErrorType.jsonToObjectError.1))
                default:
                    break
                }
                return Observable.error(MoyaError.jsonMapping(response))
            }
        }
    }
    
    public func mapNoVerifyObject<T: BaseMappable>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            
            do {
                
                let object = try response.mapObject(T.self)
                
                return Observable.just(object)
                
            } catch {
                
                switch error {
                case MoyaError.jsonMapping(_):
                    return Observable.error(ErrorFactory.createError(code: networkErrorType.jsonToObjectError.0, errorMessage: networkErrorType.jsonToObjectError.1))
                default:
                    break
                }
                return Observable.error(MoyaError.jsonMapping(response))
            }
        }
    }

}

class ErrorFactory {
    class func createError(code: Int = 200, errorMessage message: String = "未知错误") -> Swift.Error {
        return NSError(domain: message, code: code, userInfo: nil) as Swift.Error
    }
}

