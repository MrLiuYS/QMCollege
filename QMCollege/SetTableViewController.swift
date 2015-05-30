//
//  SetTableViewController.swift
//  QMCollege
//
//  Created by QiMENG on 15/5/30.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

import UIKit

class SetTableViewController: UITableViewController,UMSocialUIDelegate {

    @IBOutlet weak var clearIADLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var temp: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(kIAPClear)
        
        if let bo: AnyObject = temp {
            self.clearIADLabel.text = "恢复购买"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 0 {
            
            UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id="+kAppID)!)
        }
        else if indexPath.section == 1 && indexPath.row == 1 {
            
            UMSocialSnsService.presentSnsIconSheetView(self,
                appKey: kUMengKey,
                shareText: "http://itunes.apple.com/us/app/id%@"+kAppID,
                shareImage: nil,
                shareToSnsNames: [UMShareToEmail,UMShareToSms,UMShareToSina,UMShareToTencent],
                delegate: self)
            
        }
        else if indexPath.section == 2 && indexPath.row == 0 {
            
            SVProgressHUD.showWithStatus("努力加载", maskType: SVProgressHUDMaskType.Black)
            
            SimplePurchase.buyProduct(kIAPClear, block: { (error) -> Void in
                
                SVProgressHUD.dismiss()
                
                if error == nil {
                    
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: kIAPClear)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    self.clearIADLabel.text = "回复购买"
                    
                }else {
                    
                    let alert = UIAlertView(title: "购买失败",
                        message: error.localizedDescription,
                        delegate: nil,
                        cancelButtonTitle: "取消")
                    
                    alert.show()
                }
                
            })
        }
        
    }
    
    
    
    
    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
