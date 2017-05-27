//
//  FXADScrollView.swift
//  CRMSwift
//
//  Created by 鱼米app on 2017/5/23.
//  Copyright © 2017年 LFX. All rights reserved.
//

import UIKit

enum FXPageControllStyle {
    
    case TopLeft
    case TopCenter
    case TopRight
    case BottomLeft
    case BottomCenter
    case BottomRight
}

protocol FXADScrollViewDelegate {
    
    func adScrollView(adScrollView: FXADScrollView, didSelectedItem item: Int)
}

class FXADScrollView: UIView {

    //MARK: - property
    fileprivate var scrollView = UIScrollView()
    fileprivate var pageControll = UIPageControl()
    fileprivate var animationTime = 2.0
    fileprivate var loopTimer : Timer?
    fileprivate var viewWidth : CGFloat = 0.0;
    fileprivate var viewHeight : CGFloat = 0.0;
    
    var autoAnimation = true
    var placeHolderImgNm : String?
    var adDataArray = [String]()
    var delegate : FXADScrollViewDelegate?
    
    var hidenPage : Bool = false {
        
        didSet {
            pageControll.isHidden = hidenPage
        }
    }
    var pageStyle : FXPageControllStyle = .BottomCenter {
        
        didSet {
            
            setPagePostion()
        }
    }
    
    //MARK: - func
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewWidth = frame.size.width
        viewHeight = frame.size.height
        
        setScrollView()
        setPageControll()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setPagePostion() {
        
        let pageW = pageControll.frame.size.width
        let pageH = pageControll.frame.size.height
        let pageMrg : CGFloat = 8.0
        
        switch pageStyle {
        case .TopLeft:
            pageControll.frame.origin = CGPoint(x: pageMrg, y: 0)
        case .TopCenter:
            pageControll.frame.origin = CGPoint(x: (viewWidth - pageW) * 0.5, y: pageMrg)
        case .TopRight:
            pageControll.frame.origin = CGPoint(x: viewWidth - pageW - pageMrg, y: pageMrg)
        case .BottomLeft:
            pageControll.frame.origin = CGPoint(x: pageMrg, y: viewHeight - pageH)
        case .BottomCenter:
            pageControll.frame.origin = CGPoint(x: (viewWidth - pageW) * 0.5, y: viewHeight - pageH)
        case .BottomRight:
            pageControll.frame.origin = CGPoint(x: viewWidth - pageW - pageMrg, y: viewHeight - pageH)
        }
    }
    
    fileprivate func setScrollView() {
    
        scrollView = UIScrollView.init(frame: bounds)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
    }
    
    fileprivate func setPageControll() {
    
        pageControll = UIPageControl()
        pageControll.isEnabled = false
        pageControll.numberOfPages = adDataArray.count
        pageControll.currentPage = 0
        pageControll.currentPageIndicatorTintColor = UIColor.white
        pageControll.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.6)
        addSubview(pageControll)
    }
    
    func loadAdDataArrayThenStartAniamtion() {
        
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(adDataArray.count + 2) * viewWidth, height: viewHeight)

        pageControll.numberOfPages = adDataArray.count
        let pageW = pageControll.size(forNumberOfPages: adDataArray.count).width
        let pageH = pageControll.size(forNumberOfPages: adDataArray.count).height
        pageControll.bounds = CGRect(x: 0, y: 0, width: pageW, height: pageH * 0.5)
        
        setPagePostion()
        
        let firstImg = adDataArray.last!
        let lastImg = adDataArray.first!
        adDataArray.insert(firstImg, at: 0)
        adDataArray.append(lastImg)
        
        for i in 0 ..< adDataArray.count {
        
            let imgV = UIImageView(frame: CGRect(x: CGFloat(i) * viewWidth, y: 0, width: viewWidth, height: viewHeight))
            
            if (i > 0 && i < adDataArray.count - 1) {
                imgV.tag = i - 1
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapBanner(tap:)))
                imgV.isUserInteractionEnabled = true
                imgV.addGestureRecognizer(tap)
            }
            
            //warning: 1.打开下面三行代码
//            let urlStr = adDataArray[i]
//            let url = URL.init(string: urlStr)
//            imgV.sd_setImage(with: url!, placeholderImage: UIImage.init(named: placeHolderImgNm!))
            
            //warning: 2.注释下面一行代码
            imgV.image = UIImage.init(named: placeHolderImgNm!)
            
            scrollView.addSubview(imgV)
        }
        
        scrollView.contentOffset = CGPoint(x: viewWidth, y: 0)
        
        if autoAnimation {
            
            if loopTimer == nil {
                loopTimer = Timer.scheduledTimer(timeInterval: animationTime, target: self, selector: #selector(animationLoopStart), userInfo: nil, repeats: true)
                RunLoop.current.add(loopTimer!, forMode: RunLoopMode.commonModes)
            }
        }
    }
    
    @objc fileprivate func animationLoopStart() {
        
        var currentPageNum = Int(scrollView.contentOffset.x/viewWidth)
        if currentPageNum == 0 {
            pageControll.currentPage = pageControll.numberOfPages - 1
        }else if currentPageNum == self.pageControll.numberOfPages + 1 {
            pageControll.currentPage = 0
        }else {
            pageControll.currentPage = currentPageNum - 1
        }
        
        var newPageNum = pageControll.currentPage
        let rect = CGRect(x: CGFloat(newPageNum + 2) * viewWidth, y: 0, width: viewWidth, height: viewHeight)
        
        UIView.animate(withDuration: 0.7, animations: {
            
            self.scrollView.scrollRectToVisible(rect, animated: false)
        }) { (finished) in
            
            newPageNum = newPageNum + 1
            if newPageNum == self.pageControll.numberOfPages {
                self.scrollView.contentOffset = CGPoint(x: self.viewWidth, y: 0)
            }
        }
        
        currentPageNum = Int(scrollView.contentOffset.x/viewWidth)
        if currentPageNum == 0 {
            pageControll.currentPage = pageControll.numberOfPages - 1
        }else if currentPageNum == self.pageControll.numberOfPages + 1 {
            pageControll.currentPage = 0
        }else {
            pageControll.currentPage = currentPageNum - 1
        }
    }
    
    @objc fileprivate func tapBanner(tap: UITapGestureRecognizer) {
        
        let view = tap.view!
        let tag = view.tag
        delegate?.adScrollView(adScrollView: self, didSelectedItem: tag)
    }
}

//MARK: - scroll view delegate
extension FXADScrollView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var currentPageNum = Int(scrollView.contentOffset.x/viewWidth)
        
        if currentPageNum == 0 {
            
            scrollView.scrollRectToVisible(CGRect.init(x: viewWidth * CGFloat(pageControll.numberOfPages), y: 0, width: viewWidth, height: viewHeight), animated: false)
            currentPageNum = pageControll.numberOfPages - 1
        }else if currentPageNum == pageControll.numberOfPages + 1 {
            
            scrollView.scrollRectToVisible(CGRect.init(x: viewWidth, y: 0, width: viewWidth, height: viewHeight), animated: false)
            currentPageNum = 0
        }else {
            
            currentPageNum = currentPageNum - 1
        }
        
        pageControll.currentPage = currentPageNum
        
        if autoAnimation {
            if loopTimer == nil {
                loopTimer = Timer.scheduledTimer(timeInterval: animationTime, target: self, selector: #selector(animationLoopStart), userInfo: nil, repeats: true)
                RunLoop.current.add(loopTimer!, forMode: RunLoopMode.commonModes)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if (autoAnimation && loopTimer != nil) {
            
            loopTimer!.invalidate()
            loopTimer = nil
        }
    }
}
