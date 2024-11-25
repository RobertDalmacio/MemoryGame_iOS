import Foundation

class GameHistory {
    var numberOfMoves : String!
    var completionTime : String!
    var gameDifficulty : String!
    var dateCompleted : String!
    
    public init(
        numberOfMoves:String,
        completionTime:String,
        gameDifficulty:String,
        dateCompleted:String
    ) {
        self.numberOfMoves = numberOfMoves
        self.completionTime = completionTime
        self.gameDifficulty = gameDifficulty
        self.dateCompleted = dateCompleted
    }
    
}
