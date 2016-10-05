//
//  ViewController.swift
//  CoreDataYoutube
//
//  Created by CM on 6/7/16.
//  Copyright © 2016 CM. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    
    @IBAction func btnSave(){
//        print("save button pressed\(txtUsername.text)")
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let newUser = NSEntityDescription.insertNewObjectForEntityForName("Users", inManagedObjectContext: context) as NSManagedObject
        newUser.setValue(txtUsername.text, forKey: "username")
        newUser.setValue(txtPassword.text, forKey: "password")
        
        print(newUser)
        print("object saved")

        
        let url:NSURL = NSURL(string: "http://blablablabla/ci/api/example")!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let paramString = "data=Hello"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.downloadTaskWithRequest(request) {
            (
            let location, let response, let error) in
            
            guard let _:NSURL = location, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let urlContents = try! NSString(contentsOfURL: location!, encoding: NSUTF8StringEncoding)
            
            guard let _:NSString = urlContents else {
                print("error")
                return
            }
            
            print(urlContents)
            
        }
        
        task.resume()
        
        
    }
    
    @IBAction func btnLoad(){
//        print("load button pressed\(txtPassword.text)")
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Users")
        request.returnsObjectsAsFaults = false;
        request.predicate = NSPredicate(format: "username = %@",txtUsername.text!)
        
        do {
            let result:NSArray = try context.executeFetchRequest(request)
            
            if(result.count > 0 ){
                let res = result[0] as! NSManagedObject
                txtUsername.text = res.valueForKey("username") as? String
                txtPassword.text = res.valueForKey("password") as? String
                for res in result {
                    print(res)
                }
            }else {
                print("0 result return potential error")
            }
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

