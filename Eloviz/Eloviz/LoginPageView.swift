//
//  LoginPageView.swift
//  Eloviz
//
//  Created by guillaume labbe on 05/12/15.
//  Copyright © 2015 guillaume labbe. All rights reserved.
//

import UIKit
import MessageUI

class LoginPageView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var accountViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmPasswordView: UIView!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var lostPassword: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    var newAccount: Bool!
    var listComponents: NSMutableArray = []
    
    init() {
        super.init(nibName: "LoginPageView", bundle: NSBundle.mainBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor(red: 24/255, green: 29/255, blue: 40/255, alpha: 1.0)
        navigationItem.title = "Paramètres"
        
        let image = UIImage(named: "logo")
        let itemLeftButton = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Done, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = itemLeftButton
        
        newAccount = false
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        logInButton.layer.borderColor = UIColor.whiteColor().CGColor
        logInButton.layer.borderWidth = 1
        logInButton.layer.cornerRadius = 5
        signInButton.layer.cornerRadius = 5
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = User.MR_findFirst()
        
        if listComponents.count == 0 {
            if user != nil {
                listComponents.addObject("Mon compte")
                self.accountViewHeightConstraint.constant = 1
            } else {
                accountViewHeightConstraint.constant = 260
            }
        }
        
        listComponents.addObject("A propos")
        listComponents.addObject("Contact")
        listComponents.addObject("FAQ")
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        listComponents.removeAllObjects()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func back(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func signIn(sender: UIButton) {
        if !newAccount {
            lostPassword.hidden = true
            confirmPasswordView.hidden = false
            signInButton.setTitle("Annuler", forState: UIControlState.Normal)
            newAccount = true
        } else {
            lostPassword.hidden = false
            confirmPasswordView.hidden = true
            signInButton.setTitle("S'enregistrer", forState: UIControlState.Normal)
            newAccount = false
        }
        
        UIView.animateWithDuration(1, animations: {
            self.confirmPasswordView.alpha = 1
        })
    }
    
    @IBAction func logIn(sender: UIButton) {
        let name = accountNameTextField.text
        let password = passwordTextField.text
        let mail = mailTextField.text
        
        if (newAccount == true) {
            if let _name = name,
                let _password = password,
                let _mail = mail {
                    if (_name == "" || _password == "" || _mail == "") {
                        displayAlertView("Erreur paramètres", message: "Manque de données")
                    } else {
                        APIRequest().createUser(_name, password: _password, mail: _mail, userPage: self)
                    }
            }
        } else {
            let user = User.MR_findFirst()
            
            if (user != nil) {
                if let userName = user.name,
                    let userPassword = user.password {
                        if userName != name || userPassword != password {
                            displayAlertView("Mauvais paramètres", message: "Le mot de passe ou le nom du compte est incorrect")
                        }
                }
            } else {
                displayAlertView("Compte inexistant", message: "Créer un compte pour pouvoir vous enregistrer")
            }
        }
        
        confirmPasswordTextField.resignFirstResponder()
        mailTextField.resignFirstResponder()
        accountNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func refresh(success: Bool) {
        if (success) {
            self.accountViewHeightConstraint.constant = 1
            listComponents.removeAllObjects()
            listComponents.addObject("Mon compte")
            listComponents.addObject("A propos")
            listComponents.addObject("Contact")
            listComponents.addObject("FAQ")
            
            tableView.reloadData()
        } else {
            displayAlertView("Erreur connexion", message: "Compte déjà existant")
        }
    }
    
    @IBAction func forgotPassword(sender: UIButton) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.text = listComponents.objectAtIndex(indexPath.row) as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = listComponents.objectAtIndex(indexPath.row) as? String
        
        if cell == "Mon compte" {
            navigationController?.pushViewController(AccountFileViewController(), animated: true)
        } else if cell == "Contact" {
            createMail()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listComponents.count
    }
    
    func displayAlertView(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelButton = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.Destructive, handler: nil)
        alert.addAction(cancelButton)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func createMail() {
        let mail = MFMailComposeViewController()
        
        mail.mailComposeDelegate = self
        mail.setSubject("Contact Eloviz")
        mail.setMessageBody("test", isHTML: false)
        mail.setToRecipients(["guillaume.lab@live.fr"])
    
        presentViewController(mail, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result {
        case MFMailComposeResultCancelled:
            break
        case MFMailComposeResultFailed:
            break
        case MFMailComposeResultSaved:
            break
        case MFMailComposeResultSent:
            break
        default:
            break
        }
    }
}
