//
//  TPKeyBoardExtension.swift
//  TPKeyBoardExample
//
//  Created by dungvh on 7/3/15.
//  Copyright © 2015 dungvh. All rights reserved.
//

import Foundation
import UIKit

// MARK: - TableView
class TPKeyboardAvoidingTableView:UITableView,UITextFieldDelegate, UITextViewDelegate {
    
    override var frame:CGRect{
        willSet{
            super.frame = frame
        }
        
        didSet{
            if hasAutomaticKeyboardAvoidingBehaviour() {return}
            TPKeyboardAvoiding_updateContentInset()
        }
    }
    
    override var contentSize:CGSize{
        willSet(newValue){
            if hasAutomaticKeyboardAvoidingBehaviour() {
                super.contentSize = newValue
                return
            }
            
            if CGSizeEqualToSize(newValue, self.contentSize)
            {
                return
            }
            
            super.contentSize = newValue
            self.TPKeyboardAvoiding_updateContentInset()
        }
        
        //        didSet{
        //            self.TPKeyboardAvoiding_updateContentInset()
        //        }
    }
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func hasAutomaticKeyboardAvoidingBehaviour()->Bool
    {
        if #available(iOS 8.3, *) {
            if self.delegate is UITableViewController
            {
                return true
            }
        }
        
        return false
    }
    
    func focusNextTextField()->Bool
    {
        return self.TPKeyboardAvoiding_focusNextTextField()
    }
    
    func scrollToActiveTextField()
    {
        return self.TPKeyboardAvoiding_scrollToActiveTextField()
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if newSuperview != nil {
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.TPKeyboardAvoiding_findFirstResponderBeneathView(self)?.resignFirstResponder()
        super.touchesEnded(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if !self.focusNextTextField()
        {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), userInfo: nil, repeats: false)
    }
}

private extension TPKeyboardAvoidingTableView
{
    func setup()
    {
        if self.hasAutomaticKeyboardAvoidingBehaviour() { return }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(TPKeyboardAvoiding_keyboardWillShow(_:)),
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(TPKeyboardAvoiding_keyboardWillHide(_:)),
            name: UIKeyboardWillHideNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(scrollToActiveTextField),
            name: UITextViewTextDidBeginEditingNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(scrollToActiveTextField),
            name: UITextFieldTextDidBeginEditingNotification,
            object: nil)
    }
}

// MARK: - CollectionView
class TPKeyboardAvoidingCollectionView:UICollectionView,UITextViewDelegate {
    
    override var contentSize:CGSize{
        willSet(newValue){
            if CGSizeEqualToSize(newValue, self.contentSize)
            {
                return
            }
            
            super.contentSize = newValue
            self.TPKeyboardAvoiding_updateContentInset()
        }
        
//        didSet{
//            self.TPKeyboardAvoiding_updateContentInset()
//        }
    }
    
    
    override var frame:CGRect{
        willSet{
            super.frame = frame
        }
        
        didSet{
            self.TPKeyboardAvoiding_updateContentInset()
        }
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.setup()
        
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func focusNextTextField()->Bool
    {
        return self.TPKeyboardAvoiding_focusNextTextField()
    }
    
    func scrollToActiveTextField()
    {
        return self.TPKeyboardAvoiding_scrollToActiveTextField()
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if newSuperview != nil {
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.TPKeyboardAvoiding_findFirstResponderBeneathView(self)?.resignFirstResponder()
        super.touchesEnded(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if !self.focusNextTextField()
        {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), userInfo: nil, repeats: false)
    }
}

private extension TPKeyboardAvoidingCollectionView
{
    func setup()
    {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(TPKeyboardAvoiding_keyboardWillShow(_:)),
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(TPKeyboardAvoiding_keyboardWillHide(_:)),
            name: UIKeyboardWillHideNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(scrollToActiveTextField),
            name: UITextViewTextDidBeginEditingNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(scrollToActiveTextField),
            name: UITextFieldTextDidBeginEditingNotification,
            object: nil)
    }
}

// MARK: - ScrollView
class TPKeyboardAvoidingScrollView:UIScrollView,UITextFieldDelegate,UITextViewDelegate
{
    override var contentSize:CGSize{
        didSet{
            self.TPKeyboardAvoiding_updateFromContentSizeChange()
        }
    }
    
    
    override var frame:CGRect{
        didSet{
            self.TPKeyboardAvoiding_updateContentInset()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    func contentSizeToFit()
    {
        self.contentSize = self.TPKeyboardAvoiding_calculatedContentSizeFromSubviewFrames()
    }
    
    func focusNextTextField() ->Bool
    {
        return self.TPKeyboardAvoiding_focusNextTextField()
    }
    
    func scrollToActiveTextField()
    {
        return self.TPKeyboardAvoiding_scrollToActiveTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if newSuperview != nil {
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.TPKeyboardAvoiding_findFirstResponderBeneathView(self)?.resignFirstResponder()
        super.touchesEnded(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if !self.focusNextTextField()
        {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)

        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), userInfo: nil, repeats: false)
    }
}

private extension TPKeyboardAvoidingScrollView
{
    func setup()
    {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(TPKeyboardAvoiding_keyboardWillShow(_:)),
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(TPKeyboardAvoiding_keyboardWillHide(_:)),
            name: UIKeyboardWillHideNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(scrollToActiveTextField),
            name: UITextViewTextDidBeginEditingNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(scrollToActiveTextField),
            name: UITextFieldTextDidBeginEditingNotification,
            object: nil)
    }
}

// MARK: - Process Event
let kCalculatedContentPadding:CGFloat = 10;
let kMinimumScrollOffsetPadding:CGFloat = 20;

extension UIScrollView
{
    func TPKeyboardAvoiding_keyboardWillShow(notification:NSNotification)
    {
        guard let userInfo = notification.userInfo else { return }
        guard let rectNotification = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else
        {
            return
        }
        
        let keyboardRect = self.convertRect(rectNotification.CGRectValue() , fromView: nil)
        if CGRectIsEmpty(keyboardRect)
        {
            return
        }
        
        let state = self.keyboardAvoidingState()
        
        guard let firstResponder = self.TPKeyboardAvoiding_findFirstResponderBeneathView(self) else { return}
        state.keyboardRect = keyboardRect
        if !state.keyboardVisible
        {
            state.priorInset = self.contentInset
            state.priorScrollIndicatorInsets = self.scrollIndicatorInsets
            state.priorPagingEnabled = self.pagingEnabled
        }
        
        state.keyboardVisible = true
        self.pagingEnabled = false
        
        if self is TPKeyboardAvoidingScrollView
        {
            state.priorContentSize = self.contentSize
            if CGSizeEqualToSize(self.contentSize, CGSizeZero)
            {
                self.contentSize = self.TPKeyboardAvoiding_calculatedContentSizeFromSubviewFrames()
            }
        }
        
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Float ?? 0.0
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int ?? 0
        let options = UIViewAnimationOptions(rawValue: UInt(curve))
        
        UIView.animateWithDuration(NSTimeInterval(duration),
            delay: 0,
            options: options,
            animations: { [weak self]() -> Void in
                if let actualSelf = self
                {
                    actualSelf.contentInset = actualSelf.TPKeyboardAvoiding_contentInsetForKeyboard()
                    let viewableHeight = actualSelf.bounds.size.height - actualSelf.contentInset.top - actualSelf.contentInset.bottom
                    
                    actualSelf.setContentOffset(CGPointMake(actualSelf.contentOffset.x,
                        actualSelf.TPKeyboardAvoiding_idealOffsetForView(firstResponder, viewAreaHeight: viewableHeight)),
                        animated: false)
                    
                    actualSelf.scrollIndicatorInsets = actualSelf.contentInset
                    actualSelf.layoutIfNeeded()
                }
                
            }) { (finished) -> Void in
                
        }
    }
    
    func TPKeyboardAvoiding_keyboardWillHide(notification:NSNotification)
    {
        guard let userInfo = notification.userInfo else { return }
        
        guard let rectNotification = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else
        {
            return
        }
        let keyboardRect = self.convertRect(rectNotification.CGRectValue() , fromView: nil)
        if CGRectIsEmpty(keyboardRect)
        {
            return
        }
        let state = self.keyboardAvoidingState()
        
        if !state.keyboardVisible
        {
            return
        }
        state.keyboardRect = CGRectZero
        state.keyboardVisible = false
        
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Float ?? 0.0
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int ?? 0
        let options = UIViewAnimationOptions(rawValue: UInt(curve))
        
        UIView.animateWithDuration(NSTimeInterval(duration),
            delay: 0,
            options: options,
            animations: { [weak self]() -> Void in
                if let actualSelf = self
                {
                    if actualSelf is TPKeyboardAvoidingScrollView {
                        actualSelf.contentSize = state.priorContentSize
                        actualSelf.contentInset = state.priorInset
                        actualSelf.scrollIndicatorInsets = state.priorScrollIndicatorInsets
                        actualSelf.pagingEnabled = state.priorPagingEnabled
                        actualSelf.layoutIfNeeded()
                    }
                }
                
            }) { (finished) -> Void in
                
        }
    }
    
    func TPKeyboardAvoiding_updateFromContentSizeChange()
    {
        let state = self.keyboardAvoidingState()
        if state.keyboardVisible
        {
            state.priorContentSize = self.contentSize
        }
    }
    
    func TPKeyboardAvoiding_focusNextTextField() ->Bool
    {
        guard let firstResponder = self.TPKeyboardAvoiding_findFirstResponderBeneathView(self) else { return false}
        guard let view = self.TPKeyboardAvoiding_findNextInputViewAfterView(firstResponder, beneathView: self) else { return false}
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: view, selector: #selector(becomeFirstResponder), userInfo: nil, repeats: false)
        
        return true
       
    }
    
    func TPKeyboardAvoiding_scrollToActiveTextField()
    {
        let state = self.keyboardAvoidingState()
        
        if !state.keyboardVisible { return }
        
        let visibleSpace = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom
        
        let idealOffset = CGPointMake(0,
            self.TPKeyboardAvoiding_idealOffsetForView(self.TPKeyboardAvoiding_findFirstResponderBeneathView(self),
                viewAreaHeight: visibleSpace))
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0 * NSEC_PER_SEC)), dispatch_get_main_queue()) {[weak self] () -> Void in
            self?.setContentOffset(idealOffset, animated: true)
        }
    }
    
  //Helper
    func TPKeyboardAvoiding_findFirstResponderBeneathView(view:UIView) -> UIView?
    {
        for childView in view.subviews
        {
            if childView.respondsToSelector(#selector(isFirstResponder)) && childView.isFirstResponder()
            {
                return childView
            }
            let result = TPKeyboardAvoiding_findFirstResponderBeneathView(childView)
            if result != nil
            {
                return result
            }
        }
        return nil
    }
    
    func TPKeyboardAvoiding_updateContentInset()
    {
        let state = self.keyboardAvoidingState()
        if state.keyboardVisible
        {
            self.contentInset = self.TPKeyboardAvoiding_contentInsetForKeyboard()
        }
    }
    
    func TPKeyboardAvoiding_calculatedContentSizeFromSubviewFrames() ->CGSize
    {
        let wasShowingVerticalScrollIndicator = self.showsVerticalScrollIndicator
        let wasShowingHorizontalScrollIndicator = self.showsHorizontalScrollIndicator
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        var rect = CGRectZero
        
        for view in self.subviews
        {
            rect = CGRectUnion(rect, view.frame)
        }
        
        rect.size.height += kCalculatedContentPadding
        self.showsVerticalScrollIndicator = wasShowingVerticalScrollIndicator
        self.showsHorizontalScrollIndicator = wasShowingHorizontalScrollIndicator
        
        return rect.size
    }
    
    func TPKeyboardAvoiding_idealOffsetForView(view:UIView?,viewAreaHeight:CGFloat) -> CGFloat
    {
        let contentSize = self.contentSize
        
        var offset:CGFloat = 0.0
        let subviewRect =  view != nil ? view!.convertRect(view!.bounds, toView: self) : CGRectZero
        
        var padding = (viewAreaHeight - CGRectGetHeight(subviewRect))/2
        if padding < kMinimumScrollOffsetPadding
        {
            padding = kMinimumScrollOffsetPadding
        }
        
        offset = subviewRect.origin.y - padding - self.contentInset.top
        
        if offset > (contentSize.height - viewAreaHeight)
        {
            offset = contentSize.height - viewAreaHeight
        }
        
        if offset < -self.contentInset.top
        {
            offset = -self.contentInset.top
        }
        
        return offset
    }
    
    func TPKeyboardAvoiding_contentInsetForKeyboard() -> UIEdgeInsets
    {
        let state = self.keyboardAvoidingState()
        var newInset = self.contentInset;
        
        let keyboardRect = state.keyboardRect
        newInset.bottom = keyboardRect.size.height - max(CGRectGetMaxY(keyboardRect) - CGRectGetMaxY(self.bounds), 0)
        
        return newInset
        
    }
    
    func TPKeyboardAvoiding_viewIsValidKeyViewCandidate(view:UIView)->Bool
    {
        if view.hidden || !view.userInteractionEnabled {return false}
        
        if view is UITextField
        {
            if (view as! UITextField).enabled {return true}
        }
        
        if view is UITextView
        {
            if (view as! UITextView).editable {return true}
        }
        
        return false
    }
    
    func TPKeyboardAvoiding_findNextInputViewAfterView(priorView:UIView,beneathView view:UIView,inout candidateView bestCandidate: UIView?)
    {
        let priorFrame = self.convertRect(priorView.frame, toView: priorView.superview)
        let candidateFrame = bestCandidate == nil ? CGRectZero : self.convertRect(bestCandidate!.frame, toView: bestCandidate!.superview)
        
        var bestCandidateHeuristic = -sqrt(candidateFrame.origin.x*candidateFrame.origin.x + candidateFrame.origin.y*candidateFrame.origin.y) + ( Float(fabs(CGRectGetMinY(candidateFrame) - CGRectGetMinY(priorFrame)))<FLT_EPSILON ? 1e6 : 0)
        
        for childView in view.subviews
        {
            if TPKeyboardAvoiding_viewIsValidKeyViewCandidate(childView)
            {
                let frame = self.convertRect(childView.frame, toView: view)
                let heuristic = -sqrt(frame.origin.x*frame.origin.x + frame.origin.y*frame.origin.y)
                    + (Float(fabs(CGRectGetMinY(frame) - CGRectGetMinY(priorFrame))) < FLT_EPSILON ? 1e6 : 0)
                
                  if childView != priorView && (Float(fabs(CGRectGetMinY(frame) - CGRectGetMinY(priorFrame))) < FLT_EPSILON
                        && CGRectGetMinX(frame) > CGRectGetMinX(priorFrame)
                       || CGRectGetMinY(frame) > CGRectGetMinY(priorFrame))
                    && (bestCandidate == nil || heuristic > bestCandidateHeuristic)
                {
                    bestCandidate = childView
                    bestCandidateHeuristic = heuristic
                }
            }else
            {
                self.TPKeyboardAvoiding_findNextInputViewAfterView(priorView, beneathView: view, candidateView: &bestCandidate)
            }
        }
    }
    
    func TPKeyboardAvoiding_findNextInputViewAfterView(priorView:UIView,beneathView view:UIView) ->UIView?
    {
        var candidate:UIView?
        self.TPKeyboardAvoiding_findNextInputViewAfterView(priorView, beneathView: view, candidateView: &candidate)
        return candidate
    }
    
    
    func TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(obj: AnyObject)
    {
        func processWithView(view: UIView) {
            for childView in view.subviews
            {
                if childView is UITextField || childView is UITextView
                {
                    self.TPKeyboardAvoiding_initializeView(childView)
                }else
                {
                    self.TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView(childView)
                }
            }
        }
        
        if let timer = obj as? NSTimer, view = timer.userInfo as? UIView {
            processWithView(view)
        }
        else if let view = obj as? UIView {
            processWithView(view)
        }
    }

    func TPKeyboardAvoiding_initializeView(view:UIView)
    {
        if let textField = view as? UITextField,
            delegate = self as? UITextFieldDelegate
            where textField.returnKeyType == UIReturnKeyType.Default &&
                textField.delegate !== delegate
        {
            textField.delegate = delegate
            let otherView = self.TPKeyboardAvoiding_findNextInputViewAfterView(view, beneathView: self)
            textField.returnKeyType = otherView != nil ? .Next : .Done
            
        }
    }
    
    func keyboardAvoidingState()->TPKeyboardAvoidingState
    {
        var state = objc_getAssociatedObject(self, &AssociatedKeysKeyboard.DescriptiveName) as? TPKeyboardAvoidingState
        if state == nil
        {
            state = TPKeyboardAvoidingState()
            self.state = state
        }
        
        return self.state!
    }
    
}

// MARK: - Internal object observer
internal class TPKeyboardAvoidingState:NSObject
{
    var priorInset = UIEdgeInsetsZero
    var priorScrollIndicatorInsets = UIEdgeInsetsZero
    
    var keyboardVisible = false
    var keyboardRect = CGRectZero
    var priorContentSize = CGSizeZero
    
    var priorPagingEnabled = false
}

internal extension UIScrollView
{
    private struct AssociatedKeysKeyboard {
        static var DescriptiveName = "KeyBoard_DescriptiveName"
    }
    
    var state:TPKeyboardAvoidingState?{
        get{
            let optionalObject:AnyObject? = objc_getAssociatedObject(self, &AssociatedKeysKeyboard.DescriptiveName)
            if let object:AnyObject = optionalObject {
                return object as? TPKeyboardAvoidingState
            } else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeysKeyboard.DescriptiveName, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
