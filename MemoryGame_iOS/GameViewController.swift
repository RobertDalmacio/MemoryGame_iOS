//
//  GameViewController.swift
//  MemoryGame
//
//  Created by Chaoyi Wu on 2024-10-23.
//

import UIKit

class GameViewController: UIViewController {

    var difficulty: GameDifficulty = .easy
    var cardTotal: Int = getCardTotal(difficulty: .easy)
    var cardArts = [String]()
    var cards = [GameCard]()
    var facedUpCards = 0
    var timeElapsed: Int = 0
    var movesMade: Int = 0
    
    var timer: Timer?
    
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var movesMadeLabel: UILabel!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("selected game mode: " + difficulty.rawValue)
        
        cardTotal = getCardTotal(difficulty: difficulty)
        print("total number of cards: " + String(cardTotal))
        
        initGameCards()
        
        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
    }
    
    private func initGameCards() {
        cardArts = [String]()
        cards = [GameCard]()
        
        let numbers = getNumberOfRandomNum(number: cardTotal/2, lower: 1, upper: 12)
        for num in numbers {
            cardArts.append(defaultIconName + String(num))
            cardArts.append(defaultIconName + String(num))
        }
        cardArts.shuffle()
        for i in 0..<cardTotal {
            cards.append(GameCard(position: i, isMatched: false, isFaceUp: false))
        }
    }
    
    private func getNumberOfRandomNum(number: Int, lower: Int, upper: Int) -> Array<Int> {
        var numbers = [Int]()
        for _ in 1 ... number {
            var num = Int.random(in: lower...upper)
            while (numbers.contains(num)){
                num = Int.random(in: lower...upper)
            }
            numbers.append(num)
        }
        return numbers
    }
    
    @IBAction func restartGame(_ sender: UIBarButtonItem) {
        initGameCards()
        stopTimer()
        updateTimeElapsed(time: 0)
        updateMoves(moves: 0)
        
        for i in 0...cardTotal-1 {
                let cell = cardCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! CardCollectionViewCell
                cell.CardArtImageView.image = cardBackgroundImage
        }
    }
    
    private func updateTimeElapsed(time: Int){
        timeElapsed = time
        timeElapsedLabel.text = timeElapsedText + String(timeElapsed)
    }
    private func updateMoves(moves: Int){
        movesMade = moves
        movesMadeLabel.text = movesText + String(movesMade)
    }
    
    func scheduledTimerWithTimeInterval() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        updateTimeElapsed(time: timeElapsed+1)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension GameViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardTotal
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        cell.CardArtImageView.image = cardBackgroundImage
        
        return cell
    }
}

extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Tapped on card at \(indexPath.row), \(indexPath.section)")
            
        // Check if the card is already faced up
        if  cards[indexPath.row].isFaceUp {
            return
        }
        
        updateMoves(moves: movesMade+1)
        if (movesMade == 1) { // starts timer if this the first move the player made
            scheduledTimerWithTimeInterval()
        }
            
        // turn the tapped card faced up and update the view
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
            facedUpCards += 1
        cards[indexPath.row].isFaceUp = true
        cell.CardArtImageView.image = UIImage(named: cardArts[indexPath.row])
            
        // additional logic for handling cards facing up
        if facedUpCards >= 3 {
            print("too many cards facing up")
            for i in 0..<cards.count {
                if i != indexPath.row && !cards[i].isMatched && cards[i].isFaceUp {
                    cards[i].isFaceUp = false
                    let indexPath = IndexPath(row: i, section: 0)
                    if let cellToChange = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell {
                        cellToChange.CardArtImageView.image = UIImage(named: "background_card")
                    }
                }
            }
            facedUpCards = 1
        } else {
            for i in 0..<cards.count {
                if i != indexPath.row && cards[i].isFaceUp && cardArts[i] == cardArts[indexPath.row] {
                    print("match found")
                    cards[indexPath.row].isMatched = true
                    cards[i].isMatched = true
                    facedUpCards = 0
                }
            }
            
            var matchedCards = 0
            for i in 0..<cards.count{
                if cards[i].isMatched {
                    matchedCards+=1
                }
            }
            
            if matchedCards == cards.count { // game is successfully completed
                stopTimer()
                
                let alertController = UIAlertController(title: "Yay!", message: "You have successfully completed the level in \(timeElapsed) seconds!", preferredStyle: .alert)

                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    alertController.dismiss(animated: true)
                }

                alertController.addAction(okAction)

                present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = CGFloat(getWidth(difficulty: difficulty))
        let collectionViewWidth = collectionView.bounds.width-10
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweenCells = flowLayout.minimumInteritemSpacing * (columns - 1)
        let adjustedWidth = collectionViewWidth - spaceBetweenCells
        var width: CGFloat = adjustedWidth / columns
        switch difficulty {
            case .easy:
                width -= 40
                break
            case .medium:
                width -= 25
                break
            default:
                break
        }
        let height: CGFloat = width + 10
        
        return CGSize(width: width, height: height)
    }
}
