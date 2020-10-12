//
//  ViewController.swift
//  FBMessanger
//
//  Created by Piyush Sharma on 07/10/20.
//

import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
          let key = "v\(index)"
            print(index)
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


class FriendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var cellID = "cellID"
    
    var messages: [Message]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recent"
//        collectionView.reloadData()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellID)
  
        setupData()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? MessageCell else {fatalError("Unable to load cell")}
        
        if let message = messages?[indexPath.row] {
            cell.message = message
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let controller = ChatLogController(collectionViewLayout: layout)
        controller.friend = messages?[indexPath.item].friend
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

class MessageCell: BaseCell {
   
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1) : UIColor.white
            nameLabel.textColor = isHighlighted ? .white : .black
            timeLabel.textColor = isHighlighted ? .white : .black
            messageLabel.textColor = isHighlighted ? .white : .black

        }
    }
    
    var message: Message? {
        didSet{
            nameLabel.text = message?.friend?.name
            messageLabel.text = message?.text
            if let profileImage = message?.friend?.profileImageName {
                
            profileImageView.image = UIImage(named: profileImage)
                hasReadImageView.image =  UIImage(named: profileImage)
            }
          
            if let date = message?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                
                let elapsedTimeInSconds = NSDate().timeIntervalSince(date)
                let secondInDays: TimeInterval = 60 * 60 * 24
                if elapsedTimeInSconds > 7 * secondInDays {
                    dateFormatter.dateFormat = "MM/DD/YY"
                }  else if elapsedTimeInSconds > secondInDays {
                    dateFormatter.dateFormat = "EEE"
                }
                
                timeLabel.text = dateFormatter.string(from: date as Date)
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 34
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.95)
        return view
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
         return label
     }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
         return label
     }()
    
    let hasReadImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 10
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
   override func setupView() {

    addSubview(profileImageView)
    addSubview(dividerLineView)

    setupContainerView()
    
    addConstraintsWithFormat(format: "H:|-12-[v0(68)]|", views: profileImageView)
    addConstraintsWithFormat(format: "V:[v0(68)]", views: profileImageView)
    
    addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    
    addConstraintsWithFormat(format: "H:|-82-[v0]|", views: dividerLineView)
    addConstraintsWithFormat(format: "V:[v0(1)]|", views: dividerLineView)
    
    
   }
    
    private func setupContainerView() {
        let containerView = UIView()
        addSubview(containerView)
        
        addConstraintsWithFormat(format: "H:|-90-[v0]-10-|", views: containerView)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: containerView)

        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))

        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImageView)
        containerView.addConstraintsWithFormat(format: "H:|-8-[v0][v1(80)]|", views: nameLabel, timeLabel)
        containerView.addConstraintsWithFormat(format: "V:|[v0]-1-[v1(24)]|", views: nameLabel, messageLabel)
        
        containerView.addConstraintsWithFormat(format: "H:|-8-[v0]-8-[v1(20)]-12-|", views: messageLabel, hasReadImageView)
        containerView.addConstraintsWithFormat(format: "V:|[v0(20)]", views: timeLabel)
        containerView.addConstraintsWithFormat(format: "V:[v0(20)]|", views: hasReadImageView)
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    func setupView() {
//         backgroundColor = .blue
     }
}
