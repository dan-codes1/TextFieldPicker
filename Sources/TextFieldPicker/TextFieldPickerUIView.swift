//
//  TextFieldPickerUIView.swift
//  
//
//  Created by Daniel Eze on 2024-10-04.
//
import Foundation
import UIKit

public final class TextFieldPickerUIView: UIView {
    public var delegate: TextFieldPickerDelegate?
    public var selectionUpdateMode: TextFieldPickerSelectionUpdateMode = .onSelect
    public var font: UIFont? {
        didSet {
            textField.font = font
        }
    }
    public var placeHolder: String? {
        didSet {
            textField.placeholder = placeHolder
        }
    }
    public var textFieldBoarderStyle: UITextField.BorderStyle {
        didSet {
            textField.borderStyle = textFieldBoarderStyle
        }
    }

    private var selectedRow: Int = 0

    private lazy var picker: UIPickerView = {
        let view = UIPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        return view
    }()

    private lazy var textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        field.borderStyle = textFieldBoarderStyle
        field.placeholder = placeHolder
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(removePicker))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        field.inputAccessoryView = toolbar
        return field
    }()

    init() {
        self.textFieldBoarderStyle = .none
        super.init(frame: .zero)
        self.configure()
        self.layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension TextFieldPickerUIView {
    func configure() {
        textField.inputView = picker
    }
    
    func layout() {
        addSubview(textField)
        let constraints: [NSLayoutConstraint] = [
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @objc func removePicker() {
        endEditing(true)
    }
}

extension TextFieldPickerUIView: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.picker(self, didSelectItemAtRow: selectedRow)
        if let title = delegate?.picker(self, titleForRow: selectedRow) {
            textField.text = title
        }
    }
}

extension TextFieldPickerUIView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        if selectionUpdateMode == .onSelect {
            delegate?.picker(self, didSelectItemAtRow: selectedRow)
        }
        if let title = delegate?.picker(self, titleForRow: selectedRow) {
            textField.text = title
        }
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        delegate?.picker(self, titleForRow: row)
    }
}

extension TextFieldPickerUIView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        delegate?.numberOfItems(self) ?? 0
    }

}
