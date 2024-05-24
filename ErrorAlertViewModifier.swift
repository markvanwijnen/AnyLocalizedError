import SwiftUI

struct AnyLocalizedError: LocalizedError {
    var errorDescription: String?
    var failureReason: String?
    var helpAnchor: String?
    var recoverySuggestion: String?
    
    init(errorDescription: String? = nil, failureReason: String? = nil, helpAnchor: String? = nil, recoverySuggestion: String? = nil) {
        self.errorDescription = errorDescription
        self.failureReason = failureReason
        self.helpAnchor = helpAnchor
        self.recoverySuggestion = recoverySuggestion
    }
    
    init(_ error: Error, map: ((Error) -> LocalizedError?)? = nil) {
        var localizedError = error as? LocalizedError
        if localizedError == nil { localizedError = map?(error) }
        if localizedError == nil {
            let nsError = error as NSError
            localizedError = AnyLocalizedError(errorDescription: nsError.localizedDescription,
                                               failureReason: nsError.localizedFailureReason,
                                               helpAnchor: nsError.helpAnchor,
                                               recoverySuggestion: nsError.localizedRecoverySuggestion)
        }
        
        if let localizedError = localizedError {
            self.errorDescription = localizedError.errorDescription
            self.failureReason = localizedError.failureReason
            self.helpAnchor = localizedError.helpAnchor
            self.recoverySuggestion = localizedError.recoverySuggestion
        }
    }
}

extension Error {
    func eraseToAnyLocalizedError(map: ((Error) -> LocalizedError?)? = nil) -> AnyLocalizedError {
        AnyLocalizedError(self, map: map)
    }
}

struct ErrorAlertViewModifier: ViewModifier {
    @Binding var error: AnyLocalizedError?
    
    func body(content: Content) -> some View {
        if let error = error {
            content
                .alert(isPresented: .constant(true), error: error) { _ in
                    Button("OK", role: .cancel) { self.error = nil }
                } message: { error in
                    if let suggestion = error.recoverySuggestion {
                        Text(suggestion)
                    } else if let reason = error.failureReason {
                        Text(reason)
                    } else {
                        Text("Try again later.")
                    }
                }
        } else {
            content
        }
    }
}

extension View {
    func alert(error: Binding<AnyLocalizedError?>) -> some View {
        modifier(ErrorAlertViewModifier(error: error))
    }
}
