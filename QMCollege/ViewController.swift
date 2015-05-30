//
//  ViewController.swift
//  QMCollege
//
//  Created by QiMENG on 15/5/27.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet weak var leftTable: UITableView!
    
    @IBOutlet weak var rightTable: UITableView!
    
    var leftArray:Array<Model> = []
    
    var rightArray:Array<Model> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.leftTable.tableFooterView = UIView()
        self.rightTable.tableFooterView = UIView()
        
        
        SVProgressHUD.showWithStatus("正在加载", maskType: SVProgressHUDMaskType.Black)
        
        Service.cityList { (array, error) -> Void in
            
            self.leftArray = array as! Array<Model>
            
            self.leftTable.reloadData()
            SVProgressHUD.dismiss()
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.leftTable) {
            return self.leftArray.count
        }
        else {
            return self.rightArray.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == self.leftTable {
            let cell = tableView.dequeueReusableCellWithIdentifier("LeftCell", forIndexPath: indexPath) as! UITableViewCell
            
            let m:Model = self.leftArray[indexPath.row]
            
//            cell.textLabel?.highlightedTextColor = UIColor.whiteColor()
            cell.textLabel?.text = m.title
            
            
            return cell;
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("RightCell", forIndexPath: indexPath) as! UITableViewCell
            
            
            let m:Model = self.rightArray[indexPath.row]
            
            cell.textLabel?.text = m.title
            
            
            return cell;
            
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == self.leftTable {
            
            let m:Model = self.leftArray[indexPath.row]
            
            SVProgressHUD.showWithStatus("正在加载", maskType: SVProgressHUDMaskType.Black)
            Service.collegeListFromCity(m.infoUrlString, withBlock: { (array, error) -> Void in
                
                self.rightArray = array as! Array<Model>
                
                self.rightTable.reloadData()

                if self.rightArray.count > 0 {
                    
                    self.rightTable.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                }
                
                
                SVProgressHUD.dismiss()
                
            })

            
        }else {
            
            let m:Model = self.rightArray[indexPath.row]
            
            self.performSegueWithIdentifier("DetailViewController", sender: m)
            
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "DetailViewController" {
            
            var ctrl = segue.destinationViewController as! DetailViewController
            
            ctrl.model = sender as? Model
            
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

