//
//  FriendsControllerHelper.swift
//  FBMessanger
//
//  Created by Piyush Sharma on 07/10/20.
//

import UIKit
import CoreData

//class Friend: NSObject {
//    var name: String?
//    var profileImageName: String?
//}
//
//class Message: NSObject {
//    var text: String?
//    var date: NSDate?
//
//    var friend: Friend?
//}

extension FriendsController {
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        
        if let context = delegate?.persistentContainer.viewContext {
            
            do {
                
                let entityNames = ["Friend", "Message"]
                
                for entity in entityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                    let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                    for object in objects! {
                        context.delete(object)
                    }
                }
                
                
                try(context.save())
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    func setupData() {
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            //           guard let entity = NSEntityDescription.entity(forEntityName: "Friend", in: context) else { return  }
            //
            //           let mark = NSManagedObject(entity: entity, insertInto: context) as? Friend
            
            
            
            let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            
            mark.name = "Mark Zukarbarg"
            mark.profileImageName = "mark"
            
            createMessageWithText(text: "Hello, Mark this side", minituesAgo: 0, friend: mark, context: context)
            
            createMessageWithText(text: "I am the founder of FaceBook", minituesAgo: 1, friend: mark, context: context)
//            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
//            message.friend = mark
//            message.text = "Hello..!! My name is Mark Zukarbarg, nice to meet you"
//            message.date = NSDate() as Date
            
            
        
            createTimMessageswithContext(context: context)
            
                       
            let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            donald.name = "Donald Trump"
            donald.profileImageName = "trump"
            
            createMessageWithText(text: "Hello.!! My name is Donald Trump. ", minituesAgo: 0, friend: donald, context: context)
            createMessageWithText(text: "I am the President of United States", minituesAgo: 5, friend: donald, context: context, isSender: true)
            createMessageWithText(text: "Recently, I caught up with Covid-19", minituesAgo: 2, friend: donald, context: context)
            createMessageWithText(text: "I wish I could become the President again to serve the nation", minituesAgo: 7, friend: donald, context: context)
            createMessageWithText(text: "I wish I could become the President again to serve the nation", minituesAgo: 7, friend: donald, context: context, isSender: true)
            createMessageWithText(text: "Please wish for me", minituesAgo: 7, friend: donald, context: context)
            createMessageWithText(text: "The President to serve the nation", minituesAgo: 7, friend: donald, context: context, isSender: true)
            
            let gandhi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            gandhi.name = "Mahatma Gandhi"
            gandhi.profileImageName = "gandhi"
            
            createMessageWithText(text: "Love Peace and joy", minituesAgo: 60 * 24, friend: gandhi, context: context)

            createMessageWithText(text: "Gandhigiri", minituesAgo: 60 * 24, friend: gandhi, context: context)
            
            
            let hillary = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            hillary.name = "Hillary Clinton"
            hillary.profileImageName = "hillary"
            
            createMessageWithText(text: "Please Vote for me..!!", minituesAgo: 8 * 60 * 24, friend: hillary, context: context)

            createMessageWithText(text: "You did for Billy..!!", minituesAgo: 8 * 60 * 24, friend: hillary, context: context)
            
            //            let messageTim = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            //            messageTim.friend = tim
            //            messageTim.text = "Hello..!! My name is Tim Cook, nice to meet you"
            //            messageTim.date = NSDate() as Date
            
            
            
            
            
            do {
                try context.save()
                print("CONTEXT SAVED")
                
                
                
            } catch {
                print("______________________")
                
                print(error.localizedDescription)
            }
            loadData()
        }
        
    }
    
    private func createTimMessageswithContext(context: NSManagedObjectContext) {
        let tim = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
       
        tim.name = "Tim Cook"
        tim.profileImageName = "tim"
        createMessageWithText(text: "Good Morning", minituesAgo: 0, friend: tim, context: context)
        createMessageWithText(text: "Hello, How are you. Hope you are having a good day dear...!!", minituesAgo: 1, friend: tim, context: context)
        createMessageWithText(text: "I am doing good", minituesAgo: 2, friend: tim, context: context)
        createMessageWithText(text: "Are you interested in buying an apple device? We have a wide variety of apple devices that will suit your purpose and all your needs. Please make your purchase hurry..!!", minituesAgo: 3, friend: tim, context: context)
        
        createMessageWithText(text: "Yes, totally. I am looking to buy a new iPhone 12", minituesAgo: 4, friend: tim, context: context, isSender: true)
        

    }
    
    
    private func createMessageWithText(text: String,minituesAgo: Double, friend: Friend, context: NSManagedObjectContext, isSender: Bool = false) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minituesAgo * 60) as Date
        message.isSender = NSNumber(value: isSender) as! Bool
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            if let friends = fetchFriends() {
                
                messages = [Message]()
                
                for friend in friends {
//                    print(friend.name)
                    let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false )]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    
                    do{
                        let fetchMessages = try context.fetch(fetchRequest)
                        messages?.append(contentsOf: fetchMessages)
                        
                        messages?.sort {
                            guard let lhs = $0.date, let rhs = $1.date else { return false }
                            return lhs > rhs
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
    }
    private func fetchFriends() ->[Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            let request = NSFetchRequest<Friend>(entityName: "Friend")
            do {
                return try context.fetch(request)
            } catch let err {
                print(err)
            }
        }
        return nil
    }
}

