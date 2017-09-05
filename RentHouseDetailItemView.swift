//
//  RentHouseDetailItemView.swift
//  rabbitDoctor
//
//  Created by Mac on 2017/9/5.
//  Copyright © 2017年 rabbitDoctor. All rights reserved.
//

import UIKit

class RentHouseDetailItemView: UIView {
    
    var collectionView: UICollectionView!
    fileprivate var sources: [RentHouseDetailInfoFacilitiesModel]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(frame: CGRect, sources: [RentHouseDetailInfoFacilitiesModel]) {
        self.init(frame: frame)
        self.sources = sources
        setInterface()
    }
    
    public func reloadData(sources: [RentHouseDetailInfoFacilitiesModel]) {
        self.sources = sources
        collectionView.reloadData()
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(kScreenWidth)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: private methods
extension RentHouseDetailItemView {
    func setInterface() {
        //初始化UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout.init()
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.height), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white//背景色
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: "RentHouseDetailItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RentHouseDetailItemCollectionViewCell")
        
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(kScreenWidth)
        }
    }
}

extension RentHouseDetailItemView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = kScreenWidth / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
}

extension RentHouseDetailItemView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sources = self.sources {
            return sources.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RentHouseDetailItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RentHouseDetailItemCollectionViewCell", for: indexPath) as! RentHouseDetailItemCollectionViewCell
        cell.bindData(self.sources?[indexPath.row])
        return cell
    }
}


