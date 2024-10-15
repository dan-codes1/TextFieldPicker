// The Swift Programming Language
// https://docs.swift.org/swift-book

//
//  TextFieldPicker.swift
//
//
//  Created by Daniel Eze on 2024-10-04.
//  Copyright © 2024 Daniel Eze. All rights reserved.
//

import Foundation
import SwiftUI

/// UI component that provides a TextField with a picker as its input view.
/// - Parameters:
///     - title: The placehodler of the text field
///     - selection: The selected value of the available options. Must conform to [`Identifiable`](https://developer.apple.com/documentation/swift/identifiable) and [`CustomStringConvertible`](https://developer.apple.com/documentation/swift/customstringconvertible). The `description` of the `CustomStringConvertible` is used as the display string for the picker options.
///     - options: The list of available selectable options. Must be the same type as the `selection` paramenter.
///
/// **Example Usage**:
/// ```swift
/// struct ContentView: View {
///     @State private var selectedCountry: Country? = nil
///     let countries = Country.allCases
///
///     var body: some View {
///         TextFieldPicker(selection: $selectedCountry, options: countries)
///     }
/// }
/// ```
public struct TextFieldPicker<T>: UIViewRepresentable where T: Identifiable & CustomStringConvertible {
    @Binding private var selection: T?
    private var font: UIFont?
    private var selectionUpdateMode: TextFieldPickerSelectionUpdateMode = .onSelect
    private var textFieldStyle: (any TextFieldStyle)?
    private var uiTextFieldStyle: UITextField.BorderStyle?
    /// The list of options to be displayed in the picker. Each option must conform to Identifiable and CustomStringConvertible.
    private let options: [T]
    /// A placeholder or title for the text field when no item is selected.
    private let title: String

    public init(_ title: String, selection: Binding<T?>, options: [T]) {
        self.title = title
        self._selection = selection
        self.options = options
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> TextFieldPickerUIView {
        let view = TextFieldPickerUIView()
        view.placeHolder = title
        view.initialTextFieldText = selection?.description
        view.delegate = context.coordinator
        return view
    }
    
    public func updateUIView(_ uiView: TextFieldPickerUIView, context: Context) {
        uiView.selectionUpdateMode = selectionUpdateMode
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
        view.selectionUpdateMode = mode
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
            guard view.options.isEmpty == false else { return }
            view.selection = view.options[row]
        }
        
        public func picker(_ picker: TextFieldPickerUIView, titleForRow row: Int) -> String? {
            guard view.options.isEmpty == false else { return nil }
            return view.options[row].description
        }
        
        public func numberOfItems(_ picker: TextFieldPickerUIView) -> Int {
            view.options.count
        }
    }

}
