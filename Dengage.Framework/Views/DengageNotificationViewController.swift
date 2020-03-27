//
//  NotificationViewController.swift
//  carouselViewController
//
//  Created by Ekin Bulut on 10.03.2020.
//  Copyright © 2020 Ekin. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI



open class DengageNotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet weak var dengageCollectionView: UICollectionView!
    
    var bestAttemptContent: UNMutableNotificationContent?
    
    var currentIndex : Int = 0
    
    var payloads : [DengageRecievedMessage] = [DengageRecievedMessage]()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        print("viewDidLoad")
        
        
    }
    
    open func viewDidLoad(_ collectionView : UICollectionView!){
        super.viewDidLoad()
        
        self.dengageCollectionView = collectionView
        self.dengageCollectionView.delegate = self as UICollectionViewDelegate
        self.dengageCollectionView.dataSource = self as UICollectionViewDataSource
        self.dengageCollectionView.contentInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
 
    open func didReceive(_ notification: UNNotification) {
        
        self.bestAttemptContent = (notification.request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent =  bestAttemptContent {
            
            if let carouselContents = bestAttemptContent.userInfo["carouselContent"] as? [AnyObject] {
                
                for carouselContent in carouselContents
                {
                    if let contentDictionary = carouselContent as? NSDictionary {
                        let dengagePayload = DengageRecievedMessage()
                        
                        dengagePayload.image = contentDictionary["mediaUrl"] as? String
                        dengagePayload.title = contentDictionary["title"] as? String
                        dengagePayload.description = contentDictionary["desc"] as? String
                        self.payloads.append(dengagePayload)
                        
                    }

                }
                
                DispatchQueue.main.async {
                    self.dengageCollectionView.reloadData()
                }
            }
        }
    }
    
    open func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        if response.actionIdentifier == "NEXT_ACTION" {
            self.scrollNextItem()
            completion(UNNotificationContentExtensionResponseOption.doNotDismiss)
        }else if response.actionIdentifier == "PREVIOUS_ACTION" {
            self.scrollPreviousItem()
            completion(UNNotificationContentExtensionResponseOption.doNotDismiss)
        }else {
            completion(UNNotificationContentExtensionResponseOption.dismissAndForwardAction)
        }
    }
    
    //current index'i belirleyip ilgili item'a scroll ettiriyoruz. Sağdan soldan eşit bölünmesi içinde sağ ve sol content inset'lerle oynuyoruz.
    private func scrollNextItem(){
        self.currentIndex == (self.payloads.count - 1) ? (self.currentIndex = 0) : ( self.currentIndex += 1 )
        let indexPath = IndexPath(row: self.currentIndex, section: 0)
        self.dengageCollectionView.contentInset.right = (indexPath.row == 0 || indexPath.row == self.payloads.count - 1) ? 10.0 : 20.0
        self.dengageCollectionView.contentInset.left = (indexPath.row == 0 || indexPath.row == self.payloads.count - 1) ? 10.0 : 20.0
        self.dengageCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.right, animated: true)
    }
    
    private func scrollPreviousItem(){
        self.currentIndex == 0 ? (self.currentIndex = self.payloads.count - 1) : ( self.currentIndex -= 1 )
        let indexPath = IndexPath(row: self.currentIndex, section: 0)
        self.dengageCollectionView.contentInset.right = (indexPath.row == 0 || indexPath.row == self.payloads.count - 1) ? 10.0 : 20.0
        self.dengageCollectionView.contentInset.left = (indexPath.row == 0 || indexPath.row == self.payloads.count - 1) ? 10.0 : 20.0
        self.dengageCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
    }
    
}

extension DengageNotificationViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.payloads.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "CarouselNotificationCell"
        self.dengageCollectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CarouselNotificationCell
        let payloads = self.payloads[indexPath.row]
        cell.configure(imagePath: payloads.image!, title: payloads.title!, desc: payloads.description!)
        cell.layer.cornerRadius = 8.0
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.dengageCollectionView.frame.width
        let cellWidth = (indexPath.row == 0 || indexPath.row == self.payloads.count - 1) ? (width - 30) : (width - 40)
        return CGSize(width: cellWidth, height: width - 20.0)
    }
    
}

