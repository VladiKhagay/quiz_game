//
//  ViewController.swift
//  quiz_game
//
//  Created by Vladi Khagay on 12/05/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var play_BTN: UIButton!
    @IBOutlet weak var recentScore_LBL: UILabel!
    
    var viewModel: GameViewModel = GameViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        if viewModel.getRecentScore() != nil {
            print(viewModel.getRecentScore())
            recentScore_LBL.text = "Last Game Score : \(viewModel.getRecentScore()!)"
        } else {
            recentScore_LBL.isHidden = true
        }
        
        
    }

    @IBAction func onPlayClicked(_ sender: Any) {


        guard let vc = storyboard?.instantiateViewController(withIdentifier: "quiz_view_controller") as? QuizViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
}
