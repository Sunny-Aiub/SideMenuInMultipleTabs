//
//  CartViewController.swift
//  SideMenuInMultipleTabs
//
//  Created by Md. Mahadhi Hassan Chowdhury on 11/5/18.
//  Copyright © 2018 Md. Mahadhi Hassan Chowdhury. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, DrawerControllerDelegate {

    
    
    //DrawerControllerDelegate method
    func pushTo(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    //Declare Drawer View
    var drawerVw = DrawerView()
    var vwBG = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.backgroundColor = UIColor(named: "#42b2e5")
        } else {
            self.navigationController?.navigationBar.backgroundColor = UIColor.blue
        }
    }
    
    
    @IBAction func actShowMenu(_ sender: Any) {
        
        //Implement the drawer view object and set delecate to current view controller
        drawerVw = DrawerView(arrayControllers:DrawerArray.array, isBlurEffect:true, isHeaderInTop:true, controller:self)
        drawerVw.delegate = self
        
        drawerVw.changeGradientColor(colorTop: UIColor.groupTableViewBackground, colorBottom: UIColor.white)
        drawerVw.changeCellTextColor(txtColor: UIColor.black)
        drawerVw.changeUserNameTextColor(txtColor: UIColor.black)
        drawerVw.changeFont(font: UIFont(name:"Avenir Next", size:18)!)
        drawerVw.changeUserName(name: "Mahadhi Hassan Chowdhury")
        drawerVw.show()
        /*
         drawerVw = DrawerView(arrayControllers:DrawerArray.array, isBlurEffect:false, isHeaderInTop:true, controller:self)
         drawerVw.delegate = self
         
         drawerVw.changeProfilePic(img: #imageLiteral(resourceName: "proPicTwo.png"))
         drawerVw.changeGradientColor(colorTop: UIColor(red:0.788, green: 0.078, blue: 0.435, alpha: 1.00), colorBottom: UIColor(red:0.929, green: 0.204, blue: 0.165, alpha: 1.00))
         
         drawerVw.changeCellTextColor(txtColor: UIColor.white)
         drawerVw.changeUserNameTextColor(txtColor: UIColor.lightText)
         drawerVw.changeFont(font:UIFont(name:"Marker Felt", size:18)!)
         drawerVw.show()
         */
        /*
         //Implement the drawer view object and set delecate to current view controller
         drawerVw = DrawerView(arrayControllers:DrawerArray.array, isBlurEffect:true, isHeaderInTop:false, controller:self)
         drawerVw.delegate = self
         
         // Can change account holder name
         drawerVw.changeUserName(name: "Sowrirajan Sugumaran")
         
         // 3.show the Navigation drawer.
         drawerVw.show()
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
