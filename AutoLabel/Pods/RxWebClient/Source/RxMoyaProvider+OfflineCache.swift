//
//  RxMoyaProvider+OfflineCache.swift
//  rabbitDoctor
//
//  Created by Mac on 2017/8/1.
//  Copyright © 2017年 rabbitDoctor. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Result

public protocol CacheProtocol {
    func readOffLineCache() -> Any?
}

public extension RxMoyaProvider {
    func tryUseOfflineCacheThenRequest(_ token: Target, _ cacheProtocol: CacheProtocol) -> Observable<Moya.Response> {
        return Observable.create { [weak self] observer -> Disposable in
            
            var cancelableToken: Cancellable?
            
            // 先读取缓存内容，有则发出一个信号（onNext），没有则跳过
            if cacheProtocol.readOffLineCache() != nil {
                
                do {
                    let prettyData =  try JSONSerialization.data(withJSONObject: cacheProtocol.readOffLineCache()!, options: .prettyPrinted)
                    observer.onNext(Response(statusCode: 0, data: prettyData))
                    
                } catch {
                    
                }
                
            }
            
            cancelableToken = self?.request(token) { result in
                
                switch result {
                case let .success(response):
                    observer.onNext(response)
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
