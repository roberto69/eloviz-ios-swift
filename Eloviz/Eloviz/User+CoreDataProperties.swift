//
//  User+CoreDataProperties.swift
//  Eloviz
//
//  Created by guillaume labbe on 22/01/16.
//  Copyright © 2016 guillaume labbe. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var mail: String?
    @NSManaged var name: String?
    @NSManaged var oauth: String?
    @NSManaged var password: String?
    @NSManaged var refreshToken: String?

}
