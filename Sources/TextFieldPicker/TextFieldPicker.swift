// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

public struct TextFieldPicker<T>: UIViewRepresentable where T: Identifiable & CustomStringConvertible {
    @Binding private var selectedItem: T?
    @State private var textFieldStyle: (any TextFieldStyle)?
    @State private var uiTextFieldStyle: UITextField.BorderStyle?
    @State private var title: String
    @State private var selectedItemUpdateMode: TextFieldPickerSelectionUpdateMode = .onSelect
    private var items: [T]

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
        view.delegateUpdateMode = selectedItemUpdateMode
        view.placeHolder = title
        view.delegate = context.coordinator
        return view
    }
    
    public func updateUIView(_ uiView: TextFieldPickerUIView, context: Context) {
        uiView.placeHolder = title
        uiView.delegateUpdateMode = selectedItemUpdateMode
        if textFieldStyle is RoundedBorderTextFieldStyle {
            uiView.textFieldBoarderStyle = .roundedRect
        } else if textFieldStyle is PlainTextFieldStyle {
            uiView.textFieldBoarderStyle = .none
        }
        if let uiTextFieldStyle {
            uiView.textFieldBoarderStyle = uiTextFieldStyle
        }
    }

    public func selectedItemUpdateMode(_ mode: TextFieldPickerSelectionUpdateMode) {
        selectedItemUpdateMode = mode
    }

    public func textFieldStyle(_ style: any TextFieldStyle) {
        textFieldStyle = style
        uiTextFieldStyle = nil
    }

    public func textFieldStyle(_ style: UITextField.BorderStyle) {
        uiTextFieldStyle = style
        textFieldStyle = nil
    }

}

extension TextFieldPicker {
    public class Coordinator: NSObject, TextFieldPickerDelegate {
        let view: TextFieldPicker

        init(_ view: TextFieldPicker) {
            self.view = view
        }

        public func picker(_ picker: TextFieldPickerUIView, didSelectItemAtRow row: Int) {
            guard view.items.count <= row else { return }
            view.selectedItem = view.items[row]
        }
        
        public func picker(_ picker: TextFieldPickerUIView, titleForRow row: Int) -> String? {
            guard view.items.count > 0 else { return nil }
            return view.items[row].description
        }
        
        public func numberOfItems(_ picker: TextFieldPickerUIView) -> Int {
            view.items.count
        }
    }

}
