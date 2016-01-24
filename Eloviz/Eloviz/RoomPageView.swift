//
//  RoomPageView.swift
//  Eloviz
//
//  Created by guillaume labbe on 06/12/15.
//  Copyright © 2015 guillaume labbe. All rights reserved.
//

import UIKit
import Foundation
import Socket_IO_Client_Swift
import MessageUI

class RoomPageView: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var messageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var roomViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chatRoomView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageChatTextField: UITextField!
    @IBOutlet weak var enterMessageView: UIView!
    @IBOutlet weak var chatMessageView: UIView!
    @IBOutlet weak var tapGestureView: UIView!
    @IBOutlet weak var visioView: UIView!
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var titleRoomLabel: UILabel!
    
    @IBOutlet weak var buttonToolsView: UIView!
    @IBOutlet weak var toolsView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var chatButtonView: UIView!
    
    var timer: NSTimer!
    var titleRoom: String!
    var user: User?
    
    var positionMessage: CGFloat!
    var socketIO: ManageSocketIO!
    
    var oldOriginNavBarPosition: CGFloat!
    var newOriginNavBarPosition: CGFloat!
    
    init() {
        super.init(nibName: "RoomPageView", bundle: NSBundle.mainBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oldOriginNavBarPosition = navBarView.frame.origin.y
        newOriginNavBarPosition = navBarView.frame.origin.y - 300
        
        // display only visio room
        roomViewHeightConstraint.constant = self.view.frame.size.height
        messageViewHeightConstraint.constant = 0
        
        buttonToolsView.layer.cornerRadius = 4
        
        chatButtonView.layer.cornerRadius = chatButtonView.frame.size.width / 2
        chatButtonView.clipsToBounds = true
        
        positionMessage = 0
        
        cameraView.layer.cornerRadius = 4
        cameraView.layer.borderColor = UIColor.whiteColor().CGColor
        cameraView.layer.borderWidth = 3
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: "tapGestureDisplayViews")
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("noDisplayViews"), userInfo: nil, repeats: false)
        tapGestureView.addGestureRecognizer(tapGesture)
        
        titleRoomLabel.text = titleRoom
        
        socketIO = ManageSocketIO()
        socketIO.titleRoom = titleRoom
        socketIO.currentRoomView = self
        socketIO.createSocket()
        
        user = User.MR_findFirst()
        
        let tapGestureCloseKeyBoard = UITapGestureRecognizer()
        tapGestureCloseKeyBoard.addTarget(self, action: "closeKeyBoardOnTouch")
        chatMessageView.addGestureRecognizer(tapGestureCloseKeyBoard)
    }
    
    func closeKeyBoardOnTouch() {
        messageChatTextField.resignFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHidden:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.contentSize = chatMessageView.bounds.size
    }
    
    func keyboardShow(notif: NSNotification) {
        if let info = notif.userInfo {
            let dico = NSDictionary(dictionary: info)
            _ = dico.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue.size.height
            
            
        }
    }
    
    func keyboardHidden(notif: NSNotification) {
        
    }
    
    func noDisplayViews() {
        UIView.animateWithDuration(0.5, animations: {
            let frame = self.navBarView.frame
            self.navBarView.frame = CGRectMake(frame.origin.x, self.newOriginNavBarPosition, frame.size.width, frame.size.height)
            
            self.toolsView.alpha = 0
            
            }, completion: { (finished) in
                self.navBarView.hidden = true
                self.toolsView.hidden = true
        })
        
        timer.invalidate()
    }
    
    func tapGestureDisplayViews() {
        if timer.fireDate.timeIntervalSinceNow > 0 {
            self.toolsView.alpha = 0
            self.navBarView.hidden = true
            self.toolsView.hidden = true
            timer.invalidate()
        } else {
            timer.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(5, target:self, selector: Selector("noDisplayViews"), userInfo: nil, repeats: false)
            
            let frame = self.navBarView.frame
            self.navBarView.frame = CGRectMake(frame.origin.x, oldOriginNavBarPosition, frame.size.width, frame.size.height)
            
            self.toolsView.alpha = 1
            self.navBarView.hidden = false
            self.toolsView.hidden = false
        }
    }
    
    @IBAction func lockRoomAction(sender: UIButton) {
        
    }
    
    @IBAction func addPeopleRoomAction(sender: UIButton) {
        if !MFMessageComposeViewController.canSendText() {
            UIAlertView.init(title: "Erreur", message: "Votre appareil ne supporte pas cette option", delegate: nil, cancelButtonTitle: "Ok").show()
        } else {
            
            var userName = "Eloviz"
            if user != nil {
                if let _user = user?.name {
                    userName = _user
                }
            }
            
            var message = userName + " vous invite à partager avec vos proches de façon instantanée. Vous pouvez nous rejoindre sur notre site web https://eloviz.com/ ou sur notre application mobile Eloviz"
            if let _roomName = titleRoom {
                message = userName + " vous invite à participer à la discussion \"" + _roomName + "\". Vous pouvez la rejoindre depuis notre site web https://eloviz.com/" + _roomName + " ou sur notre application mobile Eloviz en entrant le nom de la conversation."
            }
            
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate = self
            messageController.recipients = nil
            messageController.body = message
            presentViewController(messageController, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch (result) {
        case MessageComposeResultCancelled:
                break
        case MessageComposeResultFailed:
            UIAlertView.init(title: "Erreur", message: "Echec de l'envoi du message", delegate: nil, cancelButtonTitle: "Ok").show()
            break
        case MessageComposeResultSent:
            break
        default:
            break
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func displayMessage(data: NSDictionary) {
        let message = data.objectForKey("message") as? String
        let sender = data.objectForKey("sender") as? String
        
        if let _message = message,
            let _sender = sender {
                //view message
                let view = UIView(frame: CGRect(x: CGFloat(0), y: positionMessage, width: chatMessageView.frame.size.width, height: CGFloat(0)))
                
                // name sender
                let senderLabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(0), width: 40, height: CGFloat(20)))
                senderLabel.text = _sender
                senderLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
                view.addSubview(senderLabel)
                
                // sender message
                let messageLabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(20), width: chatMessageView.frame.size.width, height: CGFloat(30)))
                messageLabel.backgroundColor = UIColor.whiteColor()
                messageLabel.textColor = UIColor.blackColor()
                messageLabel.text = _message
                messageLabel.sizeToFit()
                messageLabel.layoutMargins = UIEdgeInsetsMake(5, 5, 5, 5)
                messageLabel.frame.size.width = messageLabel.frame.size.width + 10
                messageLabel.frame.size.height = messageLabel.frame.size.height + 10
                messageLabel.layer.cornerRadius = 15.0
                
                view.addSubview(messageLabel)
                
                view.frame.size.height = senderLabel.frame.size.height + messageLabel.frame.size.height
                
                chatMessageView.addSubview(view)
                
                positionMessage = positionMessage + 55
        }
    }
    
    @IBAction func sendMessage(sender: UIButton) {
        if let message = messageChatTextField.text {
            
            if message != "" {
                //view message
                let view = UIView(frame: CGRect(x: CGFloat(0), y: positionMessage, width: chatMessageView.frame.size.width, height: CGFloat(0)))
                
                // name sender
                let senderLabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(0), width: chatMessageView.frame.size.width, height: CGFloat(20)))
                if user != nil {
                    senderLabel.text = user?.name
                } else {
                    senderLabel.text = "invité"
                }
                senderLabel.sizeToFit()
                senderLabel.frame.origin.x = chatMessageView.frame.size.width - senderLabel.frame.size.width - 5
                senderLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
                view.addSubview(senderLabel)
                
                // sender message
                let messageLabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(20), width: chatMessageView.frame.size.width, height: CGFloat(30)))
                messageLabel.backgroundColor = UIColor.blueColor()
                messageLabel.textColor = UIColor.whiteColor()
                messageLabel.text = message
                messageLabel.sizeToFit()
                messageLabel.layoutMargins = UIEdgeInsetsMake(5, 5, 5, 5)
                messageLabel.frame.size.width = messageLabel.frame.size.width + 10
                messageLabel.frame.size.height = messageLabel.frame.size.height + 10
                messageLabel.frame.origin.x = chatMessageView.frame.size.width - messageLabel.frame.size.width - 5
                messageLabel.layer.cornerRadius = 15.0
                
                view.addSubview(messageLabel)
                
                view.frame.size.height = senderLabel.frame.size.height + messageLabel.frame.size.height
                
                chatMessageView.addSubview(view)
                positionMessage = positionMessage + 55
                
                socketIO.sendMessage(message)
            }
        }
        messageChatTextField.text = ""
    }
        
    @IBAction func muteAction(sender: UIButton) {
    }
    
    @IBAction func displayCameraAction(sender: UIButton) {
        
    }
    
    @IBAction func endingCallAction(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func displayChatAction(sender: UIButton) {
        self.navBarView.hidden = true
        self.toolsView.hidden = true
        
        UIView.animateWithDuration(1, animations: {
            if self.messageViewHeightConstraint.constant == 0 {
                self.messageViewHeightConstraint.constant = self.view.bounds.size.height / 2
                self.roomViewHeightConstraint.constant = self.view.bounds.size.height / 2
            } else {
                self.messageViewHeightConstraint.constant = 0;
                self.roomViewHeightConstraint.constant = self.view.bounds.size.height
            }
            }, completion: nil)
    }
}
