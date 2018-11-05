//
//  DrawerView.swift
//  SideMenuInMultipleTabs
//
//  Created by Md. Mahadhi Hassan Chowdhury on 11/5/18.
//  Copyright © 2018 Md. Mahadhi Hassan Chowdhury. All rights reserved.
//

import UIKit

// Delegate protocolo for parsing viewcontroller to push the selected viewcontroller
protocol DrawerControllerDelegate: class {
    func pushTo(viewController : UIViewController)
}

class DrawerView: UIView, drawerProtocolNew, UITableViewDelegate, UITableViewDataSource {
    
    public let screenSize = UIScreen.main.bounds
    var backgroundView = UIView()
    var drawerView = UIView()
    
    var tblVw = UITableView()
    var arrayViewControllers = NSArray()
    
    var currentViewController = UIViewController()
    var cellTextColor:UIColor?
    var userNameTextColor:UIColor?
    var btnLogOut = UIButton()
    var vwForHeader = UIView()
    var lblunderLine = UILabel()
    var imgBg : UIImage?
    var fontNew : UIFont?
    
    fileprivate var imgProPic = UIImageView()
    fileprivate let imgBG = UIImageView()
    fileprivate var lblUserName = UILabel()
    fileprivate var gradientLayer: CAGradientLayer!
    
    weak var delegate:DrawerControllerDelegate?
    
    convenience init(arrayControllers: NSArray, isBlurEffect:Bool, isHeaderInTop:Bool, controller:UIViewController) {
        
        self.init(frame: UIScreen.main.bounds)
        self.tblVw.register(UINib.init(nibName: "DrawerCell", bundle: nil), forCellReuseIdentifier: "DrawerCell")
        self.initialise(controllers: arrayControllers, isBlurEffect: isBlurEffect, isHeaderInTop: isHeaderInTop, controller:controller)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // To change the profile picture of account
    func changeProfilePic(img:UIImage) {
        imgProPic.image = img
        imgBG.image = img
        imgBg = img
    }
    
    // To change the user name of account
    func changeUserName(name:String) {
        lblUserName.text = name
    }
    
    // To change the background color of background view
    func changeGradientColor(colorTop:UIColor, colorBottom:UIColor) {
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        self.drawerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // To change the tableview cell text color
    func changeCellTextColor(txtColor:UIColor) {
        self.cellTextColor = txtColor
        btnLogOut.setTitleColor(txtColor, for: .normal)
        lblunderLine.backgroundColor = txtColor.withAlphaComponent(0.6)
        self.tblVw.reloadData()
    }
    
    // To change the user name label text color
    func changeUserNameTextColor(txtColor:UIColor) {
        lblUserName.textColor = txtColor
    }
    
    // To change the font for table view cell label text
    func changeFont(font:UIFont) {
        fontNew = font
        self.tblVw.reloadData()
    }
    
    func initialise(controllers:NSArray, isBlurEffect:Bool, isHeaderInTop:Bool, controller:UIViewController) {
        currentViewController = controller
        currentViewController.tabBarController?.tabBar.isHidden = true
        
        backgroundView.frame = frame
        drawerView.backgroundColor =  UIColor(red: 31/255.0, green: 69/255.0, blue: 106/255.0, alpha: 1.0)//rgb(66,178,229)
        backgroundView.backgroundColor = UIColor(red: 31/255.0, green: 69/255.0, blue: 106/255.0, alpha: 1.0) //rgb(66,178,229)
        backgroundView.alpha = 0.6
        
        // Initialize the tap gesture to hide the drawer.
        let tap = UITapGestureRecognizer(target: self, action: #selector(DrawerView.actDissmiss))
        backgroundView.addGestureRecognizer(tap)
        addSubview(backgroundView)
        
        drawerView.frame = CGRect(x:0, y:0, width:screenSize.width/2+75, height:screenSize.height)
        drawerView.clipsToBounds = true
        
        // Initialize the gradient color for background view
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = drawerView.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.darkGray.cgColor]
        
        imgBG.frame = drawerView.frame
        imgBG.image = imgBg ?? #imageLiteral(resourceName: "sunny")
        
        // Initialize the blur effect upon the image view for background view
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = drawerView.bounds
        imgBG.addSubview(blurView)
        
        // Check wether need the blur effect or not
        if isBlurEffect == true {
            self.drawerView.addSubview(imgBG)
        }else{
            self.drawerView.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        // This is for adjusting the header frame to set header either top (isHeaderInTop:true) or bottom (isHeaderInTop:false)
        self.allocateLayout(controllers:controllers, isHeaderInTop: isHeaderInTop)
    }
    
    func allocateLayout(controllers:NSArray, isHeaderInTop:Bool) {
        
        if isHeaderInTop {
            vwForHeader = UIView(frame:CGRect(x:0, y:20, width:drawerView.frame.size.width, height:120))
            self.lblunderLine = UILabel(frame:CGRect(x:vwForHeader.frame.origin.x+10, y:vwForHeader.frame.size.height - 1 , width:vwForHeader.frame.size.width-20, height:1.0))
            tblVw.frame = CGRect(x:0, y:vwForHeader.frame.origin.y+vwForHeader.frame.size.height, width:screenSize.width/2+75, height:screenSize.height-100)
            
        }else{
            tblVw.frame = CGRect(x:0, y:20, width:screenSize.width/2+75, height:screenSize.height-100)
            vwForHeader = UIView(frame:CGRect(x:0, y:tblVw.frame.origin.y+tblVw.frame.size.height, width:drawerView.frame.size.width, height:screenSize.height - tblVw.frame.size.height))
            lblunderLine.frame = CGRect(x:10, y:0, width:vwForHeader.frame.size.width-20, height:1)
        }
        
        tblVw.separatorStyle = UITableViewCellSeparatorStyle.none
        arrayViewControllers = controllers
        tblVw.delegate = self
        tblVw.dataSource = self
        tblVw.backgroundColor = UIColor(red: 31/255.0, green: 69/255.0, blue: 106/255.0, alpha: 1.0) //rgb(31,69,106)
        drawerView.addSubview(tblVw)
        tblVw.reloadData()
        
        lblunderLine.backgroundColor = UIColor.groupTableViewBackground
        vwForHeader.addSubview(lblunderLine)
        
        btnLogOut = UIButton(frame:CGRect(x:20, y:14, width:vwForHeader.frame.size.width/2+30, height:25))
        btnLogOut.setTitle("LOGOUT", for: .normal)
        btnLogOut.contentHorizontalAlignment = .left
        btnLogOut.addTarget(self, action: #selector(actLogOut), for: .touchUpInside)
        btnLogOut.titleLabel?.font = fontNew ?? UIFont(name: "Euphemia UCAS", size: 16)
        btnLogOut.setTitleColor(UIColor.white, for: .normal)
        vwForHeader.addSubview(btnLogOut)
        
        imgProPic = UIImageView(frame:CGRect(x:vwForHeader.frame.size.width-70, y:btnLogOut.frame.origin.y-5, width:60, height:60))
        imgProPic.image = imgBg ?? #imageLiteral(resourceName: "sunny")
        imgProPic.layer.cornerRadius = imgProPic.frame.size.height/2
        imgProPic.layer.masksToBounds = true
        imgProPic.contentMode = .scaleAspectFit
        vwForHeader.addSubview(imgProPic)
        
        lblUserName = UILabel(frame:CGRect(x:btnLogOut.frame.origin.x, y:btnLogOut.frame.origin.y+btnLogOut.frame.size.height-5, width:btnLogOut.frame.size.width, height:25))
        lblUserName.text = "No Name"
        lblUserName.font = UIFont(name: "Euphemia UCAS", size: 12)
        lblUserName.textAlignment = .left
        lblUserName.textColor = UIColor.white
        vwForHeader.addSubview(lblUserName)
        
        vwForHeader.backgroundColor = UIColor(red: 66/255.0, green: 178/255.0, blue: 229/255.0, alpha: 1.0)  //66,178,229
        drawerView.addSubview(vwForHeader)
        addSubview(drawerView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayViewControllers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerCell") as! DrawerCell
        cell.backgroundColor = UIColor.clear
        cell.lblController?.text = arrayViewControllers[indexPath.row] as? String
        cell.lblController.textColor = UIColor.white //self.cellTextColor ??
        cell.lblController.font = fontNew ?? UIFont(name: "Euphemia UCAS", size: 18)
        
       // theImageView.image = theImageView.image!.withRenderingMode(.alwaysTemplate)
      //  theImageView.tintColor = UIColor.red
        let image = UIImage(named: (arrayViewControllers[indexPath.row] as? String)!)
        let tintableImage = image?.withRenderingMode(.alwaysTemplate)

        cell.imgController?.image = tintableImage
        cell.imgController?.tintColor = UIColor.white
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        actDissmiss()
        let storyBoard = UIStoryboard(name:"Main", bundle:nil)
        let controllerName = (storyBoard.instantiateViewController(withIdentifier: arrayViewControllers[indexPath.row] as! String))
        controllerName.hidesBottomBarWhenPushed = true
        self.delegate?.pushTo(viewController: controllerName)
    }
    
    // To dissmiss the current view controller tab bar along with navigation drawer
    @objc func actDissmiss() {
        currentViewController.tabBarController?.tabBar.isHidden = false
        self.dissmiss()
    }
    
    // Action for logout to quit the application.
    @objc func actLogOut() {
        exit(0)
    }
}
