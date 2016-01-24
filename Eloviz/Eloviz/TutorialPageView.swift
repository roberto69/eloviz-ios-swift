//
//  TutorialPageView.swift
//  Eloviz
//
//  Created by guillaume labbe on 08/12/15.
//  Copyright © 2015 guillaume labbe. All rights reserved.
//

import UIKit

class TutorialPageView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closeTutorial(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
