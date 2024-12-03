import UIKit

class GameHistoryCell : UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var numberOfMovesLabel: UILabel!
    @IBOutlet weak var dateCompletedLabel: UILabel!
    @IBOutlet weak var completionTimeLabel: UILabel!
    @IBOutlet weak var gameDifficultyLabel: UILabel!
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let spacing: CGFloat = 10 // horizontal spacing between cells
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: spacing/2, left: 0, bottom: spacing/2, right: 0))
    }
    
}
