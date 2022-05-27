import UIKit
import Kingfisher
import ConfettiView

class QuizViewController: UIViewController {
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var lives_LBL: UILabel!
    @IBOutlet weak var questionsCount_LBL: UILabel!
    @IBOutlet weak var questionText_LBL: UILabel!
    @IBOutlet weak var questionImage_Image: UIImageView!
    
    @IBOutlet weak var option1_BTN: UIButton!
    @IBOutlet weak var option2_BTN: UIButton!
    @IBOutlet weak var option3_BTN: UIButton!
    @IBOutlet weak var option4_BTN: UIButton!
    
    @IBOutlet weak var confetti_VIEW: ConfettiView!
    
    
    
    let apiManager = ApiManager()
    let viewModel = GameViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        confetti_VIEW.isHidden = true
        questionImage_Image.setRoundedImage()
        apiManager.performRequest{
            data in
            self.viewModel.setQuestion(questions: data)
            self.viewModel.InitGame()
            
            DispatchQueue.main.async {
                self.loadQuestion()
                self.setProgressBar()
                self.setLivesCount()
                self.setQuestionsCount()
            }
            
            
        }
        
    }
    
    func loadQuestion() {
        var tempQ : Question
        var ans : [String]
        let result =  self.viewModel.getCurrentQuestion()
        if result.question != nil {
            tempQ = result.question!
            self.questionText_LBL.text = tempQ.question
            let url = URL(string:result.question!.imageUrl ?? "")
            self.questionImage_Image.kf.setImage(with: url)
        }
        
        if result.answers != nil {
            ans = result.answers!
            option1_BTN.setTitle(ans[0], for: [])
            option2_BTN.setTitle(ans[1], for: [])
            option3_BTN.setTitle(ans[2], for: [])
            option4_BTN.setTitle(ans[3], for: [])
        }
        
        
    }
    
    func setProgressBar() {
        
        self.progressBar.setProgress(Float(self.viewModel.progressCount)/Float(self.viewModel.getQuestionsSize()), animated: false)
        
    }
    
    func setLivesCount() {
        lives_LBL.text = "\(self.viewModel.lives) / 3"
    }
    
    func setQuestionsCount() {
        questionsCount_LBL.text = "\(self.viewModel.progressCount) / \(self.viewModel.getQuestionsSize())"
    }
    
    
    @IBAction func onAnswerClicked(_ sender: UIButton) {
        var result: Bool = false
        switch sender.tag {
        case 1:
            result = viewModel.isRightAnswer(answer: sender.tag - 1)
        case 2:
            result = viewModel.isRightAnswer(answer: sender.tag - 1)
        case 3:
            result = viewModel.isRightAnswer(answer: sender.tag - 1)
        case 4:
            result = viewModel.isRightAnswer(answer: sender.tag - 1)
        default:
            print("error")
        }
        
        updateViewAccordingAnswer(result: result, sender: sender)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            sender.tintColor = UIColor.link
            self.handleResult(result: result)
        })
        
        
    }
    
    func updateViewAccordingAnswer(result: Bool, sender: UIButton) {
        DispatchQueue.main.async {
            if (result == true) {
                sender.tintColor = UIColor.green
            } else {
                sender.tintColor = UIColor.red
                
            }
        }
        
    }
    
    func handleResult(result: Bool) {
        if (self.viewModel.getIsGameOver() == false) {
            self.loadQuestion()
            self.setProgressBar()
            self.setLivesCount()
            self.setQuestionsCount()
        } else {
            self.handleGameOver()
        }
    }
    
    
    func handleGameOver() {
        viewModel.saveScore()
        if viewModel.progressCount < viewModel.getQuestionsSize() { // lost the game
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {return}
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        } else { // won the game
            confetti_VIEW.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {return}
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            })
        }
    }
    
}

extension UIImageView {
    func setRoundedImage() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}



