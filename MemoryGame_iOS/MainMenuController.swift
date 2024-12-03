import UIKit

class MainMenuController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var EasyMode: UIButton!
    @IBOutlet weak var MediumMode: UIButton!
    @IBOutlet weak var HardMode: UIButton!
    
    // MARK: - Constants
    
    private let segueIdentifier = "showGameBoard"
    
    // MARK: - Properties
    
    private var selectedDifficulty: GameDifficulty = .easy
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EasyMode.setImage(UIImage(named: "button_easy_selected"), for: .normal)
        MediumMode.setImage(UIImage(named: "button_medium"), for: .normal)
        HardMode.setImage(UIImage(named: "button_hard"), for: .normal)
    }
    
    //MARK: - IBActions
    
    @IBAction func EasyModeClicked(_ sender: UIButton) {
        updateDifficultySelection(difficulty: .easy)
    }
    
    @IBAction func MediumModeClicked(_ sender: UIButton) {
        updateDifficultySelection(difficulty: .medium)
    }
    
    @IBAction func HardModeClicked(_ sender: UIButton) {
        updateDifficultySelection(difficulty: .hard)
    }
    
    // MARK: - Helper Methods
    
    private func updateDifficultySelection(difficulty: GameDifficulty) {
        selectedDifficulty = difficulty
        
        // update button images based on selected difficulty
        EasyMode.setImage(UIImage(named: difficulty == .easy ? "button_easy_selected" : "button_easy"), for: .normal)
        MediumMode.setImage(UIImage(named: difficulty == .medium ? "button_medium_selected" : "button_medium"), for: .normal)
        HardMode.setImage(UIImage(named: difficulty == .hard ? "button_hard_selected" : "button_hard"), for: .normal)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier,
           let gameViewController = segue.destination as? GameViewController {
            gameViewController.difficulty = selectedDifficulty
        }
    }
}

