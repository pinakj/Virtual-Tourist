//
//  PhotoCollectionViewController.swift
//  FlickFinder
//
//  Created by Pinak Jalan on 7/28/17.
//  Copyright © 2017 Pinak Jalan. All rights reserved.
//

import UIKit
import Foundation
import MapKit

private let reuseIdentifier = "Cell"




class PhotoCollectionViewController: UIViewController,UICollectionViewDataSource,MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet var mapView:MKMapView!
    
    public var pinData : Pin?
    public var latitude:Double = 0.0
    public var longitude:Double = 0.0
    var columnNum:CGFloat = 2.0
    let inset: CGFloat = 5.0
    let spacing: CGFloat = 5.0
    let lineSpacing: CGFloat = 5.0
    var photosFromDisk = [UIImage]()
    var photoCount:Int  = 0

    
    @IBOutlet var collectionView: UICollectionView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        
        mapView.isUserInteractionEnabled = false
        
        // Add map pin annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: (pinData?.latitude)!, longitude: (pinData?.longitude)!)
        self.mapView.addAnnotation(annotation)
        
        let center = annotation.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.regionThatFits(region)

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoCount = (pinData?.relationship?.count)!
        if photoCount > 0
        {
            let photos = pinData?.relationship?.allObjects
            for photo in photos!
            {
                let image = UIImage(data: ((photo as! Photo).photo!) as Data)
                photosFromDisk.append(image!)
            }
            
        }
    }
}
extension PhotoCollectionViewController
{

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(photosFromDisk.count)
        return photosFromDisk.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CustomCollectionViewCell
        cell.activityIndicator.startAnimating()
        
        DispatchQueue.main.async {
            cell.imageView?.image = self.photosFromDisk[indexPath.row]

        }
        cell.activityIndicator.stopAnimating()
        print("Called")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("Resizing")
        let width = Int((collectionView.frame.width / columnNum) - (inset + spacing))
        
        return CGSize(width: width, height: width)
    }
    
    //top, bottom, left and right margin spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    //spacing between lines(items)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    //Spacing between each line(successive row)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
}

