import UIKit

class MainMenuController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var EasyMode: UIButton!
    @IBOutlet weak var MediumMode: UIButton!
    @IBOutlet weak var HardMode: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EasyMode.setImage(UIImage(named: "button_easy_selected"), for: .normal)
        MediumMode.setImage(UIImage(named: "button_medium"), for: .normal)
        HardMode.setImage(UIImage(named: "button_hard"), for: .normal)
    }
    
    //MARK:- IBActions
    @IBAction func EasyModeClicked(_ sender: UIButton) {
        // check the current image of the button
        if let currentImage = EasyMode.image(for: .normal),
           let selectedImage = UIImage(named: "button_easy"),
           currentImage.isEqual(selectedImage) {
            
            EasyMode.setImage(UIImage(named: "button_easy_selected"), for: .normal)
            MediumMode.setImage(UIImage(named: "button_medium"), for: .normal)
            HardMode.setImage(UIImage(named: "button_hard"), for: .normal)
        }
    }
    
    @IBAction func MediumModeClicked(_ sender: UIButton) {
        // check the current image of the button
        if let currentImage = MediumMode.image(for: .normal),
           let selectedImage = UIImage(named: "button_medium"),
           currentImage.isEqual(selectedImage) {
            
            EasyMode.setImage(UIImage(named: "button_easy"), for: .normal)
            MediumMode.setImage(UIImage(named: "button_medium_selected"), for: .normal)
            HardMode.setImage(UIImage(named: "button_hard"), for: .normal)
        }
    }
    
    @IBAction func HardModeClicked(_ sender: UIButton) {
        // check the current image of the button
        if let currentImage = HardMode.image(for: .normal),
           let selectedImage = UIImage(named: "button_hard"),
           currentImage.isEqual(selectedImage) {
            
            EasyMode.setImage(UIImage(named: "button_easy"), for: .normal)
            MediumMode.setImage(UIImage(named: "button_medium"), for: .normal)
            HardMode.setImage(UIImage(named: "button_hard_selected"), for: .normal)
        }
    }
    
    
    

    
    
    
    
    
}

