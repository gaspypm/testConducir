import UIKit

struct Question {
    let questionNumber: Int
    let category: String
    let text: String
    let answers: [String]
    let correctAnswerIndex: Int
    let imageFileName: String?

    init(questionNumber: Int, category: String, text: String, answers: [String], correctAnswerIndex: Int, imageFileName: String? = nil) {
        self.questionNumber = questionNumber
        self.category = category
        self.text = text
        self.answers = answers
        self.correctAnswerIndex = correctAnswerIndex
        self.imageFileName = imageFileName
    }
}

class ViewController: UIViewController {

    var currentQuestionIndex = 0
    var score = 0

    var questions: [Question] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestionsFromCSV()
        displayQuestion()
    }

    func loadQuestionsFromCSV() {
        if let path = Bundle.main.path(forResource: "questions", ofType: "csv") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let rows = data.components(separatedBy: .newlines)
                for (index, row) in rows.enumerated() {
                    // Skip the header
                    if index == 0 {
                        continue
                    }
                    
                    let columns = row.split(separator: ";").map { String($0) }
                    if columns.count == 7 || columns.count == 8 {
                        let questionNumber = Int(columns[0]) ?? 0
                        let category = columns[1]
                        let questionText = columns[2]
                        let answers = [columns[3], columns[4], columns[5]]
                        let correctAnswerIndex = Int(columns[6]) ?? 0
                        let imageFileName = columns.count == 8 ? columns[7] : nil
                        questions.append(Question(questionNumber: questionNumber, category: category, text: questionText, answers: answers, correctAnswerIndex: correctAnswerIndex, imageFileName: imageFileName))
                    }
                }
            } catch {
                print("Error loading CSV file: \(error)")
            }
        } else {
            print("CSV file not found")
        }
    }

    func displayQuestion() {
        let currentQuestion = questions[currentQuestionIndex]
        questionLabel.text = "\(currentQuestion.questionNumber). \(currentQuestion.text)"
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
