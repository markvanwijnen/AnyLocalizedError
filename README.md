# ErrorAlertViewModifier
An extension to SwiftUI that will present any kind of error to the user.

## Installation

### Manual:

Download `ErrorAlertViewModifier.swift` and add the script to your project.

## Usage

1. We declare an `error` state value.
2. Whenever an error occurs we catch it and type erase it with `eraseToAnyLocalizedError()`.
3. Whenever the state changes of `error` that error will be presented in an alert to the user.

```swift
enum SampleError: Error {
    case anErrorOccured
    case anotherErrorOccured
}

struct ContentView: View {
    // 1
    @State private var error: AnyLocalizedError?

    var body: some View {
        VStack {
            Button("Trigger Error") {
                do {
                    try aMethodThatAlwaysFails()
                } catch {
                    // 2a. Most simplified version
                    self.error = error.eraseToAnyLocalizedError()
                    
                    // 2b. An advanced version in which we provide the proper information for any generic Error
                    self.error = error.eraseToAnyLocalizedError { error in
                        if let sampleError = error as? SampleError {
                            switch sampleError {
                            case .anErrorOccured:
                                return AnyLocalizedError(errorDescription: "An Error Occured",
                                                         recoverySuggestion: "Try again later.")
                            case .anotherErrorOccured:
                                return AnyLocalizedError(errorDescription: "Another Error Occured",
                                                         recoverySuggestion: "We can not come back from this.")
                            }
                        }
                        return nil
                    }
                }
            }
        }
        // 3
        .alert(error: $error)
    }
    
    func aMethodThatAlwaysFails() throws {
        throw SampleError.anErrorOccured
    }
}
```

## Donate

If you have been enjoying my free Swift script, please consider showing your support by buying me a coffee through the link below. Thanks in advance!

<a href="https://www.buymeacoffee.com/markvanwijnen" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/arial-yellow.png" height="60px" alt="Buy Me A Coffee"></a>
