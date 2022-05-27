import Foundation



class GameViewModel {
    
    private let RECENT_SCORE_KEY: String = "recent_key"
    var isGameOver: Bool = false
    var questions: [Question]?
    var currentQuestion: Question?
    var answers: [String]?
    var progressCount: Int = 0
    var lives: Int = 0
    var score: Int = 0
    var defaults =  UserDefaults.standard
    
    
    func Init() {
        questions = []
        answers = []
        isGameOver = false
        progressCount = 0
        lives = 3
        
    }
    
    
    func setQuestion(questions: [Question]) {
        self.questions = questions
    }
    
    func InitGame() {
        self.questions?.shuffle()
        self.isGameOver = false
        self.currentQuestion = self.questions?[0]
        self.answers = []
        self.progressCount = 1
        self.lives = 3
        self.score = 0
    }
    
    func getCurrentQuestion() -> (question:Question?, answers: [String]?) {
        if (self.currentQuestion != nil && self.answers != nil) {
            answers = currentQuestion!.incorrect_answers
            answers!.append(currentQuestion!.correct_answer!)
            answers!.shuffle()
        }
        return (currentQuestion, answers)
    }
    
    func isRightAnswer(answer: Int) -> Bool{
        var result: Bool = false
        if answers != nil && answer < answers!.count{
            result  = (answers![answer] == currentQuestion?.correct_answer)
        }
        
        self.handleAnswer(isRight: result)
        
        return result
    }
    
    private func handleAnswer (isRight: Bool) {
        
        if (isRight == true) {
            self.score += 1
            
            // load nex question
            if (self.progressCount == self.questions!.count) {
                self.isGameOver = true
            } else {
                self.progressCount += 1
                currentQuestion! =  self.questions![self.progressCount - 1]
                
            }
            
        } else {
            self.lives -= 1
            if (self.lives > 0) {
                // load next question
                if (self.progressCount == self.questions!.count) {
                    self.isGameOver = true
                } else {
                    self.progressCount += 1
                    currentQuestion! =  self.questions![self.progressCount - 1]
                    
                }
                
            } else {
                self.isGameOver = true
            }
        }
        
    }
    
    func getIsGameOver() -> Bool {
        return self.isGameOver
    }
    
    func getQuestionsSize() -> Int {
        
        var size  = 0
        if self.questions != nil {
            size = self.questions!.count
        }
        
        return size
        
    }
    
    func getScore() -> Int{
        return self.score
    }
    
    func getRecentScore() -> Int?{
        return defaults.integer(forKey: RECENT_SCORE_KEY)
    }
    
    func saveScore() {
        print(self.score)
        defaults.set(self.score, forKey: RECENT_SCORE_KEY)
        
    }
    
    
}
