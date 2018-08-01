//
//  CollectionViewController.swift
//  FilmApp
//
//  Created by Amy Liu on 7/26/18.
//  Copyright © 2018 Amy Liu. All rights reserved.
//

import UIKit

class PhotoGalleryCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var lastImageSelected: UIImage?

    @IBOutlet weak var collectionView: UICollectionView!
    
    let formatter = DateFormatter()
    var imageObjects: [ImageWithAttributes] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var editModeOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        imageObjects = CoreDataHelper.retrieveImage()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        let imageObject = imageObjects[indexPath.item]
        
        if let photo = imageObject.image {
            cell.imageview.image = UIImage(data: photo)
        }
        
//        cell.labelview.text = String(imageObject.date)
//        cell.imageview.image = UIImage(data: imageObjects[indexPath.row].image!)
//        cell.labelview.text = formatter.string(from: imageObject.date!)
        
        cell.isEditing = self.editModeOn
        cell.labelview.text = imageObject.date?.convertToString()
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        lastImageSelected = UIImage(data: imageObjects[indexPath.item].image!)
        performSegue(withIdentifier: "enlargedImageSegue" , sender: self)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        editModeOn = !editModeOn
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == "enlargedImageSegue" {
            let destination = segue.destination as! EnlargedImageViewController
            destination.image = lastImageSelected
        }
    }
}

extension Date {
    func convertToString() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
    }
}

extension PhotoGalleryCollectionViewController : CollectionViewCellDelegate {
    func delete(indexPath: IndexPath) {
        CoreDataHelper.delete(freshImage: imageObjects[indexPath.item])
        imageObjects.remove(at: indexPath.row)
        print("Pressed delete")
        collectionView.reloadData()
        CoreDataHelper.saveImage()
    }
}


