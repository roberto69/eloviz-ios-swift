//
//  NavigationController.swift
//  Eloviz
//
//  Created by guillaume labbe on 11/12/15.
//  Copyright © 2015 guillaume labbe. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor(red: 24/255, green: 29/255, blue: 40/255, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func setTitleNavBar(title: String) {
        self.viewControllers.last?.navigationItem.title = title
    }
    
    func hiddenNavBar(display: Bool) {
        self.viewControllers.last?.navigationController?.navigationBarHidden = display
    }
    
    func displayTranslucentBar(display: Bool) {
        self.viewControllers.last?.navigationController?.navigationBar.translucent = false
    }
    
    func backAction(linkImage: String) {
        let image = UIImage(named: linkImage)
        let itemLeftButton = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Done, target: self, action: "back:")
        
        self.viewControllers.last?.navigationItem.leftBarButtonItem = itemLeftButton
    }
    
    private func back(sender: UIButton) {
        self.viewControllers.last?.navigationController?.popToRootViewControllerAnimated(true)
    }
}

/*-
- (void)removeLeftItem {
[self.viewControllers lastObject].navigationItem.leftBarButtonItem = nil;
}

- (void)removeRightItem {
[self.viewControllers lastObject].navigationItem.rightBarButtonItem = nil;
}
*/
