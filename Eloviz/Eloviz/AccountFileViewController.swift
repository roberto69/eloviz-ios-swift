//
//  AccountFileViewController.swift
//  Eloviz
//
//  Created by guillaume labbe on 17/01/16.
//  Copyright © 2016 guillaume labbe. All rights reserved.
//

import UIKit
import MagicalRecord

class AccountFileViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMailLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        user = User.MR_findFirst()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor(red: 24/255, green: 29/255, blue: 40/255, alpha: 1.0)
        navigationItem.title = "Mon compte"
        
        let image = UIImage(named: "logo")
        let itemLeftButton = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Done, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = itemLeftButton
        /*let navController = navigationController as? NavigationController
        
        navController?.setTitleNavBar("Mon compte")*/
        
        if (user == nil) {
            logOut(UIButton())
            userNameLabel.text = "N/A"
            userNameLabel.text = "N/A"
        } else {
            userNameLabel.text = user?.name
            userMailLabel.text = user?.mail
        }
    }
    
    @IBAction func logOut(sender: UIButton) {
        user?.MR_deleteEntity()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        navigationController?.popViewControllerAnimated(true)
    }
    
    func back(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
}
