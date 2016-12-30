//
//  ViewController.swift
//  PlayStore
//
//  Created by Vignesh on 21/12/16.
//  Copyright © 2016 TridentSolutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var descLabl: UILabel!
    @IBOutlet weak var itemsCollectionVw: UICollectionView!
    
    let sharedInstance = SharedInstance.sharedInstance
    var listOfVerticals : NSMutableArray = ["Movies", "Education", "Hospital", "ATM", "Petrol Bunk", "Restaurants", "Bar", "Coffee", "Dinner"]
    
    let collectionVwReuseIdentifier = "cell"
    var selectedIndex: Int = -1
    
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        let cutoff:CGFloat = self.calculateConstraint(self.view.frame.size.height)
        let calculatedHeight:CGFloat = (self.view.frame.size.height - (itemsCollectionVw.frame.origin.y - cutoff))
        let heightConstrant:NSLayoutConstraint = NSLayoutConstraint(item:itemsCollectionVw, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: -calculatedHeight)
        self.view.addConstraint(heightConstrant)
     
        let userDefaults = NSUserDefaults(suiteName: "group.yourappgroup.example")
        if let customCategories = userDefaults?.valueForKey("CustomCategory"){
            
            listOfVerticals = customCategories.mutableCopy() as! NSMutableArray
            itemsCollectionVw.reloadData()
        }
    }
    
    //MARK: CollectionView Delegate
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfVerticals.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionVwReuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 5
        cell.titleLabl.text = listOfVerticals[indexPath.row] as? String
        cell.heartIcon.tintColor = UIColor(red: CGFloat(144/255.0),green: CGFloat(149/255.0),blue: CGFloat(155/255.0),alpha: 1.0)

        if indexPath.row>=9 {
            cell.heartIcon.image = UIImage(named: "Movies" )!.imageWithRenderingMode(.AlwaysTemplate)
            
        }else{
             cell.heartIcon.image = UIImage(named: listOfVerticals.objectAtIndex(indexPath.row) as! String)?.imageWithRenderingMode(.AlwaysTemplate)
        }
        
        if selectedIndex == indexPath.row {
            
            cell.backgroundColor = UIColor(red: CGFloat(233/255.0),green: CGFloat(150/255.0),blue: CGFloat(80/255.0),alpha: 1.0)
            cell.heartIcon.tintColor = UIColor.whiteColor()
            cell.titleLabl.textColor = UIColor.whiteColor()

        }else{
            
            cell.backgroundColor = UIColor(red: CGFloat(249/255.0),green: CGFloat(249/255.0),blue: CGFloat(249/255.0),alpha: 1.0)
            cell.heartIcon.tintColor = UIColor(red: CGFloat(144/255.0),green: CGFloat(149/255.0),blue: CGFloat(155/255.0),alpha: 1.0)
            cell.titleLabl.textColor =  UIColor(red: CGFloat(144/255.0),green: CGFloat(149/255.0),blue: CGFloat(155/255.0),alpha: 1.0)
        }
        

        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
        let cell = itemsCollectionVw.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor(red: CGFloat(233/255.0),green: CGFloat(150/255.0),blue: CGFloat(80/255.0),alpha: 1.0)
        cell.heartIcon.tintColor = UIColor.whiteColor()
        cell.titleLabl.textColor = UIColor.whiteColor()
    
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: {
            cell.heartIcon.transform = CGAffineTransformMakeScale(1.5, 1.5)
                    }) { (Bool) in
                
                                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: {
                                    cell.heartIcon.transform = CGAffineTransformMakeScale(1.0, 1.0)
                                        }) { (Bool) in
                    
                                        }
                        }
      
        sharedInstance.selectedEvent(listOfVerticals[indexPath.row] as! NSString)
        selectedIndex = indexPath.row

    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
       
        if itemsCollectionVw.cellForItemAtIndexPath(indexPath) != nil {
            let cell = itemsCollectionVw.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
            cell.backgroundColor = UIColor(red: CGFloat(249/255.0),green: CGFloat(249/255.0),blue: CGFloat(249/255.0),alpha: 1.0)
            cell.heartIcon.tintColor = UIColor(red: CGFloat(144/255.0),green: CGFloat(149/255.0),blue: CGFloat(155/255.0),alpha: 1.0)
            cell.titleLabl.textColor =  UIColor(red: CGFloat(144/255.0),green: CGFloat(149/255.0),blue: CGFloat(155/255.0),alpha: 1.0)
            
        }else{
            print("Nil Value")
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake((self.view.frame.size.width)/3 - 10, (self.view.frame.size.width)/3 + 30)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 7, 0, 7)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 2.0
    }
    
    @IBAction func continueBtnTapped(sender: AnyObject) {
        
        if sharedInstance.selectedEvent.length>1 {
            let verticalsVC:VerticalsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("VerticalsController") as! VerticalsViewController
            sharedInstance.isFromIndexing = false
            self.navigationController?.pushViewController(verticalsVC, animated:false)
        }else{
            print("Please Select an Event")
            let alert=UIAlertController(title: "LocalSearch", message: "Please select an Event to proceed", preferredStyle: .Alert);
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil));
            self.presentViewController(alert, animated: true, completion: {
                
            })

        }
    }
    
    @IBAction func addCategory(sender: AnyObject) {
        
        let alertControler = UIAlertController(title: "LocalSearch", message: "Not on list? Enter the name of your category", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: {
            alert -> Void in
            
        })
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            let firstTextField = alertControler.textFields![0] as UITextField
            if firstTextField.text != nil{
                
                self.listOfVerticals.addObject(firstTextField.text!)
                self.selectedIndex = self.listOfVerticals.count-1
                self.itemsCollectionVw.reloadData()

                dispatch_async(dispatch_get_main_queue(), {
                    let indexPath = NSIndexPath(forRow: self.listOfVerticals.count-1, inSection: 0)
                    self.itemsCollectionVw.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
                    self.sharedInstance.selectedEvent(self.listOfVerticals[self.selectedIndex] as! NSString)
                })

                
                let userDefaults = NSUserDefaults(suiteName: "group.yourappgroup.example")
                userDefaults!.setValue(self.listOfVerticals, forKey: "CustomCategory")
                userDefaults!.synchronize()
            }
            
        })
        
        alertControler.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Eg: Gym, Play School"
        }
        
        alertControler.addAction(cancelAction)
        alertControler.addAction(saveAction)
        
        self.presentViewController(alertControler, animated: true, completion: nil)
    }
    
    func calculateConstraint(height:CGFloat) ->  CGFloat{
        
        var cutOff:CGFloat = 0
        
        if height==568 {
            cutOff = 20
        }else if height==480{
            cutOff = 128
        }else if height == 736{
            cutOff = -130
        }else{
            cutOff = -70
        }
        
        return cutOff
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //sharedInstance.isFromIndexing = false
        //selectedIndex = 0
        //itemsCollectionVw.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

