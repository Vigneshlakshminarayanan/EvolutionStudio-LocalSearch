//
//  VerticalsViewController.swift
//  PlayStore
//
//  Created by Vignesh on 22/12/16.
//  Copyright © 2016 TridentSolutions. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreSpotlight
import MobileCoreServices

class VerticalsViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate,UIScrollViewDelegate {

    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var searchResults = NSMutableArray()  //** MKLocalSearch Results Storage
    let sharedInstance = SharedInstance.sharedInstance //** Shared Instance
    
    @IBOutlet weak var pageVw: UIPageControl!
    @IBOutlet weak var mapVw: MKMapView!
    @IBOutlet weak var containerVw: UIView!
    @IBOutlet weak var titleLabl: UILabel!  //** Base Container Title Label
    @IBOutlet weak var addrsVw: UITextView! //** Base Container Address TextView
    @IBOutlet weak var phoneNumbe: UILabel! //** Base Container Phone Number Label
    @IBOutlet weak var distnaceLbl: UILabel! //** Base Container Distance Label
   
    var managedObjectContext: NSManagedObjectContext? = nil  //** CoreData ManagedObjectContext
    var _fetchedResultsController: NSFetchedResultsController? = nil //** FRC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        
        mapVw.showsUserLocation = true
        mapVw.delegate = self
        mapVw.zoomEnabled = true
        mapVw.showsTraffic = true
        mapVw.showsBuildings = true
        addrsVw.userInteractionEnabled = false
        titleLabl.adjustsFontSizeToFitWidth = true
        addrsVw.sizeToFit()
        containerVw.alpha = 0;
        
        let span = MKCoordinateSpanMake(0.075, 0.075)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: sharedInstance.currentLocationLatValue, longitude: sharedInstance.currentLocationLongValue), span: span)
        mapVw.setRegion(region, animated: true)
        
        if !sharedInstance.isFromIndexing {
            
            makeALocalSearch()
            containerVw.alpha = 0
            
        } else {
            
            let fetchRequest = NSFetchRequest(entityName: "FavouritesEntity")
            fetchRequest.predicate = NSPredicate(format: "uniqueID = %@", sharedInstance.selectedVerticalUniqueIDFromIndexing)

                do {
                    let results = try managedObjectContext!.executeFetchRequest(fetchRequest)
                    let  favts = results as! [FavouritesEntity]
                
                    for entity in favts {
                    
                    titleLabl.text = entity.title
                    addrsVw.text = entity.address
                   
                    if entity.phoneNumber != nil {
                        distnaceLbl.text = entity.phoneNumber
                    }
                        
                    let latV:Double = entity.latitude
                    let longV:Double = entity.longtitude
                    self.pointAnnotation = MKPointAnnotation()
                    self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude:latV, longitude:longV)
                    self.pointAnnotation.title = entity.title
                    self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
                    
                    self.mapVw.centerCoordinate = self.pointAnnotation.coordinate
                    self.mapVw.addAnnotation(self.pinAnnotationView.annotation!)
                    containerVw.alpha = 0.8
                    pageVw.hidden = true
                }
            } catch let error as NSError {
                print(error.description)
            }
        }
        
    }
    
    func makeALocalSearch() {
        
        let localSearchRequest = MKLocalSearchRequest()
        let span = MKCoordinateSpanMake(0.075, 0.075)
        localSearchRequest.naturalLanguageQuery = sharedInstance.selectedEvent as String
        localSearchRequest.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(sharedInstance.currentLocationLatValue, sharedInstance.currentLocationLongValue),span)
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) in
          
            if localSearchResponse != nil{
                
                for mapitem in (localSearchResponse?.mapItems)!{
                    
                    self.searchResults.addObject(mapitem)
                }
                
                self.showInMap()
                self.setupHorizontalScroll()

            }}
    }

    
    func showInMap() {
        
        print("\(searchResults.count) results found for \(sharedInstance.selectedEvent)")
        pageVw.numberOfPages = self.searchResults.count
        pageVw.currentPage = 0
        
        for mapItem in self.searchResults {
          
            let currentMapItem = mapItem as! MKMapItem
            let latV:Double = currentMapItem.placemark.coordinate.latitude
            let longV:Double = currentMapItem.placemark.coordinate.longitude
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude:latV, longitude:longV)
            self.pointAnnotation.title = currentMapItem.placemark.name
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)

            self.mapVw.centerCoordinate = self.pointAnnotation.coordinate
            self.mapVw.addAnnotation(self.pinAnnotationView.annotation!)
            
            if currentMapItem.isCurrentLocation {
              
                self.mapVw.selectAnnotation(self.pointAnnotation, animated: true)
            }}
        }
    
    
    // MARK: MKMapView Delegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let customAnnotationView = MKAnnotationView()
        customAnnotationView.frame = CGRectMake(0,0,20,20)
        customAnnotationView.backgroundColor = UIColor.clearColor()
        
        let pinImgViw = UIImageView()
        pinImgViw.tag = 5
        pinImgViw.frame = customAnnotationView.bounds
        pinImgViw.contentMode = .ScaleAspectFit
        pinImgViw.image = UIImage(named: "annotationImg")
        customAnnotationView.addSubview(pinImgViw)
        customAnnotationView.userInteractionEnabled = true
        customAnnotationView.canShowCallout = true
        
        return customAnnotationView
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        view.canShowCallout = true
        titleLabl.text = (view.annotation?.title)!
        var i:Int = 0
        for mapItem in self.searchResults {
           i = i+1
            let currentMapItem = mapItem as! MKMapItem
            if currentMapItem.name == (view.annotation?.title)! {
                    addrsVw.text = currentMapItem.placemark.title
                    pageVw.currentPage = i
                    let firstLoc = CLLocation(latitude: sharedInstance.currentLocationLatValue, longitude: sharedInstance.currentLocationLongValue)
                    let secondLoc = CLLocation(latitude: currentMapItem.placemark.coordinate.latitude, longitude:currentMapItem.placemark.coordinate.longitude)
                    let distance = firstLoc.distanceFromLocation(secondLoc)
                    phoneNumbe.text = String(format: "%.1f kms", distance/1000)
                
                        if (currentMapItem.phoneNumber != nil) {
                                distnaceLbl.text = String(currentMapItem.phoneNumber! as String)
                            }else{
                    distnaceLbl.text = ""
                    }
            }
            
            sharedInstance.setSelectedVerticalsLocation(currentMapItem.placemark.coordinate.latitude, long: currentMapItem.placemark.coordinate.longitude)
        }
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn, animations: {
           
            self.containerVw.alpha = 0.8
            }) { (true) in
                
            }
    }
    
    
    var fetchedResultsController: NSFetchedResultsController {
       
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("FavouritesEntity", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName:nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
            
        } catch {

            abort()
        }
        
        return _fetchedResultsController!
    }
    
    // MARK: FRC Delegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
    }
    
    @IBAction func addToIndex(sender: AnyObject) {
        
        let context = self.fetchedResultsController.managedObjectContext
        let entity = self.fetchedResultsController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context) as! FavouritesEntity
        
        let date = NSDate()
        newManagedObject.setValue(date, forKey: "timeStamp")
        newManagedObject.title = titleLabl.text
        newManagedObject.address = addrsVw.text
        newManagedObject.phoneNumber = distnaceLbl.text! as String
        newManagedObject.uniqueID = String(format: "%@",date)
        newManagedObject.latitude = sharedInstance.selectedVerticalLati
        newManagedObject.longtitude = sharedInstance.selectedVerticalLongi
        
        // Save the context.
        do {
            try context.save()
            
        } catch {
            
            abort()
        }
        
        //** Indexing
        
        let activity = NSUserActivity(activityType:String(format: "%@",date))
        activity.title = titleLabl.text
        //activity.userInfo = userActivityUserInfo
        activity.keywords = [sharedInstance.selectedEvent as String, titleLabl.text!]
        activity.contentAttributeSet = attributeSet
        activity.eligibleForSearch = true
        userActivity = activity
        print("Item is Indexed. You can now search for \(sharedInstance.selectedEvent) in Spotlight Search of your device.")
        let alert=UIAlertController(title: "LocalSearch", message: "Item is Indexed. You can now search for \(sharedInstance.selectedEvent) in Spotlight Search & get the details", preferredStyle: .Alert);

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default)
        { action -> Void in
           
            NSThread.detachNewThreadSelector(Selector("suspend"), toTarget: UIApplication.sharedApplication(), withObject: nil)

        })
        self.presentViewController(alert, animated: true, completion: {
            
        })

    }
    
    @IBAction func showDirections(sender: AnyObject){
        
    }
    
    var attributeSet: CSSearchableItemAttributeSet {
     
        let attributeSet = CSSearchableItemAttributeSet(
        itemContentType: kUTTypeContact as String)
        attributeSet.title = sharedInstance.selectedEvent as String
            if (distnaceLbl.text != nil) {
                attributeSet.phoneNumbers = [distnaceLbl.text! as String]
            }
        
        attributeSet.contentDescription = "\(addrsVw.text)\n\(distnaceLbl.text)"
        attributeSet.thumbnailData = UIImageJPEGRepresentation(
        UIImage(named:"EvolutionStudio")! , 0.9)
        attributeSet.supportsPhoneCall = true
        
        return attributeSet

    }
    
    func setupHorizontalScroll() {
        
        let imageWidth:CGFloat = self.view.frame.size.width-20
        let imageHeight:CGFloat = 66
        var xPosition:CGFloat = 0
        var scrollViewSize:CGFloat=0
        let scrollVw = UIScrollView()
        scrollVw.frame = CGRectMake(containerVw.frame.origin.x, containerVw.frame.origin.y + 50, containerVw.frame.size.width, containerVw.frame.size.height-50)
        scrollVw.pagingEnabled = true
        scrollVw.showsHorizontalScrollIndicator = false
        scrollVw.userInteractionEnabled = true
        scrollVw.backgroundColor = UIColor.clearColor()
        
        for mapItem in self.searchResults {
            
            let currentMapItem = mapItem as! MKMapItem
            let latV:Double = currentMapItem.placemark.coordinate.latitude
            let longV:Double = currentMapItem.placemark.coordinate.longitude
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude:latV, longitude:longV)
            self.pointAnnotation.title = currentMapItem.placemark.name
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            
            self.mapVw.centerCoordinate = self.pointAnnotation.coordinate
            self.mapVw.addAnnotation(self.pinAnnotationView.annotation!)
            mapVw.selectAnnotation(self.pinAnnotationView.annotation!, animated: true)
            
            let myImageView:UIImageView = UIImageView()
            myImageView.backgroundColor = UIColor.clearColor()
            
            myImageView.frame.size.width = imageWidth
            myImageView.frame.size.height = imageHeight
            myImageView.frame.origin.x = xPosition
            myImageView.frame.origin.y = 10
            
            scrollVw.addSubview(myImageView)
            xPosition += imageWidth
            scrollViewSize += imageWidth
        }
        
        scrollVw.contentSize = CGSize(width: scrollViewSize, height: imageHeight)
        scrollVw.delegate = self
        containerVw.userInteractionEnabled = true
        self.view.addSubview(scrollVw)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let  xPos:CGFloat = (scrollView.contentOffset.x)/(self.view.frame.size.width-20);
        let myIntValue:Int = Int(xPos)
        pageVw.currentPage = myIntValue
        let filteredVal:NSMutableArray = NSMutableArray()
        filteredVal.addObject(self.searchResults.objectAtIndex(myIntValue))
        
        for mapItem in filteredVal{
            
            let currentMapItem = mapItem as! MKMapItem
            let latV:Double = currentMapItem.placemark.coordinate.latitude
            let longV:Double = currentMapItem.placemark.coordinate.longitude
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude:latV, longitude:longV)
            self.pointAnnotation.title = currentMapItem.placemark.name
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            
            self.mapVw.centerCoordinate = self.pointAnnotation.coordinate
            self.mapVw.addAnnotation(self.pinAnnotationView.annotation!)
            mapVw.selectAnnotation(self.pinAnnotationView.annotation!, animated: true)
        }
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
