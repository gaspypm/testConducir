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
        questions.shuffle()
        displayQuestion()
    }

    func loadQuestionsFromCSV() {
        if let path = Bundle.main.path(forResource: "questions", ofType: "csv") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let rows = data.components(separatedBy: "\n")
                var questionNumber = 1
                for row in rows {
                    let columns = row.components(separatedBy: ";")
                    if columns.count == 8 {
                        let category = columns[1]
                        let question = columns[2]
                        let answer1 = columns[3]
                        let answer2 = columns[4]
                        let answer3 = columns[5].isEmpty ? nil : columns[5]
                        let correctAnswerIndex = Int(columns[6]) ?? 0
                        let imageFileName = columns[7].isEmpty ? nil : columns[7]
                        var answers: [String] = [answer1, answer2]
                        if let answer3 = answer3 {
                            answers.append(answer3)
                        }
                        questions.append(Question(questionNumber: questionNumber, category: category, text: question, answers: answers, correctAnswerIndex: correctAnswerIndex, imageFileName: imageFileName))
                        questionNumber += 1
                    }
                }
                questions.shuffle()
            } catch {
                print("Error loading CSV file: \(error)")
            }
        } else {
            print("CSV file not found")
        }
    }



    func displayQuestion() {
        let currentQuestion = questions[currentQuestionIndex]
        questionLabel.text = "\(currentQuestion.text)"
        for (index, answer) in currentQuestion.answers.enumerated() {
            if answer.isEmpty {
                answerButtons[index].setTitle("", for: .normal)
            } else {
                answerButtons[index].setTitle(answer, for: .normal)
            }
        }

        // Clear the text of the answer buttons that are not used
        for index in currentQuestion.answers.count..<answerButtons.count {
            answerButtons[index].setTitle("", for: .normal)
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
    @IBOutlet weak var questionCounterLabel: UILabel!
    
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
