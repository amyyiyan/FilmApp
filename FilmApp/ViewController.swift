//
//  ViewController.swift
//  FilmApp
//
//  Created by Amy Liu on 7/24/18.
//  Copyright © 2018 Amy Liu. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var newImage: UIImage!
    @IBOutlet weak var cameraView: UIImageView!
    
    @IBAction func cameraUpload(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func savebutton(_ sender: Any) {
        CoreDataHelper.saveImage()
        self.performSegue(withIdentifier: "saveSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveSegue" {
        CoreDataHelper.saveImage()
           let destinationVC = segue.destination as! PhotoGalleryCollectionViewController
            print("I am amazing!")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            cameraView.image = image
            let newImageObject = CoreDataHelper.newImage()
//            let imageData = UIImagePNGRepresentation(image)
            let uiImageFixedOrientation = fixOrientation(img: image)
            let fixedOrientation = CIImage(image: uiImageFixedOrientation)
            
            //Create sephia filter
            guard let sepiaFilter = CIFilter(name:"CISepiaTone",
                                             withInputParameters:
                [
                    kCIInputImageKey: fixedOrientation,
                    kCIInputIntensityKey: 0.5
                ]) else {
                    return
            }
            
            guard let sepiaCIImage = sepiaFilter.outputImage else {
                return
            }
            
            guard
                let coloredNoise = CIFilter(name: "CIRandomGenerator"),
                let noiseImage = coloredNoise.outputImage else {
                    return
            }
            
            // Create a whitening filter using CI Vectors
            let whitenVector = CIVector(x: 0, y: 1, z: 0, w: 0)
            let fineGrain = CIVector(x:0, y:0.005, z:0, w:0)
            let zeroVector = CIVector(x: 0, y: 0, z: 0, w: 0)
            guard let whiteningFilter = CIFilter(name:"CIColorMatrix",
                                               withInputParameters:
                    [
                        kCIInputImageKey: noiseImage,
                        "inputRVector": whitenVector,
                        "inputGVector": whitenVector,
                        "inputBVector": whitenVector,
                        "inputAVector": fineGrain,
                        "inputBiasVector": zeroVector
                    ]),
                    let whiteSpecks = whiteningFilter.outputImage else {
                        return
            }
            
            guard
                let speckCompositor = CIFilter(name:"CISourceOverCompositing",
                                               withInputParameters:
                    [
                        kCIInputImageKey: whiteSpecks,
                        kCIInputBackgroundImageKey: sepiaCIImage
                    ]),
                    let speckledImage = speckCompositor.outputImage else {
                        return
            }
            
            //simulate scratch by scaling randomly varying noise
            let verticalScale = CGAffineTransform(scaleX: 1.5, y: 25)
            let transformedNoise = noiseImage.transformed(by: verticalScale)
            
            let darkenVector = CIVector(x: 4, y: 0, z: 0, w: 0)
            let darkenBias = CIVector(x: 0, y: 1, z: 1, w: 1)
            
            guard
                let darkeningFilter = CIFilter(name:"CIColorMatrix",
                                               withInputParameters:
                    [
                        kCIInputImageKey: transformedNoise,
                        "inputRVector": darkenVector,
                        "inputGVector": zeroVector,
                        "inputBVector": zeroVector,
                        "inputAVector": zeroVector,
                        "inputBiasVector": darkenBias
                    ]),
                let randomScratches = darkeningFilter.outputImage
                else {
                    return
            }
            
            guard
                let grayscaleFilter = CIFilter(name:"CIMinimumComponent",
                                               withInputParameters:
                    [
                        kCIInputImageKey: randomScratches
                    ]),
                let darkScratches = grayscaleFilter.outputImage
                else {
                    return
            }
            
            guard
                let oldFilmCompositor = CIFilter(name:"CIMultiplyCompositing",
                                                 withInputParameters:
                    [
                        kCIInputImageKey: darkScratches,
                        kCIInputBackgroundImageKey: speckledImage
                    ]),
                let oldFilmImage = oldFilmCompositor.outputImage
                else {
                    return
            }
            
            let finalImage = oldFilmImage.cropped(to: (fixedOrientation?.extent)!)
            
            //border stuff
            let frames: [UIImage] = [#imageLiteral(resourceName: "border-1"), #imageLiteral(resourceName: "border-2"), #imageLiteral(resourceName: "border-3"), #imageLiteral(resourceName: "border-4"), #imageLiteral(resourceName: "border-5"), #imageLiteral(resourceName: "border-6"), #imageLiteral(resourceName: "border-7"), #imageLiteral(resourceName: "border-8"), #imageLiteral(resourceName: "border-9"), #imageLiteral(resourceName: "border-10")]
            let randomInt = Int(arc4random_uniform(UInt32(frames.count)))
            let randomlyPickedFrame = frames[randomInt]
            
            guard let borderedCIImage = CIImage(image: randomlyPickedFrame) else {
                return
            }
    
            let borderedImage = borderedCIImage.composited(over: finalImage)
            
            let outputImage = UIImage(ciImage: borderedImage)

            
//            let outputImage = UIImage(ciImage: sepiaCIImage)
//            let outputImage = UIImage(ciImage: speckledImage)
//            guard
//            let outputImage = UIImage(data: speckledImage.png(size: uiImageFixedOrientation.size)!) else {
//                    return
//            }
        
            let imageData = finalImage.png(size: uiImageFixedOrientation.size)!
            newImageObject.image = UIImage(data: imageData)!
            newImageObject.date = Date()
            
            print(newImageObject.image)
            print(newImageObject.date)
            print("Output Image: \(outputImage)")
            
            cameraView.image = outputImage
            CoreDataHelper.saveImage()
            
        } else  {
            //error
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == UIImageOrientation.up) { return img }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func convert(image:CIImage) -> UIImage
    {
        let image:UIImage = UIImage.init(ciImage: image)
        return image
    }

}

extension UIImage {
    var jpeg: Data? {
        return UIImageJPEGRepresentation(self, 1)   // QUALITY min = 0 / max = 1
    }
    var png: Data? {
        return UIImagePNGRepresentation(self)
    }
}

extension CIImage {
    func png(size: CGSize) -> Data? {
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        UIImage(ciImage: self).draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()?.png
    }
}
