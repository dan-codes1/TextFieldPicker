//
//  File.swift
//  
//
//  Created by Daniel Eze on 2024-10-04.
//

import Foundation

/// Determines how often the delegate gets updates of changes to picker selection.
public enum TextFieldPickerSelectionUpdateMode {
    /// Updates the selected value only at the end of the selection.
    case onFinish
    /// Updates the selected value on every new selection on the picker slider.
    case onSelect
}
