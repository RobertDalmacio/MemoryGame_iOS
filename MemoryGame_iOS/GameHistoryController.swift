import UIKit

class GameHistoryController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var gameHistoryTableView: UITableView!
    @IBOutlet weak var movesCompletedBtn: UIButton!
    @IBOutlet weak var completionTimeBtn: UIButton!
    @IBOutlet weak var easyBtn: UIButton!
    @IBOutlet weak var mediumBtn: UIButton!
    @IBOutlet weak var hardBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    
    // MARK: - Properties
    
    var originalGameHistoryList: [GameHistory] = []  // original and unfiltered list
    var filteredGameHistoryList: [GameHistory] = []  // filtered and sorted list
    
    // MARK: - Filter State
    
    var movesCompletedSelected = true
    var completionTimeSelected = false
    var allDifficultySelected = true
    var easyDifficultySelected = false
    var mediumDifficultySelected = false
    var hardDifficultySelected = false
        
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameHistory()
        updateTable()  // initial filtering and sorting
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView :UITableView ,numberOfRowsInSection section:Int ) ->Int {
        return filteredGameHistoryList.count
    }
        
    func tableView(_ tableView:UITableView ,cellForRowAt indexPath :IndexPath ) ->UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier :"gameHistoryCellID") as! GameHistoryCell
        
        let thisGameHistory = filteredGameHistoryList[indexPath.row]
        
        tableViewCell.numberOfMovesLabel.text = "Moves: "+thisGameHistory.numberOfMoves
        
        tableViewCell.dateCompletedLabel.text = thisGameHistory.dateCompleted
        
        tableViewCell.completionTimeLabel.text = "Duration: "+thisGameHistory.completionTime
        
        tableViewCell.gameDifficultyLabel.text = thisGameHistory.gameDifficulty
        
        return tableViewCell
    }
    
    // MARK: - Data Loading
    
    private func loadGameHistory() {
        // initialzie gameHistorList
        originalGameHistoryList.removeAll()
        
        // get number of games saved
        let numGamesPlayed = UserDefaults.standard.integer(forKey: NUM_GAMES)
        
        // loop over all saved games
        if numGamesPlayed > 0 {
            for gameNumber in 1...numGamesPlayed {
                let completionTime = UserDefaults.standard.string(forKey: COMPLETION_TIME + String(gameNumber)) ?? ""
                let dateTime = UserDefaults.standard.object(forKey: DATE_TIME + String(gameNumber)) as? Date ?? Date()
                let numberOfMoves = UserDefaults.standard.integer(forKey: NUM_OF_MOVES + String(gameNumber))
                let gameDifficulty = UserDefaults.standard.string(forKey: GAME_DIFFICULTY + String(gameNumber)) ?? ""
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
                let dateCompleted = dateFormatter.string(from: dateTime)
                
                let gameHistory = GameHistory(
                    numberOfMoves: String(numberOfMoves),
                    completionTime: completionTime,
                    gameDifficulty: gameDifficulty,
                    dateCompleted: dateCompleted
                )
                
                // add saved game to list
                originalGameHistoryList.append(gameHistory)
            }
        }
        
        // set filtered list the same as original
        filteredGameHistoryList = originalGameHistoryList
        
        // refresh table view data
        gameHistoryTableView.reloadData()
    }
    
    //MARK: - IBActions
    
    @IBAction func clearGameDataMenuBtnClicked(_ sender: Any) {
        // confirmation message
        let alert = UIAlertController(title: "Clear Game Data", message: "Are you sure you want to delete all recent game data? This action cannot be undone.", preferredStyle: .alert)
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
            // clear all saved games
            self.clearGameData()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func filterButtonsClicked(_ sender:UIButton ) {
        // return if button does not have text for title table
        guard let buttonText = sender.titleLabel?.text else { return }
                
        switch buttonText {
            case"MOVES COMPLETED":
                // only filter if movesCompletedBtn was not selected
                if !movesCompletedSelected {
                    // change the btn image to selected version
                    toggleSelection(for:&movesCompletedSelected ,button:movesCompletedBtn ,selectedImageName:"button_game_history_moves_completed_selected" ,defaultImageName:"button_game_history_moves_completed")
                    // set other sorting btn state to false
                    completionTimeSelected=false
                    // set other sorting btn image to default
                    completionTimeBtn.setImage(UIImage(named :"button_game_history_completion_time") ,for:.normal)
                }
            case"COMPLETION TIME":
                // only filter if completionTimeBtn was not selected
                if !completionTimeSelected {
                    // change the btn image to selected version
                    toggleSelection(for:&completionTimeSelected ,button :completionTimeBtn ,selectedImageName :"button_game_history_completion_time_selected" ,defaultImageName :"button_game_history_completion_time")
                    // set other sorting btn state to false
                    movesCompletedSelected=false
                    // set other sorting btn image to default
                    movesCompletedBtn.setImage(UIImage(named :"button_game_history_moves_completed") ,for:.normal)
                }
            case"EASY":
                selectDifficulty("easy" ,easyBtn )
            case"MEDIUM":
                selectDifficulty("medium" ,mediumBtn )
            case"HARD":
                selectDifficulty("hard" ,hardBtn )
            default:
                selectDifficulty(nil, allBtn)
        }
         
        // run filter and sorting based on selected btns
        updateTable()
    }
    
    // MARK: - Helper Methods
    
    /// toggles the selection state of a button and updates its image
    func toggleSelection(for flag :inout Bool ,button:UIButton ,selectedImageName:String ,defaultImageName:String ) {
        flag.toggle()
        let imageName=flag ? selectedImageName :defaultImageName
        // update btn image
        button.setImage(UIImage(named:imageName) ,for:.normal)
    }
     
    /// updates the difficulty selection and button images
    func selectDifficulty(_ difficulty:String? ,_ selectedButton:UIButton ) {
        // update selected difficulty state
       easyDifficultySelected=(difficulty=="easy")
       mediumDifficultySelected=(difficulty=="medium")
       hardDifficultySelected=(difficulty=="hard")
       allDifficultySelected=(difficulty==nil)
       
        // update filter btns images
       easyBtn.setImage(UIImage(named :easyDifficultySelected ?"button_game_history_easy_selected" :"button_game_history_easy") ,for :.normal)
       mediumBtn.setImage(UIImage(named :mediumDifficultySelected ?"button_game_history_medium_selected" :"button_game_history_medium") ,for :.normal)
       hardBtn.setImage(UIImage(named :hardDifficultySelected ?"button_game_history_hard_selected" :"button_game_history_hard") ,for :.normal)
       allBtn.setImage(UIImage(named :allDifficultySelected ?"button_game_history_all_selected" :"button_game_history_all") ,for :.normal)
    }
    
    /// returns the currently selected difficulty
    func currentDifficulty() ->String? {
       if easyDifficultySelected { return"easy"}
       if mediumDifficultySelected { return"medium"}
       if hardDifficultySelected { return"hard"}
       return nil
    }
    
    // MARK: - Data Management
               
    /// updates the table view with filtered and sorted data
    func updateTable() {
        // start with the original list
       filteredGameHistoryList=originalGameHistoryList
       
       // apply difficulty filter
       if let difficulty=currentDifficulty() {
           filteredGameHistoryList=filteredGameHistoryList.filter { $0.gameDifficulty==difficulty }
       }
       
       // apply sorting
       if movesCompletedSelected {
           // sort based on number of moves
           filteredGameHistoryList.sort { Int($0.numberOfMoves)!<Int($1.numberOfMoves)! }
       } else if completionTimeSelected {
           // sort based on completion time
           filteredGameHistoryList.sort { (game1, game2) -> Bool in
               let components1 = game1.completionTime.components(separatedBy: ":")
               let components2 = game2.completionTime.components(separatedBy: ":")
               
               guard components1.count == 3, components2.count == 3,
                     let hours1 = Int(components1[0]), let minutes1 = Int(components1[1]), let seconds1 = Int(components1[2]),
                     let hours2 = Int(components2[0]), let minutes2 = Int(components2[1]), let seconds2 = Int(components2[2]) else {
                   return false
               }
               
               let totalSeconds1 = hours1 * 3600 + minutes1 * 60 + seconds1
               let totalSeconds2 = hours2 * 3600 + minutes2 * 60 + seconds2
               
               return totalSeconds1 < totalSeconds2
           }
       }
       
        // refresh table view data
        gameHistoryTableView.reloadData()
    }
    
    /// clears all saved game data
    func clearGameData() {
        let userDefaults = UserDefaults.standard
        let numGamesPlayed = userDefaults.integer(forKey: NUM_GAMES)
        
        // remove all saved game data
        for gameNumber in 1...numGamesPlayed {
            userDefaults.removeObject(forKey: COMPLETION_TIME + String(gameNumber))
            userDefaults.removeObject(forKey: DATE_TIME + String(gameNumber))
            userDefaults.removeObject(forKey: NUM_OF_MOVES + String(gameNumber))
            userDefaults.removeObject(forKey: GAME_DIFFICULTY + String(gameNumber))
        }
        
        // reset the number of games played
        userDefaults.set(0, forKey: NUM_GAMES)
        
        // synchronize to ensure changes are saved
        userDefaults.synchronize()
        
        // reload table data with no data
        loadGameHistory()
    }
}
