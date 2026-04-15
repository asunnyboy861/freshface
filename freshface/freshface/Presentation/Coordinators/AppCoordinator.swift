import SwiftUI

class AppCoordinator: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published var selectedProduct: Product?
    @Published var showAddProduct = false
    @Published var showScanner = false
    
    enum AppTab: String, CaseIterable {
        case home = "Home"
        case products = "Products"
        case routine = "Routine"
        case analytics = "Analytics"
        case settings = "Settings"
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .products: return "cube.box.fill"
            case .routine: return "sunrise.fill"
            case .analytics: return "chart.bar.fill"
            case .settings: return "gearshape.fill"
            }
        }
    }
    
    func selectProduct(_ product: Product) {
        selectedProduct = product
    }
    
    func clearSelection() {
        selectedProduct = nil
    }
    
    func navigate(to tab: AppTab) {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedTab = tab
        }
    }
}
