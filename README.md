
# TextFieldPicker

A SwiftUI package that provides a TextField with a Picker as its input view. The picker replaces the keyboard as the input view for the TextField.

https://github.com/user-attachments/assets/83f029db-457b-4521-9f02-79697e11d9f9

## Requirements

- iOS 13.0+
- macOS 10.13+
- Swift 5.0+
## Installation

### Swift Package Manager

To add TextFieldPicker to your Xcode project:

1. In Xcode, open your project and select **File** > **Add Packages**.
2. Paste the repository URL: https://github.com/dan-codes1/TextFieldPicker.
3. Choose the package options and add it to your target.


## Usage

Here is a simple example:
```swift
struct ContentView: View {
    @State private var selectedCountry: Country? = nil
    let countries = Country.allCases

    var body: some View {
        TextFieldPicker(selection: $selectedCountry, options: countries)
    }
}
```

⚠️ **Important**: The `selection` parameter type must conform to [`Identifiable`](https://developer.apple.com/documentation/swift/identifiable) and [`CustomStringConvertible`](https://developer.apple.com/documentation/swift/customstringconvertible). The `decription` of the `CustomStringConvertible` is used as the display string for the picker options.
 In this case, `country` conforms to Indetifiable and CustomStringConvertible:
 ```swift
 enum Country: String, CaseIterable, Identifiable, CustomStringConvertible {
     var id: Self { self }

     case australia = "Australia"
     case canada = "Canada"
     case egypt = "Egypt"
     case ghana = "Ghana"
     case kenya = "Kenya"
     case namibia = "Namibia"
     case morocco = "Morocco"
     case newZealand = "New Zealand"
     case southAfrica = "South Africa"
     case unitedKingdom = "United Kingdom"
     case unitedStates = "United States"

     var description: String {
         self.rawValue
     }
 }
 ```

## Contribution
Contributions are welcome! Please open an issue or submit a pull request if you would like to contribute to the project.
