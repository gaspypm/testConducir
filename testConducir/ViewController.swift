import UIKit

struct Question {
    let text: String
    let answers: [String]
    let correctAnswerIndex: Int
}

class ViewController: UIViewController {

    var currentQuestionIndex = 0
    var score = 0

    var questions: [Question] = [
        Question(text: "Según Ley N°2265, ¿Cuándo debe realizar la primer VTV un automóvil 0km radicado en CABA?",
                 answers: ["Pasados los 3 años de antigüedad, en el mes que le corresponda, o superados los 60.000 km",
                           "Inmediatamente al retirarlo de la agencia",
                           "En el mes que le corresponda, inmediatamente seguido al año transcurrido"],
                 correctAnswerIndex: 0),
        Question(text: "En materia de Responsabilidad Civil, ¿qué es lo que se considera como factor determinante para dar inicio a una demanda?",
                 answers: ["La intención de la conducta dañosa",
                           "La existencia de un daño real, que afecte a algún particular, provocado como consecuencia del incidente",
                           "Los antecedentes de la persona que provoca el daño"],
                 correctAnswerIndex: 1),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        displayQuestion()
    }

    func displayQuestion() {
        let currentQuestion = questions[currentQuestionIndex]
        questionLabel.text = currentQuestion.text
        for (index, answer) in currentQuestion.answers.enumerated() {
            answerButtons[index].setTitle(answer, for: .normal)
        }
    }

    func checkAnswer(selectedAnswerIndex: Int) {
        let currentQuestion = questions[currentQuestionIndex]
        if selectedAnswerIndex == currentQuestion.correctAnswerIndex {
            score += 1
            scoreLabel.text = "Score: " + String(score)
        }
        
        currentQuestionIndex += 1
        if currentQuestionIndex < questions.count {
            displayQuestion()
        } else {
            currentQuestionIndex = 0
        }
    }

    // UI Elements
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    @IBOutlet var scoreLabel: UILabel!
    
    @IBAction func answerButton1Tapped(_ sender: UIButton) {
        checkAnswer(selectedAnswerIndex: 0)
    }

    @IBAction func answerButton2Tapped(_ sender: UIButton) {
        checkAnswer(selectedAnswerIndex: 1)
    }
    
    @IBAction func answerButton3Tapped(_ sender: UIButton) {
        checkAnswer(selectedAnswerIndex: 2)
    }
}
