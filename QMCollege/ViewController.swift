//
//  ViewController.swift
//  QMCollege
//
//  Created by QiMENG on 15/5/27.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        

        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        SVProgressHUD.showWithStatus("正在加载", maskType: SVProgressHUDMaskType.Black)
        
//        Service.cityList { (array, error) -> Void in
//
//            SVProgressHUD.dismiss()
//        }
        
        
//        Service.collegeListFromCity("nba.asp?id=2", withBlock: { (array, error) -> Void in
//            
//            SVProgressHUD.dismiss()
//            
//        })
        
        Service.infoCollege("wba.asp?id=1233", withBlock: { (model, error) -> Void in
            
            SVProgressHUD.dismiss()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

