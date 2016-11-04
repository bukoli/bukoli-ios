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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "BukoliDetailDialog") {
            definesPresentationContext = false
            let bukoliDetailDialog = segue.destination as! BukoliDetailDialog
            bukoliDetailDialog.bukoliMapViewController = self
            bukoliDetailDialog.index = sender as! Int
        }
        if (segue.identifier == "BukoliPhoneDialog") {
            definesPresentationContext = false
            let bukoliPhoneDialog = segue.destination as! BukoliPhoneDialog
            bukoliPhoneDialog.bukoliMapViewController = self
        }
        if (segue.identifier == "BukoliInfo") {
            definesPresentationContext = false
        }
    }
    
    func pointSelected() {
        if (Bukoli.sharedInstance.shouldAskPhoneNumber) {
            self.performSegue(withIdentifier: "BukoliPhoneDialog", sender: nil)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Actions

    @IBAction func close(_ sender: AnyObject) {
        // Close
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func centerButtonTapped(_ sender: AnyObject) {
        placeId = nil
        currentLocation = lastKnownLocation
        self.updatePoints(true)
    }
    
    @IBAction func switchButtonTapped(_ sender: AnyObject) {
        let switchButton = sender as! UIButton
        if (mapView.isHidden) {
            // Switch to Map
            mapView.isHidden = false
            centerImageView.isHidden = false
            centerView.isHidden = false
            centerButton.isHidden = false
            tableView.isHidden = true
            
            switchButton.isSelected = false
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
        }
        else {
            // Switch to Table
            mapView.isHidden = true
            centerImageView.isHidden = true
            centerView.isHidden = true
            centerButton.isHidden = true
            tableView.isHidden = false
            
            switchButton.isSelected = true
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bukoliPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BukoliPointCell") as! BukoliPointCell
        cell.mapViewController = self
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let bukoliCell = cell as! BukoliPointCell
        let bukoliPoint = bukoliPoints[indexPath.row]
        
        bukoliCell.bukoliPoint = bukoliPoint
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Location
    
    func startLocationMonitoring() {
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.distanceFilter = 100.0;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        locationManager(locationManager, didChangeAuthorization: CLLocationManager.authorizationStatus())
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        locationManager = nil
        
        lastKnownLocation = locations.last
        currentLocation = lastKnownLocation
        mapChangedFromUserInteraction = false
        let viewRegion = MKCoordinateRegionMakeWithDistance(currentLocation!.coordinate, 2500, 2500)
        mapView.setRegion(viewRegion, animated: false)
        self.updatePoints(true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .denied:
            self.showNotAuthorizedDialog()
            break
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
            break
        }
    }
    
    func showNotAuthorizedDialog() {
        let alertController = UIAlertController(title: "Hata", message: "Yakınızdaki Bukoli noktalarını bulmamız için konum izni vermelisiniz. İzin vermek için ayarlara gidebilir veya izin vermek istemiyorsanız adresinizi aratabilirsiniz.", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Kapat", style: .default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(OKAction)
        
        
        let cancelAction = UIAlertAction(title: "Ayarlar", style: .cancel) { (action:UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
            UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    // MARK: - Map
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        if annotation is BukoliPoint {
            let annotationIdentifier = "Bukoli Annotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? BukoliAnnotationView
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
            for (index, bukoliPoint) in bukoliPoints.enumerated() where bukoliPoint.id == (annotation as! BukoliPoint).id  {
                annotationView?.pinView.label.text = "\(index+1)"
                if bukoliPoint.isLocker! {
                    annotationView!.pinView.imageView.tintColor = UIColor(hex: 0xFF31AADE)
                    annotationView!.pinView.centerView.backgroundColor = UIColor(hex: 0xFF31AADE).lighter()
                    annotationView!.pinView.centerView.layer.borderColor = UIColor.white.cgColor
                }
                else {
                    annotationView!.pinView.imageView.tintColor = Bukoli.sharedInstance.buttonBackgroundColor
                    annotationView!.pinView.centerView.backgroundColor = Bukoli.sharedInstance.buttonBackgroundColor.lighter()
                    annotationView!.pinView.centerView.layer.borderColor = Bukoli.sharedInstance.buttonTextColor.cgColor
                }
            }

            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
        for (index, bukoliPoint) in bukoliPoints.enumerated() where bukoliPoint.id == (view.annotation as! BukoliPoint).id  {
            self.performSegue(withIdentifier: "BukoliDetailDialog", sender: index)
        }
    }
    
    private var mapChangedFromUserInteraction = true
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerLocation = CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
        if (mapChangedFromUserInteraction) {
            if (currentLocation != nil && currentLocation!.distance(from: centerLocation) > 100) {
                currentLocation = centerLocation
                placeId = nil
                self.updatePoints(false)
            }
        }
        
        mapChangedFromUserInteraction = true
    }
    
    func updateMarkers(_ animated: Bool = true) {
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
            maxDistance = max(maxDistance, currentLocation.distance(from: annotationLocation))
        }
        var fittedRegion = MKCoordinateRegionMakeWithDistance(currentLocation!.coordinate, maxDistance * 2, maxDistance * 2)
        fittedRegion = mapView.regionThatFits(fittedRegion)
        fittedRegion.span.latitudeDelta *= 1.1
        fittedRegion.span.longitudeDelta *= 1.1
        mapView.setRegion(fittedRegion, animated: true)
    }
    
    public func moveMap(_ point:BukoliPoint) {
        mapChangedFromUserInteraction = false
        var region = mapView.region
        region.center = point.coordinate
        mapView.setRegion(region, animated: true)
    }
    
    
    // MARK: - Service
    
    func updatePoints(_ animated: Bool = true) {
        var parameters: [String: Any] = ["geocode": 1]
        
        if (placeId != nil) {
            parameters["place_id"] = placeId
        }
        else if (currentLocation != nil) {
            parameters["latitude"] = currentLocation!.coordinate.latitude
            parameters["longitude"] = currentLocation!.coordinate.longitude
        }
        
        request?.cancel()
        activityIndicator.startAnimating()
        request = WebService.GET(uri: "point", parameters: parameters, success: {
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
            let alert = UIAlertController(title: "Hata", message: error.error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
 
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem?.tintColor = Bukoli.sharedInstance.buttonTextColor
        self.navigationController?.navigationBar.barTintColor = Bukoli.sharedInstance.buttonBackgroundColor
        self.navigationController?.navigationBar.isTranslucent = false

        // Do any additional setup after loading the view.
        let bukoliSearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "BukoliSearchViewController") as! BukoliSearchViewController
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
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.isRotateEnabled = false
        
        lastKnownLocation = CLLocation(latitude: 41.04113936, longitude: 28.99533076)
        currentLocation = lastKnownLocation
        let viewRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 25000, 25000)
        mapView.setRegion(viewRegion, animated: false)
        
        // Center
        self.centerView.layer.shadowColor = UIColor.black.cgColor
        self.centerView.layer.shadowOpacity = 0.5
        self.centerView.layer.shadowRadius = 2
        self.centerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        // Fab
        self.fabView.layer.shadowColor = UIColor.black.cgColor
        self.fabView.layer.shadowOpacity = 0.5
        self.fabView.layer.shadowRadius = 2
        self.fabView.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        // Activity Indicator
        self.activityIndicator.layer.cornerRadius = 4
        self.activityIndicator.color = Bukoli.sharedInstance.buttonBackgroundColor
        self.activityIndicator.backgroundColor = Bukoli.sharedInstance.buttonTextColor.withAlphaComponent(0.90)
        
        WebService.Authorize(success: {
            // Location
            self.updatePoints(false)
            self.startLocationMonitoring()
            
        }, failure: { (error: Error) in
            
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Hata", message: error.error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .cancel, handler: { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        })

        
        // Information
        WebService.GET(uri: "information", parameters: nil, success: {
            (response: Information) in
            self.informationLabel.text = response.information
        }) {
            (error: Error) in
            // Ignore errors
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        definesPresentationContext = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
