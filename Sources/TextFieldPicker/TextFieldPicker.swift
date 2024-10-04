// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

struct TextFieldPicker<T>: UIViewRepresentable where T: Identifiable & Displayable {
    @Binding private var selectedItem: T?
    @State private var textFieldStyle: (any TextFieldStyle)?
    @State private var uiTextFieldStyle: UITextField.BorderStyle?
    @State private var title: String
    @State private var selectedItemUpdateMode: TextFieldPickerSelectionUpdateMode = .onSelect
    private var items: [T]

    init(_ title: String, selectedItem: Binding<T?>, items: [T]) {
        self.title = title
        self._selectedItem = selectedItem
        self.items = items
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> TextFieldPickerUIView {
        let view = TextFieldPickerUIView()
        view.delegateUpdateMode = selectedItemUpdateMode
        view.placeHolder = title
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: TextFieldPickerUIView, context: Context) {
        uiView.placeHolder = title
        uiView.delegateUpdateMode = selectedItemUpdateMode
        if let style = textFieldStyle as? RoundedBorderTextFieldStyle {
            uiView.textFieldBoarderStyle = .roundedRect
        } else if let style = textFieldStyle as? PlainTextFieldStyle {
            uiView.textFieldBoarderStyle = .none
        }
        if let uiTextFieldStyle {
            uiView.textFieldBoarderStyle = uiTextFieldStyle
        }
    }

    func selectedItemUpdateMode(_ mode: TextFieldPickerSelectionUpdateMode) {
        selectedItemUpdateMode = mode
    }

    func textFieldStyle(_ style: any TextFieldStyle) {
        textFieldStyle = style
        uiTextFieldStyle = nil
    }

    func textFieldStyle(_ style: UITextField.BorderStyle) {
        uiTextFieldStyle = style
        textFieldStyle = nil
    }

}

extension TextFieldPicker {
    class Coordinator: NSObject, TextFieldPickerDelegate {
        let view: TextFieldPicker

        init(_ view: TextFieldPicker) {
            self.view = view
        }

        func picker(_ picker: TextFieldPickerUIView, didSelectItemAtRow row: Int) {
            guard view.items.count <= row else { return }
            view.selectedItem = view.items[row]
        }
        
        func picker(_ picker: TextFieldPickerUIView, titleForRow row: Int) -> String? {
            guard view.items.count <= row else { return nil }
            return view.items[row].displayString
        }
        
        func numberOfItems(_ picker: TextFieldPickerUIView) -> Int {
            view.items.count
        }
    }

}
