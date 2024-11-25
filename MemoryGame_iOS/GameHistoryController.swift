import UIKit

class GameHistoryController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var gameHistoryTableView: UITableView!
    @IBOutlet weak var movesCompletedBtn: UIButton!
    @IBOutlet weak var completionTimeBtn: UIButton!
    @IBOutlet weak var easyBtn: UIButton!
    @IBOutlet weak var mediumBtn: UIButton!
    @IBOutlet weak var hardBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    
    var originalGameHistoryList: [GameHistory] = []  // original and unfiltered list
    var filteredGameHistoryList: [GameHistory] = []  // filtered and sorted list
    var movesCompletedSelected = true
    var completionTimeSelected = false
    var allDifficultySelected = true
    var easyDifficultySelected = false
    var mediumDifficultySelected = false
    var hardDifficultySelected = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()
        updateTable()  // initial filtering and sorting
    }
        
    func loadInitialData() {
        let games = [
            GameHistory(numberOfMoves: "15", completionTime: "00:05:12", gameDifficulty: "Easy", dateCompleted: "11/15/2024 14:23:12"),
            GameHistory(numberOfMoves: "50", completionTime: "00:25:52", gameDifficulty: "Hard", dateCompleted: "11/15/2024 14:23:12"),
            GameHistory(numberOfMoves: "32", completionTime: "00:11:43", gameDifficulty: "Medium", dateCompleted: "11/15/2024 14:23:12"),
            GameHistory(numberOfMoves: "8", completionTime: "00:02:02", gameDifficulty: "Easy", dateCompleted: "11/15/2024 14:23:12"),
            GameHistory(numberOfMoves: "75", completionTime: "00:23:42", gameDifficulty: "Hard", dateCompleted: "11/15/2024 14:23:12"),
            GameHistory(numberOfMoves: "11", completionTime: "00:07:56", gameDifficulty: "Easy", dateCompleted: "11/15/2024 14:23:12"),
            GameHistory(numberOfMoves: "53", completionTime: "00:19:48", gameDifficulty: "Hard", dateCompleted: "11/15/2024 14:23:12"),
            GameHistory(numberOfMoves: "26", completionTime: "00:03:31", gameDifficulty: "Medium", dateCompleted:"11/15/2024 14:23 :12"),
            GameHistory(numberOfMoves:"9" ,completionTime:"00 :03 :32" ,gameDifficulty:"Easy" ,dateCompleted:"11 /15 /2024 14 :23 :12"),
            GameHistory(numberOfMoves:"145" ,completionTime:"00 :45 :22" ,gameDifficulty:"Hard" ,dateCompleted:"11 /15 /2024 14 :23 :12")
        ]
        
        originalGameHistoryList.append(contentsOf : games)
        filteredGameHistoryList = originalGameHistoryList  // set filtered list the same as original
    }
        
    func tableView(_ tableView :UITableView ,numberOfRowsInSection section:Int ) ->Int {
        return filteredGameHistoryList.count
    }
        
    func tableView(_ tableView:UITableView ,cellForRowAt indexPath :IndexPath ) ->UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier :"gameHistoryCellID") as! GameHistoryCell
        
        let thisGameHistory = filteredGameHistoryList[indexPath.row]
        
        tableViewCell.numberOfMovesLabel.text = "Moves:"+thisGameHistory.numberOfMoves
        
        tableViewCell.dateCompletedLabel.text = thisGameHistory.dateCompleted
        
        tableViewCell.completionTimeLabel.text = "Duration:"+thisGameHistory.completionTime
        
        tableViewCell.gameDifficultyLabel.text = thisGameHistory.gameDifficulty
        
        return tableViewCell
    }
    
    @IBAction func filterButtonsClicked(_ sender:UIButton ) {
        guard let buttonText = sender.titleLabel?.text else { return }
                
        switch buttonText {
            case"MOVES COMPLETED":
                if !movesCompletedSelected {
                    toggleSelection(for:&movesCompletedSelected ,button:movesCompletedBtn ,selectedImageName:"button_game_history_moves_completed_selected" ,defaultImageName:"button_game_history_moves_completed")
                    completionTimeSelected=false
                    completionTimeBtn.setImage(UIImage(named :"button_game_history_completion_time") ,for:.normal)
                }
            case"COMPLETION TIME":
            if !completionTimeSelected {
                toggleSelection(for:&completionTimeSelected ,button :completionTimeBtn ,selectedImageName :"button_game_history_completion_time_selected" ,defaultImageName :"button_game_history_completion_time")
                movesCompletedSelected=false
                movesCompletedBtn.setImage(UIImage(named :"button_game_history_moves_completed") ,for:.normal)
            }
            case"EASY":
                selectDifficulty("Easy" ,easyBtn )
            case"MEDIUM":
                selectDifficulty("Medium" ,mediumBtn )
            case"HARD":
                selectDifficulty("Hard" ,hardBtn )
            default:
                selectDifficulty(nil, allBtn)
        }
                
        updateTable()
    }
                
    func toggleSelection(for flag :inout Bool ,button:UIButton ,selectedImageName:String ,defaultImageName:String ) {
        flag.toggle()
        let imageName=flag ? selectedImageName :defaultImageName
        button.setImage(UIImage(named:imageName) ,for:.normal)
    }
                
    func selectDifficulty(_ difficulty:String? ,_ selectedButton:UIButton ) {
       easyDifficultySelected=(difficulty=="Easy")
       mediumDifficultySelected=(difficulty=="Medium")
       hardDifficultySelected=(difficulty=="Hard")
       allDifficultySelected=(difficulty==nil)
       
       easyBtn.setImage(UIImage(named :easyDifficultySelected ?"button_game_history_easy_selected" :"button_game_history_easy") ,for :.normal)
       mediumBtn.setImage(UIImage(named :mediumDifficultySelected ?"button_game_history_medium_selected" :"button_game_history_medium") ,for :.normal)
       hardBtn.setImage(UIImage(named :hardDifficultySelected ?"button_game_history_hard_selected" :"button_game_history_hard") ,for :.normal)
       allBtn.setImage(UIImage(named :allDifficultySelected ?"button_game_history_all_selected" :"button_game_history_all") ,for :.normal)
    }
               
    func updateTable() {
       filteredGameHistoryList=originalGameHistoryList // Start with the original list
       
       // apply difficulty filter
       if let difficulty=currentDifficulty() {
           filteredGameHistoryList=filteredGameHistoryList.filter { $0.gameDifficulty==difficulty }
       }
       
       // apply sorting
       if movesCompletedSelected {
           filteredGameHistoryList.sort { Int($0.numberOfMoves)!<Int($1.numberOfMoves)! }
       } else if completionTimeSelected {
           let formatter=DateFormatter()
           formatter.dateFormat="HH:mm:ss"
           filteredGameHistoryList.sort {
               let time1=formatter.date(from:$0.completionTime)!
               let time2=formatter.date(from:$1.completionTime)!
               return time1<time2
           }
       }
       
       gameHistoryTableView.reloadData()
    }
               
    func currentDifficulty() ->String? {
       if easyDifficultySelected { return"Easy"}
       if mediumDifficultySelected { return"Medium"}
       if hardDifficultySelected { return"Hard"}
       return nil
    }
}
