//
//  EditTaskContainerView.swift
//  ToDoList
//
//  Created by Александра Сергеева on 30.08.2024.
//

import UIKit

final class EditTaskContainerView: UIView {
    lazy var taskTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Fill title"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.textAlignment = .justified
        textField.becomeFirstResponder()
        textField.font = .systemFont(ofSize: 19, weight: .semibold)
        return textField
    }()
    
    lazy var taskTextTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.1).cgColor
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        textView.font = .systemFont(ofSize: 19, weight: .regular)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.textAlignment = .justified
        return textView
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = LabelsFactory.createLabel(with: "Describe task")
        label.textColor = .lightGray.withAlphaComponent(0.7)
        return label
    }()
    
    lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        return alert
    }()
    
    private let offsetForConstraints: CGFloat = 16
    
    init(textFieldDelegate: UITextFieldDelegate, textViewDelegate: UITextViewDelegate) {
        super.init(frame: .zero)
        self.taskTitleTextField.delegate = textFieldDelegate
        self.taskTextTextView.delegate = textViewDelegate
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EditTaskContainerView {
    func setupViews() {
        addSubview(taskTextTextView)
        addSubview(taskTitleTextField)
        addSubview(placeholderLabel)
        
        backgroundColor = .systemBackground
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        let constraints = [
            taskTitleTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: offsetForConstraints),
            taskTitleTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: offsetForConstraints),
            taskTitleTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -offsetForConstraints),
            
            taskTextTextView.topAnchor.constraint(equalTo: taskTitleTextField.bottomAnchor, constant: offsetForConstraints),
            taskTextTextView.leadingAnchor.constraint(equalTo: taskTitleTextField.leadingAnchor),
            taskTextTextView.trailingAnchor.constraint(equalTo: taskTitleTextField.trailingAnchor),
            taskTextTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            placeholderLabel.topAnchor.constraint(equalTo: taskTextTextView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: taskTextTextView.leadingAnchor, constant: 8),
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
