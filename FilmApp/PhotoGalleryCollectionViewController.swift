//
//  CollectionViewController.swift
//  FilmApp
//
//  Created by Amy Liu on 7/26/18.
//  Copyright © 2018 Amy Liu. All rights reserved.
//

import UIKit

class PhotoGalleryCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let formatter = DateFormatter()
    var imageObjects: [ImageWithAttributes] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageObjects = CoreDataHelper.retrieveImage()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        cell.imageview.image = UIImage(data: imageObjects[indexPath.row].image!)
//        cell.labelview.text = formatter.string(from: imageObjects[indexPath.row].date!)
        
        return cell
    }
}
