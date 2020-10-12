//
//  ChatLogController.swift
//  FBMessanger
//
//  Created by Piyush Sharma on 09/10/20.
//

import UIKit
import UserNotifications
import CoreData

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellID = "cellID"
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
            messages = friend?.message?.allObjects as? [Message]
            
            messages?.sort {
                guard let lhs = $0.date, let rhs = $1.date else { return false }
                return lhs > rhs
            }

        }
    }
     
    var messages: [Message]?
    
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
       let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        return button
    }()
    
    
    var bottomConstraint: NSLayoutConstraint?
    
//    
//    let fetchResultsController: NSFetchedResultsController = {
//        let fetchRequest = NSFetchRequest(entityName: "Message")
//        let delegate = UIApplication.shared.delegate as? AppDelegate
//        let context = delegate?.persistentContainer.viewContext
//        
//        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        return frc
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellID)
        tabBarController?.tabBar.isHidden = true
        
        view.addSubview(messageInputContainerView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstraintsWithFormat(format: "V:[v0(48)]", views: messageInputContainerView)
        
        setupInputComponents()
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    
    @objc func handleKeyboardNotification(notification: Notification) {
        
        if let userInfo = notification.userInfo {
        
            
            if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                
                let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
                
                bottomConstraint?.constant = isKeyboardShowing ? -keyboardRectangle.height : 0
                
                UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut) {
                    self.view.layoutIfNeeded()
                } completion: { (completed) in
                    let index = NSIndexPath(item: self.messages!.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: index as IndexPath, at: .bottom, animated: true)
                }
            }
            
            
            
        }
        
        
        
    }
    private func setupInputComponents() {
        let topBorderView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            
            return view
        }()
        
        messageInputContainerView.addSubview(topBorderView)
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addConstraintsWithFormat(format: "H:|-8-[v0]-[v1(60)]|", views: inputTextField, sendButton)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: inputTextField)
        
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: sendButton)
        messageInputContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: topBorderView)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0(0.5)]", views: topBorderView)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatLogMessageCell
        cell.messageTextView.isUserInteractionEnabled = false
        cell.messageTextView.text = messages?[indexPath.item].text
        
        if let message = messages?[indexPath.item], let messageText = message.text, let profileImageName = message.friend?.profileImageName {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 18)!], context: nil)

            if !message.isSender {
                
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 8, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: 48, y: 0, width: estimatedFrame.width + 8 + 8, height: estimatedFrame.height + 20)
                cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                cell.messageTextView.textColor = .black
            } else {
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16, y: 0, width: estimatedFrame.width + 8, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8, y: 0, width: estimatedFrame.width + 8 + 8, height: estimatedFrame.height + 20)
                cell.profileImageView.isHidden = true
                
                cell.textBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                cell.messageTextView.textColor = .white
            }
            
            
            
            cell.profileImageView.image = UIImage(named: profileImageName)
        
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                if let messageText = messages?[indexPath.item].text {
                    let size = CGSize(width: 250, height: 1000)
                    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                    let estimateFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 18)!], context: nil)

            return CGSize(width: view.frame.width, height: estimateFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
}


class ChatLogMessageCell: BaseCell {
    let messageTextView: UITextView = {
    let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Sample message"
        textView.textColor = .black
        textView.backgroundColor = .clear
        return textView
    }()

    let textBubbleView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
        
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
    
        return imageView
    }()
    
    override func setupView() {
        super.setupView()
        addSubview(textBubbleView)
       addSubview(messageTextView)
        addSubview(profileImageView)
        
        
        
        
       addConstraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
       addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)

        profileImageView.backgroundColor = .red
    }
}

