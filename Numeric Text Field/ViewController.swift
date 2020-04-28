import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    static let maxValue = 999_999_999_999_999_999
    static let maxDigit = String(maxValue).count
    static let tagJustDelegate = 100
    static let tagDelegateWithAction = 200

    override func viewDidLoad() {
        super.viewDidLoad()

        with(setupTextFiled(placeholder: "editingChange", yPos: 100)) {
            $0.addTarget(self, action: #selector(self.editingChanged), for: .editingChanged)
        }
        with(setupTextFiled(placeholder: "delegate", yPos: 200)) {
            $0.delegate = self
            $0.tag = ViewController.tagJustDelegate
        }
        with(setupTextFiled(placeholder: "delegate + editingChange", yPos: 300)) {
            $0.addTarget(self, action: #selector(self.joinChange), for: .editingChanged)
            $0.delegate = self
            $0.tag = ViewController.tagDelegateWithAction
        }
    }

    private var lastValue = ""
    @objc private func editingChanged(_ textField: UITextField) {
        if let number = Decimal(string: textField.text!.filter { $0.isWholeNumber }) {
            if (number <= Decimal(ViewController.maxValue)) {
                lastValue = "\(number)"
            }
            textField.text = lastValue
        } else {
            textField.text = ""
        }
    }

    @objc private func joinChange(_ textField: UITextField) {
        if let num = Int(textField.text!) {
            textField.text = "\(num)"
        } else {
            textField.text = ""
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch(textField.tag) {
        case ViewController.tagJustDelegate:
            if (textField.text!.count >= ViewController.maxDigit && !string.isEmpty) {
                return false
            }
            let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
            if (string.rangeOfCharacter(from: invalidCharacters) == nil) {
                let mergedString = (textField.text! as NSString)
                    .replacingCharacters(in: range, with: string)
                if let number = Decimal(string: mergedString) {
                    textField.text = "\(number)"
                    return false
                }
                return true
            }
            return false
        case ViewController.tagDelegateWithAction:
            if (textField.text!.count >= ViewController.maxDigit && !string.isEmpty) {
                return false
            }
            let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
            return (string.rangeOfCharacter(from: invalidCharacters) == nil)
        default:
            return true
        }
    }

    private func setupTextFiled(placeholder: String, yPos: Int, providedView: UITextField? = nil) -> UITextField {
        let textField = providedView ?? UITextField()
        textField.placeholder = placeholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4.0
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(yPos)),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50.0),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50.0),
            textField.heightAnchor.constraint(equalToConstant: 30)
        ])
        return textField
    }
}

public func with<T: AnyObject>(_ object: T, block: (T) -> Void) {
    block(object)
}
