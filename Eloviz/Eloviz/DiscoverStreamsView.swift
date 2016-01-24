//
//  DiscoverStreamsView.swift
//  Eloviz
//
//  Created by guillaume labbe on 11/12/15.
//  Copyright © 2015 guillaume labbe. All rights reserved.
//

import UIKit

class DiscoverStreamsView: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIBarPositioningDelegate {

    @IBOutlet weak var collectionViewFlow: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var warningLabel: UILabel!
    
    var listStreams: NSMutableDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor(red: 24/255, green: 29/255, blue: 40/255, alpha: 1.0)
        navigationItem.title = "En ce moment"
        
        let image = UIImage(named: "logo")
        let itemLeftButton = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = itemLeftButton
        
        let itemRightAccountButton = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "goAccount:")
        let itemRightSearchButton = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "searchStream:")
        let listButton = NSArray(arrayLiteral: itemRightAccountButton, itemRightSearchButton)
        self.navigationItem.rightBarButtonItems = listButton as? [UIBarButtonItem]
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "StreamsCellView", bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: "cell")
        
        listStreams = nil
        warningLabel.text = "Chargement en cours"
        collectionView.hidden = true
        
        APIRequest().getStreams(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        setNeedsStatusBarAppearanceUpdate()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    func back(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func goAccount(sender: UIButton) {
        let loginPageVC = LoginPageView()
        self.navigationController?.pushViewController(loginPageVC, animated: true)
    }
    
    func searchStream(sender: UIButton) {
        
    }
    
    func setStreamsList(streams: NSMutableDictionary) {
        listStreams = streams
        
        if listStreams?.count > 0 {
            collectionView.hidden = false
            warningLabel.hidden = true
            collectionView.reloadData()
        } else {
            warningLabel.hidden = false
            warningLabel.text = "Aucun contenu disponible"
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = listStreams?.count {
            return count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! StreamsCellView
        let content = listStreams?.objectForKey(String(indexPath.row)) as? NSDictionary
        
        if let title = content?.objectForKey("title") as? String,
            let description = content?.objectForKey("description") as? String,
            let user = content?.objectForKey("participants") as? String {
                cell.titleLabel.text = title + " - " + user + " participant(s)"
                cell.descriptionLabel.text = description
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let content = listStreams?.objectForKey(String(indexPath.row)) as? NSDictionary
        
        if let title = content?.objectForKey("title") as? String {
                let newRoom = RoomPageView()
                newRoom.titleRoom = title
                self.presentViewController(newRoom, animated: true, completion: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}
