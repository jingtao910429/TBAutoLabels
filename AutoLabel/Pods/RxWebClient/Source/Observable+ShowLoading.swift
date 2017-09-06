
//
//  Observable+ShowLoading.swift
//  rabbitDoctor
//
//  Created by Mac on 2017/8/2.
//  Copyright © 2017年 rabbitDoctor. All rights reserved.
//

import Foundation
import RxSwift
import Moya

public protocol LoadingViewProtocol {
    func removeLoadingView(view: UIView)
    func showLoadingView(view: UIView?)
}

public extension Observable {
    
    //加载视图
    func showLoading(activity: UIView, loadingManager: LoadingViewProtocol? , disposeBag: DisposeBag) -> Observable {
        
        let indicator = ActivityIndicator()
        activity.manager = loadingManager
        indicator.asObservable()
            .bindTo(activity.rx_imageView_animating)
            .addDisposableTo(disposeBag)
        
        return self.trackActivity(indicator)
    }
    
}

extension UIView {
    
    private struct AssociatedKeys {
        static var loadingViewKey = "UIViewController.LoadingViewKey"
    }
    
    var manager: LoadingViewProtocol? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadingViewKey) as? LoadingViewProtocol
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.loadingViewKey,
                    newValue as LoadingViewProtocol?,
                    .OBJC_ASSOCIATION_COPY_NONATOMIC
                )
            }
        }
    }
    
    public var rx_imageView_animating: AnyObserver<Bool> {
        return AnyObserver { event in
            
            MainScheduler.ensureExecutingOnScheduler()
            
            switch (event) {
            case .next(let value):
                
                guard value else {
                    self.manager?.removeLoadingView(view: self)
                    return
                }
                
                self.manager?.showLoadingView(view: self)
                
            case .error(let error):
                print("Binding error to UI: \(error)")
                self.manager?.removeLoadingView(view: self)
            case .completed:
                self.manager?.removeLoadingView(view: self)
            }
        }
    }
    
}

