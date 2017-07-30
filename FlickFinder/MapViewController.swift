//
//  MapViewController.swift
//  FlickFinder
//
//  Created by Pinak Jalan on 7/24/17.
//  Copyright © 2017 Pinak Jalan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate,NSFetchedResultsControllerDelegate {

    
    @IBOutlet var mapView:MKMapView!
    var pins = [Pin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        // Do any additional setup after loading the view.
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress))
        longPressGesture.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressGesture)

        //TO DO: Source this out to a method and make the code clean
        let defaults = UserDefaults.standard
        if let lat = defaults.value(forKey: "lat"), let long =  defaults.value(forKey: "long"), let latDelta = defaults.value(forKey: "latDelta"), let longDelta = defaults.value(forKey: "longDelta")
        {
            let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat as! Double, long as! Double)
            let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta as! Double, longDelta as! Double)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(center, span)
            self.mapView.setRegion(region, animated: true)
        }
        addPins()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // mapView.delegate = self
        self.navigationController?.navigationBar.isHidden = true

        

    }
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedResultsController?.delegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

    }

    func getPinsfromCoreData() -> [Pin]
    {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName:"Pin")
        fr.sortDescriptors = []
         fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext:sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        do
        {
            return try sharedContext.fetch(fr) as! [Pin]
        }
        catch
        {
            print("error in fetch")
            return [Pin]()
        }
    }
    
    func addPins()
    {
        pins = getPinsfromCoreData()
        for pin in pins
        {
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinate
            mapView.addAnnotation(annotation)
            do
            {
                try sharedContext.save()
            }
            catch {}
            
        }
    }
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
        
    }
    public func addAnnotationOnLongPress(gestureRecognizer:UIGestureRecognizer){
        //print("Called")
        if(gestureRecognizer.state == .began)
        {
            var touchPoint = gestureRecognizer.location(in: mapView)
            var newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.title = " "
            annotation.coordinate = newCoordinates
            let newPin = NSEntityDescription.insertNewObject(forEntityName: "Pin", into: self.sharedContext) as! Pin
            newPin.latitude = newCoordinates.latitude as Double
            newPin.longitude = newCoordinates.longitude as Double
            //TO DO: Call the convenience method and call the pins latitude and longitude on the search
            
            FlickrClient.sharedInstance().latitude = newPin.latitude
            FlickrClient.sharedInstance().longitude = newPin.longitude
            try! self.sharedContext.save()
            FlickrClient.sharedInstance().getPhotosforCoordinates(pin:newPin){(success,error) in
                if(success)
                {
                    print("Success")
                }
            }
            pins.append(newPin)
            do
            {
                try sharedContext.save()
            }
            catch {}
            pins.append(newPin)
            
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("Region changed")
        let defaults = UserDefaults.standard
        defaults.set(mapView.centerCoordinate.latitude, forKey: "lat")
        defaults.set(mapView.centerCoordinate.longitude, forKey: "long")
        defaults.set(mapView.region.span.latitudeDelta, forKey: "latDelta")
        defaults.set(mapView.region.span.longitudeDelta, forKey: "longDelta")
        do
        {
            try sharedContext.save()
        }
        catch {}
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Pin Tapped")
        mapView.deselectAnnotation(view.annotation, animated: true)
        // Fetch current pin data
        let request = NSFetchRequest<Pin>(entityName: "Pin")
        
        do {
            let pins = try (self.sharedContext).fetch(request)
            
            for pin in pins {
                
                if pin.latitude == FlickrClient.sharedInstance().latitude && pin.longitude == FlickrClient.sharedInstance().longitude {
                    
                    FlickrClient.sharedInstance().pinData = pin
                    try! self.sharedContext.save()


                    print("HERE")
                    break
                }
            }
        }
        catch{}
        self.performSegue(withIdentifier: "photoShow", sender: self)

    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
            view.isDraggable = true
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.animatesDrop = true
            view.isDraggable = true
        }
        return view
    }
}