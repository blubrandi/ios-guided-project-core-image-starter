import UIKit
import CoreImage
import Photos

class PhotoFilterViewController: UIViewController {
    
    // Setup the original image
    var originalImage: UIImage?
    
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
        
        return image // TODO: return the filtered image.  
    }
	
	// MARK: Actions
	
	@IBAction func choosePhotoButtonPressed(_ sender: Any) {
		// TODO: show the photo picker so we can choose on-device photos
		// UIImagePickerController + Delegate
	}
	
	@IBAction func savePhotoButtonPressed(_ sender: UIButton) {

		// TODO: Save to photo library
	}
	

	// MARK: Slider events
	
	@IBAction func brightnessChanged(_ sender: UISlider) {

	}
	
	@IBAction func contrastChanged(_ sender: Any) {

	}
	
	@IBAction func saturationChanged(_ sender: Any) {

	}
}

