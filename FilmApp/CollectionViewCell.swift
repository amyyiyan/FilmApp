//
//  CollectionViewCell.swift
//  FilmApp
//
//  Created by Amy Liu on 7/26/18.
//  Copyright © 2018 Amy Liu. All rights reserved.
//

import UIKit

protocol CollectionViewCellDelegate: class {
    
    func delete (indexPath: IndexPath)
    
}

class CollectionViewCell: UICollectionViewCell {
    
    var indexPath: IndexPath?
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var labelview: UILabel!
    @IBOutlet weak var deleteButtonBackgroundView: UIVisualEffectView!
    
    weak var delegate: CollectionViewCellDelegate?
    
    var imageName: String! {
        didSet {
            imageview.image = UIImage(named: imageName)
            deleteButtonBackgroundView.layer.masksToBounds = true
            deleteButtonBackgroundView.isHidden = !isEditing
        }
    }
    
    var isEditing: Bool = false {
        didSet {
            deleteButtonBackgroundView.isHidden = !isEditing
        }
    }
    
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        print("tapped delete x")
        delegate?.delete(indexPath: indexPath!)
    }
}
