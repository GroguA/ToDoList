//
//  EditTaskViewController.swift
//  ToDoList
//
//  Created by Александра Сергеева on 30.08.2024.
//

import UIKit

protocol IEditTaskViewController: AnyObject {
    func showTask(_ task: EditTaskModel)
    func showError(_ error: String)
}

final class EditTaskViewController: UIViewController {
    private lazy var containerView = EditTaskContainerView(
        textFieldDelegate: self,
        textViewDelegate: self
    )
    
    private let presenter: IEditTaskPresenter
    
    init(presenter: IEditTaskPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.didLoad(ui: self)
        setupViews()
    }
    
}

private extension EditTaskViewController {
    func setupViews() {
        navigationItem.title = "Edit task"
    }
}

extension EditTaskViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text as? NSString
        
        guard let updatedText = currentText?.replacingCharacters(in: range, with: string) else {
            return false
        }
        
        if updatedText.isEmpty {
            presenter.taskChanged(title: updatedText, text: containerView.taskTextTextView.text)
            return true
        }
        
        if updatedText.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        presenter.taskChanged(title: updatedText, text: containerView.taskTextTextView.text)
        
        return true
    }
}

extension EditTaskViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text as? NSString
        
        guard let updatedText = currentText?.replacingCharacters(in: range, with: text) else {
            return false
        }
                
        if updatedText.isEmpty {
            presenter.taskChanged(title: containerView.taskTitleTextField.text, text: updatedText)
            return true
        }
        
        if updatedText.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        presenter.taskChanged(title: containerView.taskTitleTextField.text, text: updatedText)
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        containerView.placeholderLabel.isHidden = !textView.text.isEmpty
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        containerView.placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
}

extension EditTaskViewController: IEditTaskViewController {
    func showTask(_ task: EditTaskModel) {
        containerView.taskTitleTextField.text = task.title
        containerView.taskTextTextView.isHidden = false
        containerView.taskTitleTextField.isHidden = false
        if let text = task.text, !text.isEmpty {
            containerView.placeholderLabel.isHidden = true
            containerView.taskTextTextView.text = text
        }
    }
    
    func showError(_ error: String) {
        containerView.taskTextTextView.isHidden = true
        containerView.taskTitleTextField.isHidden = true
        containerView.placeholderLabel.isHidden = true
        containerView.errorAlert.message = error
        present(containerView.errorAlert, animated: true)
    }
    
}
