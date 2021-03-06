import UIKit
import CoreImage
import Photos

class PhotoFilterViewController: UIViewController {
    
//    // Setup the original image
//    var originalImage: UIImage? {
//        //updates the UI with the image that was picked
//        didSet {
//            print("Update the UI")
//            updateImage()
//        }
//    }
//
//    var scaledImage: UIImage? {
//        didSet {
//            updateImage()
//        }
//    }
    
    // From Paul:
    
    var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else { return }
            // Height and width
            var scaledSize = imageView.bounds.size
            // 1x, 2x, or 3x
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            print("size: \(scaledSize)")
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }
    var scaledImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    // Grab filter we're using
    private var filter = CIFilter(name: "CIColorControls")! //force unwrapped just for the lecture
    
    // Create a helper to do our rendering for us.
    private var context = CIContext(options: nil)
    
	@IBOutlet var brightnessSlider: UISlider!
	@IBOutlet var contrastSlider: UISlider!
	@IBOutlet var saturationSlider: UISlider!
	@IBOutlet var imageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

        // Give me the image out of the storyboard as the original image
        originalImage = imageView.image
	}
    
    // Helper function
    private func filterImage(_ image: UIImage) -> UIImage {
        
        //return the original image if something isn't working
        guard let cgImage = image.cgImage else { return image }

        // setup the filter using a dictionary
        let ciImage = CIImage(cgImage: cgImage)
        
        filter.setValue(ciImage, forKey: kCIInputImageKey) //input image
        filter.setValue(brightnessSlider.value, forKey: kCIInputBrightnessKey)
        filter.setValue(contrastSlider.value, forKey: kCIInputContrastKey)
        filter.setValue(saturationSlider.value, forKey: kCIInputSaturationKey)
        
        // Get output image
        guard let outputCIImage = filter.outputImage else { return image }
        
        // Render the output - going back to core graphics, input the output image and give it the size of the original image, because sometimes we get extra data outside of the image and it can make the image look smaller
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: CGPoint.zero, size: image.size)) else { return image }
        
        
        return UIImage(cgImage: outputCGImage)
    }
	
	// MARK: Actions
	
	@IBAction func choosePhotoButtonPressed(_ sender: Any) {
		// show the photo picker so we can choose on-device photos
		// UIImagePickerController + Delegate
        presentImagePickerController()
        
	}
    
    // helper function to present image picker
    private func presentImagePickerController() {
        // look for the photo library
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The source type is unavailable.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
	
	@IBAction func savePhotoButtonPressed(_ sender: UIButton) {

		// Setup permissions for privacy
        
        guard let originalImage = originalImage else { return }
        let processedImage = filterImage(originalImage.flattened)
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else { return }
            // Let the library know we are going to make changes
            PHPhotoLibrary.shared().performChanges({
                // Make a new photo creation request
                PHAssetCreationRequest.creationRequestForAsset(from: processedImage)
            }, completionHandler: { (success, error) in
                if let error = error {
                    NSLog("Error saving photo: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    print("Saved image!")
                }
            })
        }

	}
	

	// MARK: Slider events
    

	
	@IBAction func brightnessChanged(_ sender: UISlider) {
        updateImage()
	}
	
	@IBAction func contrastChanged(_ sender: Any) {
        updateImage()
	}
	
	@IBAction func saturationChanged(_ sender: Any) {
        updateImage()
	}
    
        // function to apply to all three function
    private func updateImage() {
        //upwrap the original image
        if let scaledImage = scaledImage {
        imageView.image = filterImage(scaledImage)
        } else {
            imageView.image = nil
        }
    }
}

extension PhotoFilterViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // implement actual selection of the image, dictionary of attributes
        
        if let image = info[.editedImage] as? UIImage { // .originalImage, if there is no edited image
            originalImage = image
        } else if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PhotoFilterViewController: UINavigationControllerDelegate {
    
}
