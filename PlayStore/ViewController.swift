//
//  ViewController.swift
//  PlayStore
//
//  Created by Vignesh on 21/12/16.
//  Copyright © 2016 TridentSolutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var heightConstraints: NSLayoutConstraint!
    @IBOutlet weak var descLabl: UILabel!
    @IBOutlet weak var itemsCollectionVw: UICollectionView!
    let sharedIns = SharedInstance.sharedInstance
    
    let items = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let imgCollection:NSArray = ["home-tab","notification-tab","plus-tab","settings-tab","user-tab","user-tab","user-tab","user-tab","user-tab"]
    let titleCollection:NSArray = ["Movies","Education","Hospital","ATM","Petrol Bunk","Restaurants","Bar","Coffee","Dinner"]

    let reuseIdentifier = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        var cutoff:CGFloat = 0
        if self.view.frame.size.height==568 {
            cutoff = 20
        }else if self.view.frame.size.height==480{
            cutoff = 128
        }
        
        let calculatedHeight:CGFloat = (self.view.frame.size.height - (itemsCollectionVw.frame.origin.y - cutoff))
        let heightConstrant:NSLayoutConstraint = NSLayoutConstraint(item:itemsCollectionVw, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: -calculatedHeight)
        
        self.view.addConstraint(heightConstrant)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 5
 
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.titleLabl.text = titleCollection[indexPath.row] as? String
        cell.heartIcon.image = UIImage(named: imgCollection.objectAtIndex(indexPath.row) as! String)?.imageWithRenderingMode(.AlwaysTemplate)
        cell.heartIcon.tintColor = UIColor(red: CGFloat(144/255.0),green: CGFloat(149/255.0),blue: CGFloat(155/255.0),alpha: 1.0)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake((self.view.frame.size.width)/3 - 10, (self.view.frame.size.width)/3 + 30)

    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
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
        
        sharedIns.setSelectedCategory(titleCollection[indexPath.row] as! NSString)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor(red: CGFloat(249/255.0),green: CGFloat(249/255.0),blue: CGFloat(249/255.0),alpha: 1.0)
        cell.heartIcon.tintColor = UIColor(red: CGFloat(144/255.0),green: CGFloat(149/255.0),blue: CGFloat(155/255.0),alpha: 1.0)
        cell.titleLabl.textColor =  UIColor(red: CGFloat(144/255.0),green: CGFloat(149/255.0),blue: CGFloat(155/255.0),alpha: 1.0)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 7, 0, 7)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2.0
    }
    override func viewWillLayoutSubviews() {

    }
    

    
    //**Cell ExpandAnimation
    /*
    UIView.animateWithDuration(0.3, delay: 0, options: .TransitionFlipFromBottom, animations: {
    
    //            let center = self.view.center;
    //            cell.transform = CGAffineTransformMakeScale(1.5, 1.5);
    //            cell.center = center;
    
    cell.frame = CGRectMake(5, 0, self.view.frame.size.width-10, self.itemsCollectionVw.frame.size.height-10)
    self.itemsCollectionVw.bringSubviewToFront(cell)
    
    }) { (Bool) in
    
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

