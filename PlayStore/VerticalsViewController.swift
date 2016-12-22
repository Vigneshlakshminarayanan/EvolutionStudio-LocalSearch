//
//  VerticalsViewController.swift
//  PlayStore
//
//  Created by Vignesh on 22/12/16.
//  Copyright © 2016 TridentSolutions. All rights reserved.
//

import UIKit
import MapKit

class VerticalsViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapVw: MKMapView!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var searchResults = NSMutableArray()
    let sharedIns = SharedInstance.sharedInstance
    @IBOutlet weak var containerVw: UIView!
    @IBOutlet weak var titleLabl: UILabel!
    @IBOutlet weak var addrsVw: UITextView!
    
    @IBOutlet weak var phoneNumbe: UILabel!
    @IBOutlet weak var distnaceLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapVw.showsUserLocation = true
        mapVw.delegate = self
        mapVw.zoomEnabled = true
        mapVw.showsTraffic = true
        mapVw.showsBuildings = true
        addrsVw.userInteractionEnabled = false
        titleLabl.adjustsFontSizeToFitWidth = true
        addrsVw.sizeToFit()
        containerVw.alpha = 0;
        
        //** Map Span & Region
        let span = MKCoordinateSpanMake(0.075, 0.075)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: sharedIns.latitudeValue, longitude: sharedIns.longiValue), span: span)
        mapVw.setRegion(region, animated: true)
        
        
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = sharedIns.cateogorySelected as String
        localSearchRequest.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(sharedIns.latitudeValue, sharedIns.longiValue),span)
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) in
            if localSearchResponse != nil{
                
                print(localSearchResponse?.boundingRegion)
                print(localSearchResponse?.mapItems)
                
                for mapitem in (localSearchResponse?.mapItems)!{
                    self.searchResults.addObject(mapitem)
                }
                
                self.showInMap()
            }}
        
        // Do any additional setup after loading the view.
    }

    
    func showInMap() {
        
        for mapItem in self.searchResults {
            
            let currentMapItem = mapItem as! MKMapItem
            print(currentMapItem.placemark.coordinate.latitude)
            print(currentMapItem.placemark.coordinate.longitude)
            
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
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annoView = MKAnnotationView()
        annoView.frame = CGRectMake(0,0,20,20)
        annoView.backgroundColor = UIColor.clearColor()
        
        let imgVw = UIImageView()
        imgVw.tag = 5
        imgVw.frame = annoView.bounds
        imgVw.contentMode = .ScaleAspectFit
        imgVw.image = UIImage(named: "annotationImg")
        annoView.addSubview(imgVw)
        annoView.userInteractionEnabled = true
        annoView.canShowCallout = true
        
        return annoView
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        view.canShowCallout = true
        titleLabl.text = (view.annotation?.title)!
        
        for mapItem in self.searchResults {
            let currentMapItem = mapItem as! MKMapItem
            if currentMapItem.name == (view.annotation?.title)! {
                addrsVw.text = currentMapItem.placemark.title
                
                let firstLoc = CLLocation(latitude: sharedIns.latitudeValue, longitude: sharedIns.longiValue)
                let secondLoc = CLLocation(latitude: currentMapItem.placemark.coordinate.latitude, longitude:currentMapItem.placemark.coordinate.longitude)
                let distance = firstLoc.distanceFromLocation(secondLoc)
                print("Distance Between Me & Res\(distance/1000) kms")
                
                phoneNumbe.text = String(format: "%.1f kms", distance/1000)
                
                if (currentMapItem.phoneNumber != nil) {
                    distnaceLbl.text = String(currentMapItem.phoneNumber! as String)
                }else{
                    distnaceLbl.text = ""
                }}
        }
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn, animations: {
            self.containerVw.alpha = 0.8
            }) { (true) in
                
        }
    }
    
    @IBAction func showDirections(sender: AnyObject){
        
        let request:MKDirectionsRequest = MKDirectionsRequest()
        let source = self.searchResults[0] as! MKMapItem
        let destination = self.searchResults[1] as! MKMapItem

        
        // source and destination are the relevant MKMapItems
        request.source = source
        request.destination = destination
        
        // Specify the transportation type
        request.transportType = MKDirectionsTransportType.Automobile;
        
        // If you're open to getting more than one route,
        // requestsAlternateRoutes = true; else requestsAlternateRoutes = false;
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler ({
            (response: MKDirectionsResponse?, error: NSError?) in
            
            if error == nil {
                let directionsResponse:MKDirectionsResponse = response!
                // Get whichever currentRoute you'd like, ex. 0
                let route = directionsResponse.routes[0] as MKRoute
                print(route)
            }
        })
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
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
