//
//  RxMoyaProvider+ExceptionRequest.swift
//  rabbitDoctor
//
//  Created by Mac on 2017/8/2.
//  Copyright © 2017年 rabbitDoctor. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper
import Result
import SwiftyJSON

public extension RxMoyaProvider {
    func tryExceptionRequest<T: Any>(_ token: Target, _ type: T.Type) -> Observable<T> {
        return Observable.create { [weak self] observer -> Disposable in
            
            let cancelableToken = self?.request(token) { result in
                switch result {
                case let .success(response):
                    
                    let json = JSON.init(data: response.data)
                    
                    let templateType = "\(T.self)".lowercased()
                    
                    switch json.type {
                    case .array where templateType.contains("array"):
                        observer.onNext(json.arrayValue as! T)
                    case .dictionary where templateType.contains("dictionary"):
                        observer.onNext(json.dictionaryValue as! T)
                    case .number where (templateType.contains("number")
                        || templateType.contains("int")
                        || templateType.contains("float")
                        || templateType.contains("double")),
                         .bool where templateType.contains("bool"):
                        observer.onNext(json.numberValue as! T)
                    case .string where templateType.contains("string"):
                        observer.onNext(json.stringValue as! T)
                    default:
                        observer.onError(ErrorFactory.createError(code: networkErrorType.paraTypeError.0, errorMessage: networkErrorType.paraTypeError.1))
                    }
                    
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                cancelableToken?.cancel()
            }
            
        }
    }
    
}
