import SwiftUI

class OnboardingState: ObservableObject {
    @Published var currentPage: Int = 0
    
    func nextPage() {
        withAnimation {
            currentPage += 1
        }
    }
    
    func previousPage() {
        withAnimation {
            currentPage -= 1
        }
    }
} 