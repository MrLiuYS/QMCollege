//
//  DetailViewController.swift
//  QMCollege
//
//  Created by QiMENG on 15/5/30.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var model:Model?
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var introLabel: UILabel!
    
    @IBOutlet weak var infoText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        SVProgressHUD.showWithStatus("正在加载", maskType: SVProgressHUDMaskType.Black)
        
        Service.infoCollege(self.model?.infoUrlString, withBlock: { (collegeModel, error) -> Void in
            
            self.introLabel.text = collegeModel.intro;
            
            self.infoText.text = collegeModel.info;
            
            self.logoImageView.sd_setImageWithURL(NSURL(string: collegeModel.logo), placeholderImage: nil)
            
            SVProgressHUD.dismiss()
            
        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
