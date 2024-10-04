//
//  File.swift
//  
//
//  Created by Daniel Eze on 2024-10-04.
//

import Foundation

public protocol TextFieldPickerDelegate {
    /// Informs the delegate that an item has been selected.
    /// - Note: This informs the delegate based on the `TextFieldPickerSelectionUpdateMode` of the picker.
    /// - Parameters:
    ///     - picker: The picker view.
    ///     - row: the selected row.
    func picker(_ picker: TextFieldPickerUIView, didSelectItemAtRow row: Int)
    /// Gets the text for each picker item.
    /// - Parameters:
    ///     - picker: The picker view.
    ///     - row: the selected row.
    /// - Returns: The string to be displated for each picker item.
    func picker(_ picker: TextFieldPickerUIView, titleForRow row: Int) -> String?

    /// Gets the number of items in the picker.
    /// - Parameters:
    ///     - picker: The picker view.
    /// - Returns: The number of items in the picker.
    func numberOfItems(_ picker: TextFieldPickerUIView) -> Int
}
