//
//  ManageSocketIO.swift
//  Eloviz
//
//  Created by guillaume labbe on 02/01/16.
//  Copyright © 2016 guillaume labbe. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift
import SwiftyJSON

class ManageSocketIO: NSObject {
    
    var socket: SocketIOClient!
    var sender: String!
    var titleRoom: String!
    var currentRoomView: RoomPageView?
    
    func createSocket() {
        socket = SocketIOClient.init(socketURL: "https://api.eloviz.com", options: [.Log(false), .Nsp("/meeting"), .ForcePolling(true), .Secure(true)])
        sender = NSUUID().UUIDString
        self.addHandlers()
        socket.connect()
    }
    
    func addHandlers() {
        if titleRoom != nil && titleRoom != "" {
            socket.on("connect") {data, ack in
                print("connected")
                self.joinRoom(self.titleRoom, password: "")
            }
            socket.on("peerLeft") {data, ack in
                if let sender = data[0] as? String {
                    self.handlePeerLeft(sender)
                }
            }
            socket.on("remoteMessage") {data, ack in
                self.handleRemoteMessage(data)
            }
            socket.on("error") {data, ack in
                print("error on socket", data, ack)
            }
        }
    }
    
    func joinRoom(roomName: String, password: String) {
        let myJSON = [
            "roomName": roomName,
            "sender": self.sender,
            "password": password
        ]
        
        socket.emitWithAck("joinRoom", myJSON) (timeoutAfter: 0) {data in
            print("DATA : %@", data)
            let ret = data[0] as? NSDictionary
            if (ret == nil) {
                print("JoinRoom success")
            }
            else if (ret!["code"] as! Int == 404) {
                print("Stream not found")
            }
        }
        
    }
    
    func handlePeerLeft(sender: String) {
        
    }
    
    func handleRemoteMessage(data: NSArray) {
        if let message = data.firstObject,
            let roomView = currentRoomView {
            let value = JSON(message)
            let messageRemote = NSMutableDictionary()
            
            if value["event"] == "textMessage" {
                messageRemote.setValue(value["data"]["message"].description, forKey: "message")
                messageRemote.setValue(value["sender"].description, forKey: "sender")
            
                roomView.displayMessage(messageRemote)
            }
        }
    }
    
    func sendDisconnect() {
        socket.emit("disconnect")
    }
    
    func sendMessage(message: String) {
        let myJSON = [
            "event": "textMessage",
            "data": [
                "message": message
            ]
        ]
        
        print("test", myJSON)
        socket.emit("remoteMessage", myJSON)
    }
    
    func sendHello() {
        let myJSON = [
            "canDataChannel": false,
            "canFileSharing": false
        ]
        socket.emit("hello", myJSON)
    }
}
