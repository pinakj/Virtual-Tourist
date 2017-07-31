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

        // Register cell classes
        photoCount = (pinData?.relationship?.count)!
        if photoCount > 0
        {
            let photos = pinData?.relationship?.allObjects
            for photo in photos!
            {
                let image = UIImage(data: ((photo as! Photo).photo as! NSData) as Data)
                photosFromDisk.append(image!)
            }
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
}
extension PhotoCollectionViewController
{

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("This called")
        return photosFromDisk.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CustomCollectionViewCell
        
        cell.imageView?.image = self.photosFromDisk[indexPath.row]
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */


