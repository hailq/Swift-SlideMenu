//
//  RootSideMenuViewController.swift
//  SwiftSideMenu
//
//  Created by Hai Luong Quang on 11/21/14.
//  Copyright (c) 2014 Hai Luong Quang. All rights reserved.
//

import UIKit

class RootSideMenuViewController: UIViewController, UIGestureRecognizerDelegate {

    // Constant for configuration
    fileprivate let kAnimateMenuDuration = 0.2
    fileprivate let kAlphaMask: CGFloat = 0.5
    fileprivate let kStausBarHeight: CGFloat = 20.0
    fileprivate let kTouchNavArea: CGFloat = 50.0
    fileprivate var kTouchNavThreshold: CGFloat = 0.0   // Define it corresponding to the root view
    fileprivate var kNavMenuSpace: CGFloat = 0.0     // Define it corresponding to the root view
    
    var menuTableViewController: MenuTableViewController?
    var mainViewController: MainViewController?
    var maskOpaqueView: UIView?
    var isLeftMenuShown: Bool = false
    var startPoint: CGPoint = CGPoint() // Starting point for handling gesture recognizer
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Setup constant value for naving side menu
        let viewSize = UIScreen.main.applicationFrame.size
        self.kNavMenuSpace = viewSize.width / 4 * 3
        self.kTouchNavThreshold = self.kNavMenuSpace / 2
        
        // Setup opaque view to cover main view when menu is opening
        let maskFrame: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        self.maskOpaqueView = UIView(frame: maskFrame)
        self.maskOpaqueView?.backgroundColor = UIColor(white: 0.0, alpha: kAlphaMask)
        self.maskOpaqueView?.isUserInteractionEnabled = false
        
        // Setup controller hierachy
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        self.menuTableViewController = storyBoard.instantiateViewController(withIdentifier: "SBMenuTableViewControlleIdentifier") as? MenuTableViewController
        
        self.mainViewController = storyBoard.instantiateViewController(withIdentifier: "SBMainViewControllerIdentifier") as? MainViewController

        self._displayChildController(self.menuTableViewController!)    // Adding menu table as lowest layer
        self._displayChildController(self.mainViewController!)        // Adding main view as the upper layer

        // Setup gesture recognizer for showing side menu
        let panMenuGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(RootSideMenuViewController.handleLeftPanMenuGesture(_:)))
        panMenuGesture.delegate = self
        self.mainViewController?.view.addGestureRecognizer(panMenuGesture)


        // Setup the first content controller
        let firstContentController = storyBoard.instantiateViewController(withIdentifier: "SBFirstContentIdentifier") 
        self.changeContentController(firstContentController)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func _displayChildController(_ child: UIViewController) {
        self.addChildViewController(child)
        
        // Setup new frame with space for status bar
        let statusBar = (UIApplication.shared.isStatusBarHidden) ? 0.0 : kStausBarHeight
        
        let size = self.view.frame.size
        let childFrame = CGRect(x: 0.0, y: statusBar, width: size.width, height: size.height)
        child.view.frame = childFrame
        
        self.view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    // MARK: - Controll side menu display actions
    func handleLeftPanMenuGesture(_ recoginzer: UIPanGestureRecognizer) {
        
        let mainView = self.mainViewController!.view

        // Get starting point
        if recoginzer.state == UIGestureRecognizerState.began {
            self.startPoint = recoginzer.location(in: mainView)
            
            // Display an opaque mask to cover main view
            if (self.maskOpaqueView != nil) {
                mainView?.addSubview(self.maskOpaqueView!)
            }
        }

        let currentPoint = recoginzer.location(in: mainView)
        
        let oldFrame = mainView?.frame
        let xDev = currentPoint.x - self.startPoint.x
        let newX = (((oldFrame?.origin.x)! + xDev) > 0) ? ((oldFrame?.origin.x)! + xDev) : 0    // Do not allow the view reach beyond the left edge
        let newFrame = CGRect(x: newX, y: (oldFrame?.origin.y)!, width: (oldFrame?.size.width)!, height: (oldFrame?.size.height)!)
        
        mainView?.frame = newFrame
        
        // Setting opaque layer alpha while moving the menu view
        self.maskOpaqueView?.alpha = (newX / self.kNavMenuSpace) * kAlphaMask
        
        
        // Determine to open or close menu in the end state
        // by the threshold location
        if recoginzer.state == UIGestureRecognizerState.cancelled || recoginzer.state == UIGestureRecognizerState.ended {
            let endPoint = self.mainViewController!.view.frame.origin
            if (endPoint.x >= self.kTouchNavThreshold) {
                
                // Open the menu
                self.openLeftMenu()
            } else {
                
                //Close the menu
                self.closeLeftMenu()
            }
        }
        
    }
    
    func openLeftMenu() {
        
        let mainView = self.mainViewController!.view
        
        // Animate opening menu
        UIView.animate(withDuration: kAnimateMenuDuration, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in

            let oldFrame = mainView?.frame
            
            let newFrame = CGRect(x: self.kNavMenuSpace, y: (oldFrame?.origin.y)!, width: (oldFrame?.size.width)!, height: (oldFrame?.size.height)!)
            
            // Apply new frame on main view to show menu view
            mainView?.frame = newFrame;
            
            // Display an opaque mask to cover main view
            if (self.maskOpaqueView != nil) {
                self.maskOpaqueView!.alpha = self.kAlphaMask
                mainView?.addSubview(self.maskOpaqueView!)
            }
            
        }) { (Bool) -> Void in
            
            self.isLeftMenuShown = true    // Change toggle variable
        }
    }
    
    func closeLeftMenu() {
        
        let mainView = self.mainViewController!.view
        
        // Animate close menu
        UIView.animate(withDuration: kAnimateMenuDuration, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            
            let oldFrame = mainView?.frame
            let newFrame = CGRect(x: 0.0, y: (oldFrame?.origin.y)!, width: (oldFrame?.size.width)!, height: (oldFrame?.size.height)!)
            
            // Apply new frame on main view to show menu view
            mainView?.frame = newFrame;
            
            // Hide the opaque mask on main view
            if (self.maskOpaqueView != nil) {
                self.maskOpaqueView!.alpha = 0
                self.maskOpaqueView!.removeFromSuperview()
            }
            
        }) { (Bool) -> Void in
            self.isLeftMenuShown = false    // Change toggle variable
            
        }
    }
    
    func toggleLeftMenu() {
        if (self.isLeftMenuShown) {
            self.closeLeftMenu()
        } else {
            self.openLeftMenu()
        }
    }
    
    // MARK: - Content action methods
    func changeContentController(_ contentController: UIViewController) {
        
        // Close side bar
        if self.isLeftMenuShown {
            self.closeLeftMenu()
        }
        
        let mainViewController = self.mainViewController!
        var currentContentController = mainViewController.currentContentController
        
        // Remove current view controller
        if (currentContentController != nil) {
            currentContentController!.willMove(toParentViewController: nil)
            currentContentController!.view.removeFromSuperview()
            currentContentController!.removeFromParentViewController()
            currentContentController = nil
        }
        
        mainViewController.currentContentController = contentController    // Setup current child controller to the new one
        
        // Add new child controller
        mainViewController.addChildViewController(contentController)
        contentController.view.frame = mainViewController.contentView.frame
        mainViewController.view.addSubview(contentController.view)
        contentController.didMove(toParentViewController: mainViewController)
        
        // Change main view header title
        mainViewController.setHeaderTitle(contentController.title)

    }
    
    // MARK:- Implement the UIGestureDelegate methods
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        // Disable if touch is out side of main current content view
        // or out of defined nav area
        let contentView = self.mainViewController?.currentContentController?.view
        let xLocation = touch.location(in: contentView).x
        
        if (contentView == nil
            || touch.view != contentView
            || (xLocation > kTouchNavArea || xLocation < 0)) {
            return false
        }
        
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
