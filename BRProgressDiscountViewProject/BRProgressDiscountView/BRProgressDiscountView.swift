//
//  BRProgressDiscountView.swift
//  BRProgressDiscountViewProject
//
//  Created by git burning on 2019/7/2.
//  Copyright © 2019 git burning. All rights reserved.
//

import UIKit

public class BRProgressDiscountView: UIView {

    var eEdgeInset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    private var mProgressView:UIView!
    private var mProgressBgView:UIView!
    fileprivate var mDataArray:[BRItemObject]?
    fileprivate var mOverProgressBgView:BRProgressDiscountView?
    //进度节点⭕️views
    fileprivate var mItemCircleViewList:[BRItemCircleView]?
    //超过总进度，追加宽度
    var overProgressWidth:CGFloat = 0 {
        didSet{
            if overProgressWidth > 0 {
                if mOverProgressBgView == nil {
                    let overView = BRProgressDiscountView()
                    self.addSubview(overView)
                    self.sendSubviewToBack(overView)
                    self.mOverProgressBgView = overView
                    overView.backgroundColor = mProgressBgColor
                    overView.mProgress = 0
                    self.setNeedsLayout()
                }
               
            }
        }
    }
    /// 进度颜色
    var mProgressingColor:UIColor = UIColor.orange {
        didSet{
            mProgressView.backgroundColor = mProgressingColor
        }
    }
    /// 进度背景颜色
    var mProgressBgColor:UIColor = UIColor.gray {
        didSet{
            mProgressBgView.backgroundColor = mProgressBgColor
            mOverProgressBgView?.backgroundColor = mProgressBgColor
        }
    }
    /// 当前进度
    var mProgress:CGFloat = 0.4
    //进度显示
    var mPopProgressView:BRTopProgressView?
    
    //是否忽略折点宽度，作为进度
    var mIgnoreInfectionPointWidth:Bool = false
    
    public override  func awakeFromNib() {
        super.awakeFromNib()
        self.br_configSubView()
        
    }
    public override init(frame: CGRect) {
        super.init(frame:frame)
        self.br_configSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func br_configSubView() {

        mItemCircleViewList = []
        let progressBgView = UIView()
        self.addSubview(progressBgView)
        mProgressBgView = progressBgView
        mProgressBgView.clipsToBounds = true
        mProgressBgView.backgroundColor = self.mProgressBgColor
        
        
        let progressView = UIView()
        mProgressBgView.addSubview(progressView)
        mProgressView = progressView
        mProgressView.clipsToBounds = true
        mProgressView.backgroundColor = self.mProgressingColor
        
        let popProgressView = BRTopProgressView(frame: CGRect.zero)
        self.addSubview(popProgressView)
        popProgressView.translatesAutoresizingMaskIntoConstraints = false
//        popProgressView.mTextEdageInset = UIEdgeInsets(top: 9, left: 4, bottom: 9, right: 4)
        let left_x = NSLayoutConstraint(item: popProgressView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let buttom_y = NSLayoutConstraint(item: popProgressView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: -17)
        self.addConstraints([left_x,buttom_y])
        popProgressView.mBackgroundColor = UIColor.orange
        popProgressView.mTextLabel?.textColor = UIColor.white
        popProgressView.layer.zPosition = 1001//最上层
        popProgressView.mDirection = .right
        mPopProgressView = popProgressView
        
    }
    /// 更新进度列表
    ///
    /// - Parameter list: <#list description#>
    func br_updateListData(list:[BRItemObject]?) {
        if (list?.count ?? 0 ) > 0 {
            _ = self.subviews.compactMap({($0 as? BRItemCircleView)?.removeFromSuperview()})
            mDataArray = list
            self.mItemCircleViewList?.removeAll()
            list?.forEach({ (obj) in
                let a_view = BRItemCircleView(frame: CGRect.zero)
                a_view.frame = CGRect(x: 0, y: 0, width: obj.itemSize.width, height: obj.itemSize.height)
                self.addSubview(a_view)
                a_view.tag = obj.mTag
                a_view.mItemInfoModel = obj
                self.mItemCircleViewList?.append(a_view)
            })
            self.br_updatePointPoztion()
        }
    }
    
    
    /// 更新进度
    ///
    /// - Parameter progress: <#progress description#>
    func br_updateProgress(progress:CGFloat) {
        mProgress = progress
        if progress >= 1 {
            self.mOverProgressBgView?.mProgress = 0.3
        }
        self.setNeedsLayout()
    }
    
    
    /// 获取 进度item model
    ///
    /// - Returns: <#return value description#>
    class func br_getProgressItemModel() -> BRItemObject {
        let temp = BRItemObject()
        return temp
    }
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        mProgressBgView.frame = self.bounds
        mProgressView.layer.cornerRadius = self.bounds.size.height / 2.0
        mProgressBgView.layer.cornerRadius = self.bounds.size.height / 2.0

        var progress = min(1, self.mProgress)
        progress = max(0, progress)
        let progressing_x = self.bounds.size.width * progress
        
        //更新进度
        mProgressView.frame = CGRect(x: -mProgressBgView.bounds.width + progressing_x, y: 0, width: mProgressBgView.bounds.width, height: mProgressBgView.bounds.height)
        
        if self.overProgressWidth > 0 {
            self.mOverProgressBgView?.isHidden = false
            self.mOverProgressBgView?.frame = CGRect(x: self.bounds.width - self.bounds.height, y: 0, width: overProgressWidth, height: self.bounds.height)
            self.mOverProgressBgView?.layer.cornerRadius = self.bounds.height / 2.0
            self.mOverProgressBgView?.clipsToBounds = true
        }
        else{
            self.mOverProgressBgView?.isHidden = true
        }
        
        //更新折点进度
        self.br_updatePointPoztion()
        
        //更新pop progress
        if let popProgressView = self.mPopProgressView {
            var popFrame = popProgressView.frame
            if progressing_x + popFrame.size.width >= self.bounds.size.width {//超标了需要靠y右
                popProgressView.mDirection = .right
                popFrame.origin.x = progressing_x - popFrame.size.width
            }else{
                popProgressView.mDirection = .left
                popFrame.origin.x = progressing_x
            }
            popProgressView.frame = popFrame
        }
    }
    
    
    //更新 折点的
    fileprivate func br_updatePointPoztion() {
        let outFrame = self.bounds
        self.subviews.forEach { (obj) in
            if let obj = obj as?BRItemCircleView{
                var progress = min(1, obj.mItemInfoModel?.item_progress ?? 0)
                progress = max(0, progress)
                
                let progress_x = outFrame.width * progress
                var tempFrame = obj.frame
                var offset_x:CGFloat = 0
                if obj.mItemInfoModel?.mPointPoztion == .center{
                    offset_x = (obj.mItemInfoModel?.itemSize.width ?? 0) / 2.0
                }
                else if obj.mItemInfoModel?.mPointPoztion == .left {
                    offset_x = (obj.mItemInfoModel?.itemSize.width ?? 0)
                }
                else if obj.mItemInfoModel?.mPointPoztion == .right{
                    offset_x = -(obj.mItemInfoModel?.itemSize.width ?? 0)
                }
                tempFrame.origin.x = progress_x - offset_x
                tempFrame.origin.y = (outFrame.height - obj.frame.height) / 2.0
                obj.frame = tempFrame
                obj.backgroundColor = self.mProgressBgColor
                
                var offset_progress:CGFloat = 0
                if mIgnoreInfectionPointWidth == false {
                    offset_progress = obj.frame.size.width / 2.0 / outFrame.size.width
                }
                if (progress - offset_progress) <= self.mProgress {
                    obj.mSelected = true
                }
                else{
                    obj.mSelected = false
                }
            }
        }
        
        self.br_judgaPopProgressHidden()
    }
    
    
    
    /// 判断 顶部进度是否显示或者隐藏
    fileprivate func br_judgaPopProgressHidden() {
        //1:找到未满足进度的 圆圈最后一个
        //永远在状态更新之后，
        let outFrame = self.bounds
        let last_circleView = self.mItemCircleViewList?.filter({$0.mSelected == false}).first
        if let last_circleView = last_circleView  {//找到了
            let offset_progress = last_circleView.frame.size.width / 2.0 / outFrame.size.width
            var progress = min(1, last_circleView.mItemInfoModel?.item_progress ?? 0)
            progress = max(0, progress)
            if (progress - offset_progress) <= self.mProgress{
                self.mPopProgressView?.isHidden = true
            }
            else{
                self.mPopProgressView?.isHidden = false
            }
        }
        
        let seleted_last_circleView = self.mItemCircleViewList?.filter({$0.mSelected == true}).last
        if let seleted_last_circleView = seleted_last_circleView  {
            let offset_progress = seleted_last_circleView.frame.size.width / 2.0 / outFrame.size.width
            var progress = min(1, seleted_last_circleView.mItemInfoModel?.item_progress ?? 0)
            progress = max(0, progress)
            if (progress - offset_progress) <= self.mProgress{//判断 超过
                self.mPopProgressView?.isHidden = true
                if self.mProgress > progress + offset_progress {//超过了最大边界
                    self.mPopProgressView?.isHidden = false
                }
            }
            
        }
        
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public  class BRItemObject {
        var item_count:CGFloat = 0
        var up_name:String? = "8折"
        var down_name:String? = "1000件"
        var item_progress:CGFloat = 0
        var name:String? = "8折"
        var mSelectedImg:UIImage?
        var mTag:Int = 0;
        var mPointPoztion:NSTextAlignment = .center
        var itemSize:CGSize = CGSize(width: 30, height: 30)
        
        var text_config:BRItemLabelConfigObject? = BRItemLabelConfigObject()
        var up_config:BRItemLabelConfigObject? = BRItemLabelConfigObject()
        var down_config:BRItemLabelConfigObject? = BRItemLabelConfigObject()

        
    }
    public class BRItemLabelConfigObject{
        var text_color:UIColor? = UIColor.black
        var text_font_size:CGFloat = 12
    }
    //进度节点view
    public class BRItemCircleView: UIView {
        
        private let kSelectedImgTag = 10
        
        var mSelectedImgView:UIImageView?
        {
            get{
                let temp = self.viewWithTag(kSelectedImgTag)
                if temp == nil {
                    let img = UIImageView()
                    img.tag = kSelectedImgTag
                    self.addSubview(img)
                    img.isHidden = true
                    return img
                }
                return temp as? UIImageView
            }
        }
        var mSelected:Bool = false {
            didSet{
                mSelectedImgView?.isHidden = !mSelected
                mSelectedImgView?.image = mItemInfoModel?.mSelectedImg
            }
        }
        
        var mUpLabel:UILabel?
        var mDownLabel:UILabel?
        var mMiddleLabel:UILabel?
        var mItemInfoModel:BRItemObject?{
            didSet{
                mUpLabel?.text = mItemInfoModel?.up_name
                mDownLabel?.text = mItemInfoModel?.down_name
                mMiddleLabel?.text = mItemInfoModel?.name
                self.mSelectedImgView?.image = self.mItemInfoModel?.mSelectedImg
                mMiddleLabel?.textAlignment = mItemInfoModel?.mPointPoztion ?? .center
                
                mUpLabel?.textColor = mItemInfoModel?.up_config?.text_color
                if let fontSize = mItemInfoModel?.up_config?.text_font_size {
                    mUpLabel?.font = UIFont.systemFont(ofSize: fontSize)
                }
                
                mDownLabel?.textColor = mItemInfoModel?.down_config?.text_color
                if let fontSize = mItemInfoModel?.down_config?.text_font_size {
                    mDownLabel?.font = UIFont.systemFont(ofSize: fontSize)
                }
                mMiddleLabel?.textColor = mItemInfoModel?.text_config?.text_color
                if let fontSize = mItemInfoModel?.text_config?.text_font_size {
                    mMiddleLabel?.font = UIFont.systemFont(ofSize: fontSize)
                }

            }
        }
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            self.br_configSubView()
        }
       
        public override  func awakeFromNib() {
            super.awakeFromNib()
            self.br_configSubView()
            
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func br_configSubView() {
//            self.clipsToBounds = true
            let uplabel = UILabel()
            self.addSubview(uplabel)
            mUpLabel = uplabel
            uplabel.text = "8折"
            uplabel.textAlignment = .center
            
            let downLabel = UILabel()
            self.addSubview(downLabel)
            mDownLabel = downLabel
            downLabel.text = "1000件"
            downLabel.textAlignment = .center
            
            let middleLabel = UILabel()
            self.addSubview(middleLabel)
            mMiddleLabel = middleLabel
            mMiddleLabel?.text = "8折"
            mMiddleLabel?.textAlignment = .center
            
            //NSLayoutConstraint
            uplabel.translatesAutoresizingMaskIntoConstraints = false
            let up_center_x = NSLayoutConstraint(item: uplabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            let up_top_y = NSLayoutConstraint(item: uplabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: -6)
            self.addConstraint(up_center_x)
            self.addConstraint(up_top_y)

            downLabel.translatesAutoresizingMaskIntoConstraints = false
            let down_center_x = NSLayoutConstraint(item: downLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            let down_top_y = NSLayoutConstraint(item: downLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 6)
            self.addConstraint(down_center_x)
            self.addConstraint(down_top_y)
            
        }
        
        override public func layoutSubviews() {
            super.layoutSubviews()
            
            self.mSelectedImgView?.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height);
            self.layer.cornerRadius = self.bounds.size.height / 2.0
            mMiddleLabel?.layer.cornerRadius = self.bounds.size.height / 2.0
            mMiddleLabel?.frame = self.bounds
            
        }
    }
    
    public class BRTopProgressView: UIView {
        
        enum TriangleDirection {
            case left
            case middle
            case right
        }
        var mTextLabel:UILabel?
        var mTextEdageInset:UIEdgeInsets = UIEdgeInsets.zero {
            didSet {
                guard let temp_text_label = mTextLabel else {
                    return
                }
                let constraint_list = self.constraints.filter({($0.firstItem as? UILabel) == self.mTextLabel})
                if constraint_list.count > 0 {
                    //有约束
                    constraint_list.forEach { (obj) in
                        if (obj.firstItem as? UILabel) == self.mTextLabel {
                            if obj.firstAttribute.rawValue == NSLayoutConstraint.Attribute.top.rawValue{
                                obj.constant = mTextEdageInset.top
                            }else  if obj.firstAttribute.rawValue == NSLayoutConstraint.Attribute.left.rawValue{
                                obj.constant = mTextEdageInset.left
                            }
                            else  if obj.firstAttribute.rawValue == NSLayoutConstraint.Attribute.right.rawValue{
                                obj.constant = -mTextEdageInset.right
                            }
                            else  if obj.firstAttribute.rawValue == NSLayoutConstraint.Attribute.bottom.rawValue{
                                obj.constant = -mTextEdageInset.bottom
                            }
                        }
                       
                        
                    }
                    
                }
                else{//无约束
                    let topY = NSLayoutConstraint(item: temp_text_label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: mTextEdageInset.top)
                    
                    let left_x = NSLayoutConstraint(item: temp_text_label, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: mTextEdageInset.left)
                    
                    let right_x = NSLayoutConstraint(item: temp_text_label, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -mTextEdageInset.right)
                    
                    let buttomY = NSLayoutConstraint(item: temp_text_label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -mTextEdageInset.bottom)

//                    let textHeight = NSLayoutConstraint(item: temp_text_label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: mTextHeight)
                    
                    self.addConstraints([topY,left_x,right_x,buttomY])
                }
 
                
            }
        }
       
        //三角形
        var mArrowView:UIView?
        var mButtomTriangleView:BRTriangleView?
        //箭头方向,左、中、右
        var mDirection:TriangleDirection = .left {
            didSet{
                if let triangView = mButtomTriangleView {
                    let triang_list = self.constraints.filter({($0.firstItem as? BRTriangleView) == triangView})
                    self.removeConstraints(triang_list)
                    
                    var left_x =  NSLayoutConstraint(item: triangView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
                    if mDirection == .middle {
                        left_x = NSLayoutConstraint(item: triangView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
                        triangView.mDirection = .buttomCenter
                    }
                    else if mDirection == .right {
                        left_x = NSLayoutConstraint(item: triangView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
                        triangView.mDirection = .buttomRight
                    }
                    else{
                        triangView.mDirection = .buttomLeft
                    }
                    
                    let top_y = NSLayoutConstraint(item: triangView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
                    
                    let size_width = NSLayoutConstraint(item: triangView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 13)
                    let size_height = NSLayoutConstraint(item: triangView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 12)

                    self.addConstraints([left_x,top_y,size_width,size_height])
                }

            }
        }
        
        var mBackgroundColor: UIColor?{
            didSet{
                mButtomTriangleView?.mBackgroundColor = mBackgroundColor
            }
        }
        
        var mBgView:UIView!
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            self.br_configSubView()
        }
        public override func awakeFromNib() {
            super.awakeFromNib()
            self.br_configSubView()
        }
        func br_configSubView() {
            
            let bgView = UIView()
            self.addSubview(bgView)
            mBgView = bgView
            
            let textLabel = UILabel()
            self.addSubview(textLabel)
            textLabel.font = UIFont.systemFont(ofSize: 10)
            textLabel.textAlignment = .center
            textLabel.text = "还差120件升级折扣"
            textLabel.numberOfLines = 0
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            mTextLabel = textLabel
            
            let defaultEdge = UIEdgeInsets(top: 9, left: 7, bottom: 9, right: 7);
            self.mTextEdageInset = defaultEdge

            let triangleView = BRTriangleView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            self.addSubview(triangleView)
            triangleView.translatesAutoresizingMaskIntoConstraints = false
            mButtomTriangleView = triangleView
            self.mDirection = .left
            
            mBgView.backgroundColor = UIColor.orange
            
           

        }
        public override func layoutSubviews() {
            super.layoutSubviews()
            mBgView.frame = self.bounds;
            _ = mBgView.br_addCustomerCorner(radii: 5, type: mDirection)
            //_ = self.br_addCustomerCorner(radii: 5, type: mDirection)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        class BRTriangleView: UIView {
            enum ArrowDirection {
                case buttomLeft
                case buttomCenter
                case buttomRight
            }
            var mDirection:ArrowDirection = .buttomLeft {
                didSet{
                    self.setNeedsLayout()
                }
            }
            var mBackgroundColor: UIColor? {
                didSet{
                    self.setNeedsLayout()
                }
            }
            private lazy var linePath : UIBezierPath = UIBezierPath()
            private lazy var lineShape : CAShapeLayer = CAShapeLayer()
            override init(frame: CGRect) {
                super.init(frame: frame)
                lineShape.path = linePath.cgPath
                self.layer.addSublayer(lineShape)
            }
            
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            override func layoutSubviews() {
                super.layoutSubviews()
                let all_size = self.bounds.size
                let startPoint = CGPoint(x: 0, y: 0)
                let endPoint = CGPoint(x: all_size.width, y: 0)
                var middlePoint = CGPoint(x: 0, y: all_size.height)
                if mDirection == .buttomCenter{
                    middlePoint.x = all_size.width / 2.0
                }
                else if mDirection == .buttomRight{
                    middlePoint.x = all_size.width
                }
                linePath.removeAllPoints()
                linePath.move(to: startPoint)
                linePath.addLine(to: middlePoint)
                linePath.addLine(to: endPoint)
                linePath.close()
                lineShape.frame=CGRect(x:0, y:0, width:frame.size.width, height:frame.size.height)
                lineShape.path = linePath.cgPath
                lineShape.fillColor = self.mBackgroundColor?.cgColor
            }
        }
    }
}



extension UIView {
    /// 增加顶部圆角
    ///
    /// - Parameter radii: <#radii description#>
    /// - Returns: <#return value description#>
    func br_addCustomerCorner(radii:CGFloat,type:BRProgressDiscountView.BRTopProgressView.TriangleDirection) -> CALayer {
        if self.layer.mask != nil {
            self.layer.mask = nil
        }
        var corners:UIRectCorner = [UIRectCorner.topRight,UIRectCorner.topLeft,UIRectCorner.bottomLeft,UIRectCorner.bottomRight]
        if type == .left {
            corners = [UIRectCorner.topRight,UIRectCorner.topLeft,UIRectCorner.bottomRight]
        }
        else if type == .right {
            corners = [UIRectCorner.topRight,UIRectCorner.topLeft,UIRectCorner.bottomLeft]
        }

        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners:corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        return maskLayer
        
    }
    
}
