import Foundation

class GameManager {
    
    var isGameOver: Bool?
    var questions: [Question]?
    var lives: Int
    var defaults =  UserDefaults.standard
    
    
    init() {
        self.lives = 3
        isGameOver = false
        
    }
    
    
    
    
    
    
    
}
