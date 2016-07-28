//
//  WTKRingView.swift
//  WTKRingView
//
//  Created by 王同科 on 16/7/28.
//  Copyright © 2016年 王同科. All rights reserved.
//

import UIKit

class WTKRingView: UIView,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource {

    var imageArray          : NSMutableArray?
    
    var collectionView      : UICollectionView?
    var isDragging           = false  //判断当前是否正在拖拽collectionView
    var timer               : NSTimer?
    
    var clickPage           :((tag : Int) ->Void)? //回调
    
    let kWIDTH = UIScreen.mainScreen().bounds.width
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initSubView()
    }
    
    func initSubView(){
        
//        设置默认轮播图  一页
        imageArray?.addObject("1")
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(kWIDTH, kWIDTH)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionView = UICollectionView.init(frame: CGRectMake(0, 0, kWIDTH, kWIDTH), collectionViewLayout: layout)
        collectionView?.dataSource = self;
        collectionView?.delegate = self;
        
        collectionView?.registerNib(UINib.init(nibName: "WTKRingViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "cell")
        
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        
        self.addSubview(collectionView!)
    }
    
//    刷新轮播图
    func refreshRingView(imgArray:NSArray){
        self.imageArray = imgArray.mutableCopy() as? NSMutableArray
        
        let first = imageArray?.firstObject
        let last = imageArray?.lastObject
        self.imageArray?.insertObject(last!, atIndex: 0)
        self.imageArray?.addObject(first!)
        
        self.collectionView?.reloadData()
        self.collectionView?.contentOffset = CGPointMake(kWIDTH, 0)
        
        timer = NSTimer.init(timeInterval: 2, target: self, selector: #selector(WTKRingView.timermethod), userInfo: "", repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
        timer?.fireDate = NSDate.distantPast()
        
    }
    
    
//    MARK: - collectionViewDelegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (imageArray?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell : WTKRingViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as!WTKRingViewCell
        let imageName = self.imageArray![indexPath.row] as!String
        cell.imageView.image = UIImage(named: imageName)
        return cell
    }
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        //        滚动结束
        let row = Int(collectionView.contentOffset.x) / Int(kWIDTH)
        if row == 0
        {
            collectionView.contentOffset = CGPointMake(kWIDTH * CGFloat((self.imageArray?.count)! - 2), 0)
        }
        if row == (self.imageArray?.count)! - 1 {
            collectionView.contentOffset = CGPointMake(kWIDTH, 0)
        }
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (clickPage != nil)
        {
            clickPage!(tag:indexPath.row - 1)
        }
    }
    
    
//    MARK: - scrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView){
        self.isDragging = true
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.9 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.isDragging = false
        }
        
        
    }
    
    
//    timerMethod
    func timermethod()
    {
        if isDragging
        {
            return
        }
        var offset = collectionView?.contentOffset
        offset?.x += kWIDTH
        collectionView?.setContentOffset(offset!, animated: true)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
