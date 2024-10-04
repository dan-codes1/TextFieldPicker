// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

public struct TextFieldPicker<T>: UIViewRepresentable where T: Identifiable & CustomStringConvertible {
    @Binding private var selectedItem: T?
    private var font: UIFont?
    private var selectedItemUpdateMode: TextFieldPickerSelectionUpdateMode = .onSelect
    private var textFieldStyle: (any TextFieldStyle)?
    private var uiTextFieldStyle: UITextField.BorderStyle?
    private let items: [T]
    private let title: String

    public init(_ title: String, selectedItem: Binding<T?>, items: [T]) {
        self.title = title
        self._selectedItem = selectedItem
        self.items = items
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> TextFieldPickerUIView {
        let view = TextFieldPickerUIView()
        view.placeHolder = title
        view.delegate = context.coordinator
        return view
    }
    
    public func updateUIView(_ uiView: TextFieldPickerUIView, context: Context) {
        uiView.delegateUpdateMode = selectedItemUpdateMode
        uiView.font = font
        if textFieldStyle is RoundedBorderTextFieldStyle {
            uiView.textFieldBoarderStyle = .roundedRect
        } else if textFieldStyle is PlainTextFieldStyle {
            uiView.textFieldBoarderStyle = .none
        }
        if let uiTextFieldStyle {
            uiView.textFieldBoarderStyle = uiTextFieldStyle
        }
    }
}

// MARK: View Modifiers
extension TextFieldPicker {
    /// Sets the font for text in the textfield.
    public func font(_ font: UIFont) -> TextFieldPicker<T> {
        var view = self
        view.font = font
        return view
    }

    /// Sets the selection update mode in this view.
    public func selectedItemUpdateMode(_ mode: TextFieldPickerSelectionUpdateMode) -> TextFieldPicker<T> {
        var view = self
        view.selectedItemUpdateMode = mode
        return view
    }

    /// Sets the style for the text field in this view.
    public func textFieldStyle(_ style: any TextFieldStyle) -> TextFieldPicker<T> {
        var view = self
        view.textFieldStyle = style
        view.uiTextFieldStyle = nil
        return view
    }

    /// Sets the style for the text field in this view.
    public func textFieldStyle(_ style: UITextField.BorderStyle) -> TextFieldPicker<T> {
        var view = self
        view.uiTextFieldStyle = style
        view.textFieldStyle = nil
        return view
    }
}

// MARK: Coordinator
extension TextFieldPicker {
    public class Coordinator: NSObject, TextFieldPickerDelegate {
        let view: TextFieldPicker

        init(_ view: TextFieldPicker) {
            self.view = view
        }

        public func picker(_ picker: TextFieldPickerUIView, didSelectItemAtRow row: Int) {
            guard view.items.isEmpty == false else { return }
            view.selectedItem = view.items[row]
        }
        
        public func picker(_ picker: TextFieldPickerUIView, titleForRow row: Int) -> String? {
            guard view.items.isEmpty == false else { return nil }
            return view.items[row].description
        }
        
        public func numberOfItems(_ picker: TextFieldPickerUIView) -> Int {
            view.items.count
        }
    }
}
