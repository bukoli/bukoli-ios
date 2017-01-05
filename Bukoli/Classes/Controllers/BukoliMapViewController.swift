//
//  BukoliMapViewController.swift
//  Pods
//
//  Created by Utku Yıldırım on 22.09.2016.
//
//

import UIKit
import MapKit
import Alamofire

class BukoliMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var fabView: UIView!
    @IBOutlet weak var fabButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var informationLabel: UILabel!
    
    var bukoliPoints: [BukoliPoint] = []
    
    var locationManager: CLLocationManager!
    
    var currentLocation: CLLocation!
    var placeId: String!
    
    var searchController: UISearchController!
    var panGesture: UIPanGestureRecognizer!
    
    var request: Request?
    var lastKnownLocation: CLLocation!
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "BukoliDetailDialog") {
            definesPresentationContext = false
            let bukoliDetailDialog = segue.destinationViewController as! BukoliDetailDialog
            bukoliDetailDialog.bukoliMapViewController = self
            bukoliDetailDialog.index = sender as! Int
        }
        if (segue.identifier == "BukoliPhoneDialog") {
            definesPresentationContext = false
            let bukoliPhoneDialog = segue.destinationViewController as! BukoliPhoneDialog
            bukoliPhoneDialog.bukoliMapViewController = self
        }
        if (segue.identifier == "BukoliInfo") {
            let bukoliPhoneDialog = segue.destinationViewController as! BukoliInfoDialog
            bukoliPhoneDialog.bukoliMapViewController = self
            definesPresentationContext = false
        }
    }
    
    func pointSelected() {
        if (Bukoli.sharedInstance.shouldAskPhoneNumber) {
            self.performSegueWithIdentifier("BukoliPhoneDialog", sender: nil)
        }
        else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func close(sender: AnyObject) {
        // Close
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func centerButtonTapped(sender: AnyObject) {
        placeId = nil
        currentLocation = lastKnownLocation
        self.updatePoints(true)
    }
    
    @IBAction func switchButtonTapped(sender: AnyObject) {
        let switchButton = sender as! UIButton
        if (mapView.hidden) {
            // Switch to Map
            mapView.hidden = false
            centerImageView.hidden = false
            centerView.hidden = false
            centerButton.hidden = false
            tableView.hidden = true
            
            switchButton.selected = false
            UIView.animateWithDuration(0.25, animations: {
                self.view.layoutIfNeeded()
            })
        }
        else {
            // Switch to Table
            mapView.hidden = true
            centerImageView.hidden = true
            centerView.hidden = true
            centerButton.hidden = true
            tableView.hidden = false
            
            switchButton.selected = true
            UIView.animateWithDuration(0.25, animations: {
                self.view.layoutIfNeeded()
            })
            
            
        }
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bukoliPoints.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BukoliPointCell") as! BukoliPointCell
        cell.mapViewController = self
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let bukoliCell = cell as! BukoliPointCell
        let bukoliPoint = bukoliPoints[indexPath.row]
        
        bukoliCell.bukoliPoint = bukoliPoint
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Location
    
    func startLocationMonitoring() {
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.distanceFilter = 100.0;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        locationManager(locationManager, didChangeAuthorizationStatus: CLLocationManager.authorizationStatus())
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        locationManager = nil
        
        lastKnownLocation = locations.last
        currentLocation = lastKnownLocation
        mapChangedFromUserInteraction = false
        let viewRegion = MKCoordinateRegionMakeWithDistance(currentLocation!.coordinate, 2500, 2500)
        mapView.setRegion(viewRegion, animated: false)
        self.updatePoints(true)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status{
        case .NotDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            break
        case.Restricted:
            break
        case.Denied:
            self.showNotAuthorizedDialog()
            break
        case.AuthorizedWhenInUse, .AuthorizedAlways:
            self.locationManager.startUpdatingLocation()
            break
        }
    }
    
    func showNotAuthorizedDialog() {
        let alertController = UIAlertController(title: "Hata", message: "Yakınızdaki Bukoli noktalarını bulmamız için konum izni vermelisiniz. İzin vermek için ayarlara gidebilir veya izin vermek istemiyorsanız adresinizi aratabilirsiniz.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let OKAction = UIAlertAction(title: "Kapat", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) in }
        alertController.addAction(OKAction)
        
        
        let cancelAction = UIAlertAction(title: "Ayarlar", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction!) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Map
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        if annotation is BukoliPoint {
            let annotationIdentifier = "Bukoli Annotation"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) as? BukoliAnnotationView
            if (annotationView == nil) {
                annotationView = BukoliAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                
                let pinView = Bukoli.bundle().loadNibNamed("BukoliPinView", owner: self, options: nil)![0] as! BukoliPinView
                annotationView!.centerOffset = CGPoint(x: 0, y: -30)
                annotationView!.layer.zPosition = 0
                annotationView!.pinView = pinView
                annotationView!.frame = pinView.frame
                annotationView!.addSubview(pinView)
                pinView.layoutIfNeeded()
                
            }
            
            // Find Index
            for (index, bukoliPoint) in bukoliPoints.enumerate() where bukoliPoint.id == (annotation as! BukoliPoint).id  {
                annotationView?.pinView.label.text = "\(index+1)"
                if bukoliPoint.isLocker! {
                    annotationView!.pinView.imageView.tintColor = UIColor(hex: 0xFF31AADE)
                    annotationView!.pinView.centerView.backgroundColor = UIColor(hex: 0xFF31AADE).lighter()
                    annotationView!.pinView.centerView.layer.borderColor = UIColor.whiteColor().CGColor
                }
                else {
                    annotationView!.pinView.imageView.tintColor = Bukoli.sharedInstance.buttonBackgroundColor
                    annotationView!.pinView.centerView.backgroundColor = Bukoli.sharedInstance.buttonBackgroundColor.lighter()
                    annotationView!.pinView.centerView.layer.borderColor = Bukoli.sharedInstance.buttonTextColor.CGColor
                }
            }
            
            return annotationView
        }
        
        return nil

    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
        for (index, bukoliPoint) in bukoliPoints.enumerate() where bukoliPoint.id == (view.annotation as! BukoliPoint).id  {
            self.performSegueWithIdentifier("BukoliDetailDialog", sender: index)
        }
    }
    
    private var mapChangedFromUserInteraction = true
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let centerLocation = CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
        if (mapChangedFromUserInteraction) {
            if (currentLocation != nil && currentLocation!.distanceFromLocation(centerLocation) > 100) {
                currentLocation = centerLocation
                placeId = nil
                self.updatePoints(false)
            }
        }
        
        mapChangedFromUserInteraction = true
    }
    
    func updateMarkers(animated: Bool = true) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(self.bukoliPoints)
        if (animated) {
            mapChangedFromUserInteraction = false
            if (placeId != nil) {
                mapView.showAnnotations(self.bukoliPoints, animated: true)
            } else {
                self.fitAnnotationsKeepingCenter()
            }
            
        }
    }
    
    func fitAnnotationsKeepingCenter() {
        var maxDistance:Double = 0
        for annotation: MKAnnotation in mapView.annotations {
            let annotationLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            maxDistance = max(maxDistance, currentLocation.distanceFromLocation(annotationLocation))
        }
        var fittedRegion = MKCoordinateRegionMakeWithDistance(currentLocation!.coordinate, maxDistance * 2, maxDistance * 2)
        fittedRegion = mapView.regionThatFits(fittedRegion)
        fittedRegion.span.latitudeDelta *= 1.1
        fittedRegion.span.longitudeDelta *= 1.1
        mapView.setRegion(fittedRegion, animated: true)
    }
    
    func moveMap(point:BukoliPoint) {
        mapChangedFromUserInteraction = false
        var region = mapView.region
        region.center = point.coordinate
        mapView.setRegion(region, animated: true)
    }
    
    
    // MARK: - Service
    
    func updatePoints(animated: Bool = true) {
        var parameters: [String: AnyObject] = ["geocode": 1]
        
        if (placeId != nil) {
            parameters["place_id"] = placeId
        }
        else if (currentLocation != nil) {
            parameters["latitude"] = currentLocation!.coordinate.latitude
            parameters["longitude"] = currentLocation!.coordinate.longitude
        }
        
        request?.cancel()
        activityIndicator.startAnimating()
        request = WebService.GET("point", parameters: parameters, success: {
            (response: BukoliResponse<BukoliPoint>) in
            self.bukoliPoints = response.data
            
            // Update Address without trigger
            self.searchController.searchResultsUpdater = nil
            self.searchController.searchBar.text = response.address!
            self.searchController.searchResultsUpdater = self.searchController.searchResultsController as? UISearchResultsUpdating
            
            self.updateMarkers(animated)
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }) {
            (error: Error) in
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Hata", message: error.error, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem?.tintColor = Bukoli.sharedInstance.buttonTextColor
        self.navigationController?.navigationBar.barTintColor = Bukoli.sharedInstance.buttonBackgroundColor
        self.navigationController?.navigationBar.translucent = false
        
        // Do any additional setup after loading the view.
        let bukoliSearchViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BukoliSearchViewController") as! BukoliSearchViewController
        bukoliSearchViewController.bukoliMapViewController = self
        searchController = UISearchController(searchResultsController: bukoliSearchViewController)
        searchController.delegate = self
        searchController.searchResultsUpdater = bukoliSearchViewController
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        
        searchController.searchBar.placeholder = "İlçe, mahalle, sokak ara"
        searchController.searchBar.tintColor = Bukoli.sharedInstance.buttonTextColor
        searchController.searchBar.barTintColor = Bukoli.sharedInstance.buttonBackgroundColor
        
        self.navigationItem.titleView = searchController.searchBar
        
        // MapView
        mapView.delegate = self
        mapView.mapType = .Standard
        mapView.showsUserLocation = true
        mapView.rotateEnabled = false
        lastKnownLocation = CLLocation(latitude: 41.04113936, longitude: 28.99533076)
        currentLocation = lastKnownLocation
        let viewRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 25000, 25000)
        mapView.setRegion(viewRegion, animated: false)
        
        // Center
        self.centerView.layer.shadowColor = UIColor.blackColor().CGColor
        self.centerView.layer.shadowOpacity = 0.5
        self.centerView.layer.shadowRadius = 2
        self.centerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        // Fab
        self.fabView.layer.shadowColor = UIColor.blackColor().CGColor
        self.fabView.layer.shadowOpacity = 0.5
        self.fabView.layer.shadowRadius = 2
        self.fabView.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        // Activity Indicator
        self.activityIndicator.layer.cornerRadius = 4
        self.activityIndicator.color = Bukoli.sharedInstance.buttonBackgroundColor
        self.activityIndicator.backgroundColor = Bukoli.sharedInstance.buttonTextColor.colorWithAlphaComponent(0.90)
        WebService.Authorize({
            // Location
            self.updatePoints(false)
            self.startLocationMonitoring()
            
            }, failure: { (error: Error) in
                
                self.activityIndicator.stopAnimating()
                let alert = UIAlertController(title: "Hata", message: error.error, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .Cancel, handler: { (UIAlertAction) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
        })
        
        // Information
        WebService.GET("information", parameters: nil, success: {
            (response: Information) in
            self.informationLabel.text = response.information
        }) {
            (error: Error) in
            // Ignore errors
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        definesPresentationContext = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        Bukoli.complete()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centerView.layer.cornerRadius = fabView.frame.width/2
        centerButton.layer.cornerRadius = fabButton.frame.width/2
        
        fabView.layer.cornerRadius = fabView.frame.width/2
        fabButton.layer.cornerRadius = fabButton.frame.width/2
    }
    
}
