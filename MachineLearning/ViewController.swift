//
//  ViewController.swift
//  MachineLearning
//
//  Created by Sebastian Sundet Flaen on 19/07/2019.
//  Copyright © 2019 ssflaen. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false //ingen cropping
        //implements camera
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[.originalImage] as? UIImage {
            
            imageView.image = userPickedImage
            
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Kunne ikke konvertere til ciiImage")
            }
            detect(image: ciImage)
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("loading coreML failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Model failed to process image")
            }
            print(results)
            if let firstResult = results.first{
                if firstResult.identifier.contains("hotdog"){
                    print(results.first)
                    self.navigationItem.title = "Pølse"
                }else {
                    self.navigationItem.title = "Dette er ikke en pølse"
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try! handler.perform([request])
        } catch {
            print("could not perform \(error)")
        }
        
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

