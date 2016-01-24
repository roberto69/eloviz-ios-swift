//
//  ViewController.swift
//  Eloviz
//
//  Created by guillaume labbe on 05/12/15.
//  Copyright © 2015 guillaume labbe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var startRoomView: UIView!
    @IBOutlet weak var streamView: UIView!
    @IBOutlet weak var nameRoomTextField: UITextField!
    @IBOutlet weak var descHomePage: UILabel!
    @IBOutlet weak var buttonAccount: UIButton!
    
    var user: User!
    var navController: NavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.layer.cornerRadius = 4
        let colorLogin = UIColor(red: 201/255, green: 29/255, blue: 29/255, alpha: 1)
        loginView.layer.borderColor = colorLogin.CGColor
        loginView.layer.borderWidth = 1
        
        streamView.layer.cornerRadius = 4
        let color = UIColor(red: 17/255, green: 195/255, blue: 20/255, alpha: 1)
        streamView.layer.borderColor = color.CGColor
        streamView.layer.borderWidth = 1
        
        startRoomView.layer.cornerRadius = 4
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: "tapCloseKeyboard")
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden = false
        user = User.MR_findFirst()
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("firstLaunch") {
            displayRoom(true)
        } else if user != nil {
            descHomePage.text = "Récupération des données utilisateurs"
            if let refreshToken = user.refreshToken {
                APIRequest().getMe(refreshToken, home: self)
            } else {
                // delete entity
            }
        } else {
            displayRoom(false)
        }
    }
    
    func tapCloseKeyboard() {
        nameRoomTextField.resignFirstResponder()
    }
    
    func displayRoom(logSucceed: Bool) {
        descHomePage.text = "Commencez une conversation"
        startRoomView.hidden = false
        streamView.hidden = false
        loginView.hidden = false
        
        if (user != nil && logSucceed == true && user.name != nil) {
            buttonAccount.setTitle(user.name, forState: UIControlState.Normal)
        } else {
            buttonAccount.setTitle("Connexion", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func startRoom(sender: UIButton) {
        let newRoom = RoomPageView()
        
        if (nameRoomTextField.text?.isEmpty == true || (nameRoomTextField.text == "")) {
            nameRoomTextField.placeholder = "need a name"
            return
        }
        
        newRoom.titleRoom = nameRoomTextField.text
        self.presentViewController(newRoom, animated: true, completion: nil)
    }
    
    @IBAction func loginPage(sender: UIButton) {
        let loginPageVC = LoginPageView()        
        navigationController?.pushViewController(loginPageVC, animated: true)
    }
    
    @IBAction func exploreStreams(sender: UIButton) {
        let streamsPageVC = DiscoverStreamsView()
        navigationController?.pushViewController(streamsPageVC, animated: true)
    }
    
    
}

