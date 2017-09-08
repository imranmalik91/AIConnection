//
//  AIConnection.swift
//  AIConnection ## Apra Imran Internet connection class ##
//
//  Created by Imran Malik on 8/29/17.
//  Copyright © 2017 Imran Malik. All rights reserved.
//

import UIKit
import  SystemConfiguration


class AIConnection: UIViewController {
    
    //Internet available status for check
    enum status {
        case connected , disconnected
    }
    
    
    var labelMessage: UILabel = {
        let label = UILabel()
        label.text = "Connection lost! Please check your internet settings."
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    
    static let sharedInstance : AIConnection = {
        let instance = AIConnection()
        return instance
    }()
    
    
    var timer:Timer?
    
    
    
    
    
    
    
    
    //life cycle begins from here
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    //initial setups for view
    func viewSetup(){
        view.backgroundColor = .clear
        view.isOpaque = false
        view.addSubview(blurView)
        
        view.addSubview(labelMessage)
        labelMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        labelMessage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        labelMessage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        labelMessage.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
   
    func startEngine(){
        validateTimer(internetStatus: .connected)
    }
    
    
    
    
    func validateTimer(internetStatus:status){
        // check if previous timer was successfully invalidated
        if timer != nil {
            timer?.invalidate()
        }
        
        if internetStatus == .connected {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(internetConnected), userInfo: nil, repeats: true)
        }else if internetStatus == .disconnected {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(internetDisconnected), userInfo: nil, repeats: true)
        }
    }
    
    
    
    
    
    //this will continuously checks if internet connection breaks and presents our no internet connection view
    func internetConnected(){
        if !isInternetAvailable() {
            timer?.invalidate()
            validateTimer(internetStatus: .disconnected)
            UIApplication.topViewController { (controller) in
                DispatchQueue.main.async(execute: {
                    self.modalPresentationStyle = .overCurrentContext
                    controller.present(self, animated: true, completion: nil)
                })
            }
        }
    }
    
    
    //this will continuosly checks if our internet connection is stablished again and dismiss the no internet connection view
     func internetDisconnected(){
        if isInternetAvailable() {
            timer?.invalidate()
            validateTimer(internetStatus: .connected)
            UIView.animate(withDuration: 0.5, animations: {
            }, completion: { (success) in
                UIView.animate(withDuration: 1, animations: {
                }, completion: { (success) in
                    self.dismiss(animated: true, completion: nil)
                })
            })
        }
    }
    
    
}



extension NSObject {
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}


extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController , completion: @escaping (_ control: UIViewController) -> Void) {
        if let navigationController = controller as? UINavigationController {
            //completion(topViewController(controller: navigationController.visibleViewController))
            completion(navigationController.visibleViewController!)
            
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                //return topViewController(controller: selected)
                completion(selected)
            }
        }
        if let presented = controller?.presentedViewController {
            //return topViewController(controller: presented)
            completion(presented)
        }
        //return controller
    }
}
