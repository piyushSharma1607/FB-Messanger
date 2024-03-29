//
//  Message+CoreDataProperties.swift
//  FBMessanger
//
//  Created by Piyush Sharma on 11/10/20.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: Date?
    @NSManaged public var text: String?
    @NSManaged public var isSender: Bool
    @NSManaged public var friend: Friend?

}

extension Message : Identifiable {

}
