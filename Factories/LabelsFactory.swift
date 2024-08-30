//
//  LabelsFactory.swift
//  ToDoList
//
//  Created by Александра Сергеева on 29.08.2024.
//

import UIKit

struct LabelsFactory {
    static func createLabel(with text: String? = nil, isTextBold: Bool = false, textSize: CGFloat = 19) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: textSize, weight: isTextBold ? .semibold : .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        return label
    }
}
