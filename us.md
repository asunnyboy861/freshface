# FreshFace - Skincare Product Expiry Manager
## Comprehensive Implementation Guide for US Market

> **Document Version**: v1.0  
> **Target Market**: United States (and Global English Markets)  
> **Platform**: iOS 17+ (iPhone & iPad)  
> **Last Updated**: April 7, 2026  

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Market Analysis & Competitive Landscape](#2-market-analysis--competitive-landscape)
3. [GitHub Projects Analysis](#3-github-projects-analysis)
4. [Technical Architecture](#4-technical-architecture)
5. [Feature Modules Design](#5-feature-modules-design)
6. [UI/UX Design Guidelines](#6-uiux-design-guidelines)
7. [Implementation Workflow](#7-implementation-workflow)
8. [Code Generation Rules & Standards](#8-code-generation-rules--standards)
9. [Testing & Acceptance Criteria](#9-testing--acceptance-criteria)
10. [Development Roadmap](#10-development-roadmap)
11. [Apple App Store Compliance](#11-apple-app-store-compliance)
12. [Monetization Strategy](#12-monetization-strategy)

---

## 1. Executive Summary

### 1.1 Project Overview

**FreshFace** is an AI-powered skincare product expiry management application designed for the US market. The app helps users track product freshness, prevent health risks from expired products, and reduce economic waste through intelligent notifications and predictive analytics.

### 1.2 Core Value Proposition

**"Never Use Expired Skincare Again"** - AI-powered recognition, automatic expiry tracking, and personalized reminders to help users safely manage skincare and beauty products.

### 1.3 Key Differentiators

- **AI-Powered Recognition**: First app to automatically identify PAO (Period After Opening) symbols
- **Smart Predictions**: Predicts whether products can be finished before expiry
- **Native iOS Experience**: Built with SwiftUI for optimal performance
- **Privacy-First**: All data stored locally with optional iCloud sync

### 1.4 Target Users

1. **Skincare Enthusiasts** (25-45 years)
   - Own multiple skincare products
   - Concerned about product safety and efficacy
   
2. **Beauty Professionals** (25-55 years)
   - Makeup artists, estheticians, beauty bloggers
   - Need to manage client-used products safely

3. **Eco-Conscious Consumers** (20-40 years)
   - Focus on sustainability and reducing waste
   - Want to use products optimally

4. **Sensitive Skin Users** (18-60 years)
   - Strong reactions to expired products
   - Need strict freshness management

---

## 2. Market Analysis & Competitive Landscape

### 2.1 Market Size

- **Global Skincare App Market**: $12.5B (2024) → $28.4B (2033)
- **CAGR**: 12.8%
- **US Market**: Largest single market globally

### 2.2 Competitor Analysis

#### Direct Competitors (iOS App Store)

| App Name | Rating | Key Features | Weaknesses | Pricing |
|----------|--------|--------------|------------|---------|
| **ShelfLife: Never Miss Expiry** | N/A (New) | Expiry tracking, iCloud sync, categories | Basic features only, no AI | Free |
| **Best By-Beauty Expiry Tracker** | 5.0 ⭐ (3 reviews) | Manual add, expiry reminders | Limited reviews, basic UI | Free |
| **Cosmetrack - Cosmetics Tracker** | N/A (New) | AI recognition, expiry tracking | New app, limited user base | Free + IAP |
| **CosmeTick: Expiry Tracker** | N/A (New) | Barcode scanning, PAO tracking | New to market | Free + Premium |
| **FeelinMySkin** | 4.7 ⭐ | Routine builder, product tracker, INCI checker | Focus on routines, not expiry | Free + Subscription |

#### Competitive Advantages Matrix

| Feature | ShelfLife | Best By | Cosmetrack | CosmeTick | FeelinMySkin | **FreshFace** |
|---------|-----------|---------|------------|-----------|--------------|---------------|
| Manual Product Entry | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Expiry Notifications | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ (Smart) |
| Barcode Scanning | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ |
| AI Photo Recognition | ❌ | ❌ | ✅ | ❌ | ❌ | ✅ (Advanced) |
| PAO Symbol Detection | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ (AI-powered) |
| Product Database | ❌ | ❌ | ❌ | ❌ | ✅ (150K+) | ✅ (Makeup API) |
| Routine Management | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ |
| Usage Analytics | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ (Advanced) |
| Expiry Risk Prediction | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ (Unique) |
| Product Recommendations | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ |
| Cloud Sync | ✅ | ❌ | ✅ | ❌ | ✅ | ✅ |
| Dark Mode | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

### 2.3 Market Gaps Identified

1. **No AI-powered PAO detection**: Competitors lack automatic PAO symbol recognition
2. **Limited predictive analytics**: No app predicts product completion before expiry
3. **Basic notification systems**: Competitors offer simple date-based reminders only
4. **Poor user experience**: Many apps have outdated or cluttered interfaces
5. **No usage optimization**: Missing features to help users finish products on time

---

## 3. GitHub Projects Analysis

### 3.1 Recommended Projects for Secondary Development

#### Project 1: ShelfLife ⭐⭐⭐⭐⭐ (Highly Recommended)

**Repository**: `mvohra11/ShelfLife`

**Why Recommended**:
- ✅ Native Swift development with high code quality
- ✅ Core Data persistence implementation
- ✅ Makeup API integration
- ✅ Complete notification system
- ✅ Clean MVC architecture
- ✅ MIT license (commercial use allowed)

**Tech Stack**:
```
- Swift + UIKit
- Core Data (NSPersistentContainer)
- UserNotifications
- URLSession (API integration)
- UIImagePickerController
- UIDatePicker
```

**Reusable Modules**:
1. Core Data models
2. Makeup API integration code
3. Notification scheduling system
4. Product list UI components

**Secondary Development Recommendations**:
1. Migrate UI to SwiftUI (modernization)
2. Integrate AI recognition (Core ML)
3. Add skincare routine management
4. Implement CloudKit sync

**Integration Strategy**:
- Clone repository and analyze code structure
- Extract Core Data models and API clients
- Refactor to SwiftUI architecture
- Add new AI-powered features

---

### 3.2 Alternative Projects

#### Project 2: beauty-tracker ⭐⭐⭐⭐

**Repository**: `kukina622/beauty-tracker`

**Why Consider**:
- ✅ Flutter cross-platform
- ✅ Supabase backend
- ✅ Google OAuth
- ✅ Modern architecture

**Limitation**: Flutter-based, requires conversion to Swift

**Use Case**: Reference for backend architecture and OAuth flow

---

#### Project 3: BeautyInventory ⭐⭐⭐

**Repository**: `roger070604/BeautyInventory`

**Why Consider**:
- ✅ Swift 3.0 native
- ✅ Shopping features
- ✅ Expiry reminders

**Limitation**: Outdated code (2017), Swift 3.0 syntax

**Use Case**: Feature reference only, not recommended for direct code reuse

---

### 3.4 GitHub Projects Setup Instructions

**Step 1: Clone Recommended Repositories**

```bash
# Navigate to your project directory
cd /Volumes/ORICO-APFS/app/20260407/freshface

# Create directory for reference projects
mkdir -p reference_projects

# Clone ShelfLife (Primary - for code reuse)
cd reference_projects
git clone https://github.com/mvohra11/ShelfLife.git

# Clone beauty-tracker (Reference - for architecture ideas)
git clone https://github.com/kukina622/beauty-tracker.git

# Clone BeautyInventory (Reference - for feature ideas)
git clone https://github.com/roger070604/BeautyInventory.git

# Return to main project
cd ../..
```

**Step 2: Analyze ShelfLife Project Structure**

```bash
# Open ShelfLife in Xcode (for analysis only)
open reference_projects/ShelfLife/ShelfLife.xcodeproj

# Key files to examine:
# - Core Data model (.xcdatamodeld)
# - API client code
# - Notification scheduling
# - Product management logic
```

**Step 3: Extract Reusable Components from ShelfLife**

After analyzing the ShelfLife project, identify these reusable components:

1. **Core Data Models**: Product entity structure
2. **MakeupAPI Client**: Network layer for product database
3. **NotificationManager**: Expiry notification system
4. **DateHelper**: Date calculation utilities

**Note**: Do NOT copy-paste directly. Instead, understand the patterns and implement in our MVVM + SwiftUI architecture.

---

### 3.5 Code Conversion Guidelines

**Converting Non-Native Code to Swift/iOS Native**

#### Flutter to Swift Conversion (for beauty-tracker)

| Flutter Concept | iOS Native Equivalent |
|----------------|----------------------|
| BLoC/Cubit Pattern | Combine + @Published ViewModel |
| Hive/SharedPreferences | Core Data / UserDefaults |
| Dio HTTP Client | URLSession / Async/Await |
| StatefulWidget | SwiftUI View with @State |
| Provider/InheritedWidget | EnvironmentObject / Dependency Injection |
| Navigator 2.0 | NavigationStack / NavigationPath |
| BuildContext | View context or Environment |

**Conversion Process**:

1. **Extract Business Logic**
   ```dart
   // Flutter (Dart) - Original
   class ProductModel {
     final String id;
     final String name;
     final DateTime expiryDate;
     
     ProductModel({required this.id, required this.name, required this.expiryDate});
   }
   ```

2. **Convert to Swift Struct**
   ```swift
   // Swift - Converted
   struct Product: Identifiable, Codable {
       let id: UUID
       var name: String
       var expiryDate: Date
       
       init(id: UUID = UUID(), name: String, expiryDate: Date) {
           self.id = id
           self.name = name
           self.expiryDate = expiryDate
       }
   }
   ```

3. **Recreate UI in SwiftUI**
   ```dart
   // Flutter UI (Dart)
   Widget build(BuildContext context) {
     return Card(
       child: Column(
         children: [
           Text(product.name),
           Text(formatDate(product.expiryDate)),
         ],
       ),
     );
   }
   ```

   ```swift
   // SwiftUI - Converted
   var body: some View {
       VStack(alignment: .leading, spacing: 8) {
           Text(product.name)
               .font(.headline)
           Text(product.expiryDate.formatted())
               .font(.subheadline)
       }
       .padding()
       .background(Color(.systemBackground))
       .cornerRadius(12)
       .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
   }
   ```

**Important**: Always use native iOS APIs instead of third-party libraries when possible.

---

### 3.6 API & Third-Party Services

#### Makeup API (Free)

**URL**: http://makeup-api.herokuapp.com/

**Data Available**:
- 10,000+ cosmetic products
- Fields: Brand, name, type, price, images, ingredients

**Integration Example**:
```swift
struct MakeupAPI {
    static let baseURL = "http://makeup-api.herokuapp.com/api/v1/products.json"
    
    static func searchProducts(brand: String? = nil, productType: String? = nil) async throws -> [Product] {
        var components = URLComponents(string: baseURL)!
        var queryItems: [URLQueryItem] = []
        
        if let brand = brand {
            queryItems.append(URLQueryItem(name: "brand", value: brand.lowercased()))
        }
        if let productType = productType {
            queryItems.append(URLQueryItem(name: "product_type", value: productType))
        }
        
        components.queryItems = queryItems
        
        let (data, _) = try await URLSession.shared.data(from: components.url!)
        let products = try JSONDecoder().decode([MakeupProduct].self, from: data)
        
        return products.map { $0.toProduct() }
    }
}
```

#### OpenFoodFacts API (Free)

**URL**: https://world.openfoodfacts.org/api/v0

**Use Case**: Barcode scanning supplementary data source

---

## 4. Technical Architecture

### 4.1 Technology Stack

#### Frontend (iOS Native)

| Technology | Purpose | Version |
|------------|---------|---------|
| **Swift** | Primary language | 5.9+ |
| **SwiftUI** | UI framework | iOS 17+ |
| **UIKit** | Complex UI components | iOS 17+ |
| **Combine** | Reactive programming | iOS 17+ |
| **Core Data** | Local persistence | iOS 17+ |
| **CloudKit** | Cloud sync | iOS 17+ |

#### AI/ML Technologies

| Technology | Purpose |
|------------|---------|
| **Core ML** | ML model execution |
| **Vision** | Image recognition |
| **Create ML** | Custom model training |
| **Natural Language** | Text recognition (PAO symbols) |

#### Networking & APIs

| Technology | Purpose |
|------------|---------|
| **URLSession** | API networking |
| **Makeup API** | Product database |
| **OpenFoodFacts API** | Barcode data |

#### Notifications

| Technology | Purpose |
|------------|---------|
| **UserNotifications** | Local push notifications |
| **Background Tasks** | Background expiry checks |

### 4.2 Architecture Pattern

**MVVM (Model-View-ViewModel) with Clean Architecture**

```
┌─────────────────────────────────────────────────┐
│                   Presentation                   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │  Views   │  │ViewModels│  │Coordinators│     │
│  │(SwiftUI) │◄─┤  (Logic) │◄─┤ (Navigation)│    │
│  └──────────┘  └──────────┘  └──────────┘      │
└─────────────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│                    Domain                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ UseCases │  │ Entities │  │Repository│      │
│  │          │  │          │  │Protocols │      │
│  └──────────┘  └──────────┘  └──────────┘      │
└─────────────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│                     Data                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │Repository│  │Data Source│ │  Models  │      │
│  │   Impl   │  │(Local/Remote)│(CoreData)│     │
│  └──────────┘  └──────────┘  └──────────┘      │
└─────────────────────────────────────────────────┘
```

### 4.3 Data Model Design

#### Core Data Entities

**Product Entity**
```
Product
├── id: UUID
├── name: String
├── brand: String
├── category: String (enum: skincare, makeup, haircare, fragrance, other)
├── productType: String (sub-type: cleanser, moisturizer, serum, etc.)
├── purchaseDate: Date
├── openDate: Date?
├── expiryDate: Date
├── paoMonths: Int (Period After Opening in months)
├── image: Data (product image binary)
├── barcode: String?
├── notes: String?
├── usageFrequency: Int (usage per week)
├── estimatedRemaining: Double (0.0-1.0)
├── isActive: Bool
├── createdAt: Date
├── updatedAt: Date
└── relationships:
    ├── routineItems: [RoutineItem] (many-to-many)
    └── usageLogs: [UsageLog] (one-to-many)
```

**Routine Entity**
```
Routine
├── id: UUID
├── name: String (Morning/Evening/Custom)
├── time: Date (reminder time)
├── isActive: Bool
├── createdAt: Date
└── relationships:
    └── routineItems: [RoutineItem] (one-to-many)
```

**UsageLog Entity**
```
UsageLog
├── id: UUID
├── date: Date
├── notes: String?
├── skinCondition: String?
└── relationships:
    └── product: Product (many-to-one)
```

### 4.4 Project Structure

```
FreshFace/
├── App/
│   ├── FreshFaceApp.swift
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
│
├── Presentation/
│   ├── Views/
│   │   ├── Home/
│   │   │   ├── HomeView.swift
│   │   │   ├── ProductListView.swift
│   │   │   └── ProductCardView.swift
│   │   ├── Product/
│   │   │   ├── AddProductView.swift
│   │   │   ├── ProductDetailView.swift
│   │   │   └── EditProductView.swift
│   │   ├── Scanner/
│   │   │   ├── BarcodeScannerView.swift
│   │   │   └── PhotoRecognitionView.swift
│   │   ├── Routine/
│   │   │   ├── RoutineView.swift
│   │   │   └── RoutineDetailView.swift
│   │   ├── Analytics/
│   │   │   ├── AnalyticsView.swift
│   │   │   └── UsageStatsView.swift
│   │   └── Settings/
│   │       ├── SettingsView.swift
│   │       └── NotificationSettingsView.swift
│   │
│   ├── ViewModels/
│   │   ├── HomeViewModel.swift
│   │   ├── ProductViewModel.swift
│   │   ├── ScannerViewModel.swift
│   │   ├── RoutineViewModel.swift
│   │   └── AnalyticsViewModel.swift
│   │
│   └── Coordinators/
│       ├── AppCoordinator.swift
│       └── NavigationCoordinator.swift
│
├── Domain/
│   ├── Entities/
│   │   ├── Product.swift
│   │   ├── Routine.swift
│   │   └── UsageLog.swift
│   │
│   ├── UseCases/
│   │   ├── AddProductUseCase.swift
│   │   ├── UpdateProductUseCase.swift
│   │   ├── DeleteProductUseCase.swift
│   │   ├── GetExpiringProductsUseCase.swift
│   │   ├── CalculateExpiryUseCase.swift
│   │   └── PredictCompletionUseCase.swift
│   │
│   └── RepositoryProtocols/
│       ├── ProductRepository.swift
│       ├── RoutineRepository.swift
│       └── UsageLogRepository.swift
│
├── Data/
│   ├── Repositories/
│   │   ├── ProductRepositoryImpl.swift
│   │   ├── RoutineRepositoryImpl.swift
│   │   └── UsageLogRepositoryImpl.swift
│   │
│   ├── DataSources/
│   │   ├── Local/
│   │   │   ├── CoreDataManager.swift
│   │   │   ├── ProductLocalDataSource.swift
│   │   │   └── RoutineLocalDataSource.swift
│   │   │
│   │   └── Remote/
│   │       ├── MakeupAPIClient.swift
│   │       └── OpenFoodFactsClient.swift
│   │
│   └── Models/
│       ├── CoreData/
│       │   ├── CDProduct+CoreDataClass.swift
│       │   ├── CDRoutine+CoreDataClass.swift
│       │   └── CDUsageLog+CoreDataClass.swift
│       │
│       └── API/
│           ├── MakeupProduct.swift
│           └── OpenFoodFactsProduct.swift
│
├── Services/
│   ├── AI/
│   │   ├── PAODetector.swift
│   │   ├── ProductRecognizer.swift
│   │   └── BarcodeScannerService.swift
│   │
│   ├── Notifications/
│   │   ├── NotificationManager.swift
│   │   └── ExpiryNotificationScheduler.swift
│   │
│   ├── Sync/
│   │   ├── CloudKitManager.swift
│   │   └── SyncService.swift
│   │
│   └── Analytics/
│       ├── UsageTracker.swift
│       └── AnalyticsService.swift
│
├── Utilities/
│   ├── Extensions/
│   │   ├── Date+Extensions.swift
│   │   ├── Color+Extensions.swift
│   │   └── View+Extensions.swift
│   │
│   ├── Helpers/
│   │   ├── ExpiryCalculator.swift
│   │   ├── DateHelper.swift
│   │   └── ImageHelper.swift
│   │
│   └── Constants/
│       ├── AppConstants.swift
│       ├── ColorConstants.swift
│       └── NotificationConstants.swift
│
├── Resources/
│   ├── Assets.xcassets/
│   ├── Localizable.strings
│   └── CoreData/
│       └── FreshFace.xcdatamodeld
│
└── Tests/
    ├── UnitTests/
    │   ├── UseCases/
    │   ├── ViewModels/
    │   └── Services/
    │
    └── UITests/
        ├── ProductFlowTests.swift
        └── ScannerFlowTests.swift
```

---

## 5. Feature Modules Design

### 5.1 Module Design Principles

**Single Responsibility Principle (SRP)**
- Each module handles ONE specific feature
- High cohesion, low coupling
- Semantic file naming and structure

**Code Reusability**
- Prioritize reusing existing modules
- Abstract following "Rule of Three"
- Extract common patterns after 3 occurrences

**Clean Code Maintenance**
- Remove deprecated code immediately
- Mark deprecated → Verify no impact → Delete
- Document cleanup scope in commit messages

### 5.2 Core Feature Modules

#### Module 1: Product Management

**Purpose**: CRUD operations for skincare products

**Files**:
```
Modules/ProductManagement/
├── Domain/
│   ├── Entities/
│   │   └── Product.swift
│   ├── UseCases/
│   │   ├── AddProductUseCase.swift
│   │   ├── UpdateProductUseCase.swift
│   │   ├── DeleteProductUseCase.swift
│   │   └── GetProductUseCase.swift
│   └── RepositoryProtocols/
│       └── ProductRepository.swift
│
├── Data/
│   ├── Repositories/
│   │   └── ProductRepositoryImpl.swift
│   ├── DataSources/
│   │   └── ProductLocalDataSource.swift
│   └── Models/
│       └── CDProduct+CoreDataClass.swift
│
└── Presentation/
    ├── Views/
    │   ├── ProductListView.swift
    │   ├── ProductDetailView.swift
    │   └── AddProductView.swift
    └── ViewModels/
        └── ProductViewModel.swift
```

**Key Features**:
- Add product manually or via scan
- Edit product details
- Delete product
- Search and filter products
- Categorize products

---

#### Module 2: Expiry Tracking

**Purpose**: Calculate and track product expiry dates

**Files**:
```
Modules/ExpiryTracking/
├── Domain/
│   ├── UseCases/
│   │   ├── CalculateExpiryUseCase.swift
│   │   ├── GetExpiringProductsUseCase.swift
│   │   └── PredictCompletionUseCase.swift
│   └── ValueObjects/
│       ├── RiskLevel.swift
│       └── ExpiryPrediction.swift
│
├── Services/
│   ├── ExpiryCalculator.swift
│   └── RiskAssessmentService.swift
│
└── Presentation/
    ├── Views/
    │   ├── ExpiryStatusView.swift
    │   └── RiskIndicatorView.swift
    └── Components/
        ├── ExpiryBadge.swift
        └── RiskLevelIcon.swift
```

**Key Features**:
- Automatic expiry date calculation
- Risk level assessment (Safe, Caution, Warning, Critical, Expired)
- Completion prediction
- Multi-level notifications (30/14/7/3/1 days)

**Expiry Calculation Logic**:
```swift
class ExpiryCalculator {
    static func calculateExpiryDate(openDate: Date, paoMonths: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: paoMonths, to: openDate) ?? openDate
    }
    
    static func daysRemaining(until expiryDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: expiryDate)
        return components.day ?? 0
    }
    
    static func riskLevel(daysRemaining: Int) -> RiskLevel {
        if daysRemaining <= 0 { return .expired }
        else if daysRemaining <= 3 { return .critical }
        else if daysRemaining <= 7 { return .warning }
        else if daysRemaining <= 30 { return .caution }
        else { return .safe }
    }
}
```

---

#### Module 3: AI Recognition

**Purpose**: AI-powered product and PAO symbol recognition

**Files**:
```
Modules/AIRecognition/
├── Services/
│   ├── PAODetector.swift
│   ├── ProductRecognizer.swift
│   └── BarcodeScannerService.swift
│
├── MLModels/
│   ├── PAOIconDetector.mlmodel
│   └── ProductClassifier.mlmodel
│
└── Presentation/
    ├── Views/
    │   ├── BarcodeScannerView.swift
    │   └── PhotoRecognitionView.swift
    └── ViewModels/
        └── ScannerViewModel.swift
```

**Key Features**:
- Barcode scanning
- Photo recognition
- PAO symbol detection
- Automatic product info extraction

**PAO Detection Algorithm**:
```swift
class PAODetector {
    static func detectPAO(from image: UIImage) async throws -> Int? {
        guard let ciImage = CIImage(image: image) else {
            throw PAOError.invalidImage
        }
        
        // Step 1: Vision text recognition
        let textRequest = VNRecognizeTextRequest()
        textRequest.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try handler.perform([textRequest])
        
        guard let observations = textRequest.results else {
            return nil
        }
        
        // Step 2: Find PAO pattern (e.g., "6M", "12M", "24M")
        for observation in observations {
            guard let candidate = observation.topCandidates(1).first else { continue }
            let text = candidate.string.uppercased()
            
            let paoPattern = #"(\d+)[MМ]"#
            if let match = text.range(of: paoPattern, options: .regularExpression) {
                let paoString = String(text[match])
                let numberString = paoString.filter { $0.isNumber }
                if let months = Int(numberString) {
                    return months
                }
            }
        }
        
        return nil
    }
}
```

---

#### Module 4: Notification System

**Purpose**: Smart expiry notifications and reminders

**Files**:
```
Modules/NotificationSystem/
├── Services/
│   ├── NotificationManager.swift
│   └── ExpiryNotificationScheduler.swift
│
├── Models/
│   ├── NotificationType.swift
│   └── NotificationContent.swift
│
└── Presentation/
    └── Views/
        └── NotificationSettingsView.swift
```

**Key Features**:
- Multi-level expiry warnings
- Customizable notification times
- Routine reminders
- Smart notification scheduling

**Notification Logic**:
```swift
class ExpiryNotificationScheduler {
    static func scheduleExpiryNotifications(for product: Product) {
        let daysRemaining = ExpiryCalculator.daysRemaining(until: product.expiryDate)
        
        let notificationDays = [30, 14, 7, 3, 1]
        
        for days in notificationDays {
            if daysRemaining <= days {
                let notificationDate = Calendar.current.date(
                    byAdding: .day,
                    value: daysRemaining - days,
                    to: Date()
                )
                
                if let date = notificationDate, date > Date() {
                    scheduleNotification(
                        for: product,
                        at: date,
                        daysRemaining: daysRemaining
                    )
                }
            }
        }
    }
}
```

---

#### Module 5: Routine Management

**Purpose**: Skincare routine planning and tracking

**Files**:
```
Modules/RoutineManagement/
├── Domain/
│   ├── Entities/
│   │   └── Routine.swift
│   ├── UseCases/
│   │   ├── CreateRoutineUseCase.swift
│   │   ├── UpdateRoutineUseCase.swift
│   │   └── TrackRoutineUseCase.swift
│   └── RepositoryProtocols/
│       └── RoutineRepository.swift
│
├── Data/
│   ├── Repositories/
│   │   └── RoutineRepositoryImpl.swift
│   └── Models/
│       └── CDRoutine+CoreDataClass.swift
│
└── Presentation/
    ├── Views/
    │   ├── RoutineListView.swift
    │   ├── RoutineDetailView.swift
    │   └── CreateRoutineView.swift
    └── ViewModels/
        └── RoutineViewModel.swift
```

**Key Features**:
- Morning/evening routine planning
- Custom routine creation
- Product step ordering
- Routine completion tracking
- Reminder scheduling

---

#### Module 6: Analytics & Insights

**Purpose**: Usage statistics and product insights

**Files**:
```
Modules/Analytics/
├── Domain/
│   ├── UseCases/
│   │   ├── GetUsageStatsUseCase.swift
│   │   └── GetProductInsightsUseCase.swift
│   └── ValueObjects/
│       ├── UsageStatistics.swift
│       └── ProductInsight.swift
│
├── Services/
│   ├── UsageTracker.swift
│   └── AnalyticsService.swift
│
└── Presentation/
    ├── Views/
    │   ├── AnalyticsView.swift
    │   ├── UsageStatsView.swift
    │   └── InsightsView.swift
    └── ViewModels/
        └── AnalyticsViewModel.swift
```

**Key Features**:
- Usage frequency tracking
- Product completion rate
- Spending analytics
- Expiry rate statistics
- Personalized insights

---

#### Module 7: Cloud Sync

**Purpose**: iCloud synchronization

**Files**:
```
Modules/CloudSync/
├── Services/
│   ├── CloudKitManager.swift
│   └── SyncService.swift
│
├── Models/
│   └── CloudRecord.swift
│
└── Utilities/
    └── SyncErrorHandler.swift
```

**Key Features**:
- Automatic iCloud sync
- Conflict resolution
- Offline support
- Data backup

---

## 6. UI/UX Design Guidelines

### 6.1 Design Philosophy

**Modern Minimalism with Purpose**
- Clean, uncluttered interfaces
- Every element serves a function
- Reduced cognitive load
- Focus on content

**Apple's Liquid Glass Design (iOS 26 Ready)**
- Translucent, layered interfaces
- Dynamic depth effects
- Context-aware adaptations
- Smooth, fluid animations

### 6.2 Color Palette

**Primary Colors**:
```
Brand Primary:      #FF6B9D (Soft Pink)
Brand Secondary:    #7B68EE (Medium Purple)
Accent:             #00D4AA (Turquoise)
Success:            #4CAF50 (Green)
Warning:            #FF9800 (Orange)
Error:              #F44336 (Red)
```

**Neutral Colors**:
```
Background Light:   #FFFFFF
Background Dark:    #1A1A1A
Surface Light:      #F5F5F7
Surface Dark:       #2C2C2E
Text Primary:       #1A1A1A (Light) / #FFFFFF (Dark)
Text Secondary:     #6E6E73 (Light) / #8E8E93 (Dark)
```

**Semantic Colors**:
```
Safe (Green):       #4CAF50
Caution (Yellow):   #FFC107
Warning (Orange):   #FF9800
Critical (Red):     #F44336
Expired (Dark Red): #B71C1C
```

### 6.3 Typography

**Font Family**: SF Pro (Apple System Font)

**Type Scale**:
```
Large Title:    34pt, Bold
Title 1:        28pt, Bold
Title 2:        22pt, Bold
Title 3:        20pt, Semibold
Headline:       17pt, Semibold
Body:           17pt, Regular
Callout:        16pt, Regular
Subheadline:    15pt, Regular
Footnote:       13pt, Regular
Caption 1:      12pt, Regular
Caption 2:      11pt, Regular
```

### 6.4 UI Components

#### Product Card Design

```
┌─────────────────────────────────┐
│  ┌──────┐                       │
│  │      │  Product Name         │
│  │ IMG  │  Brand Name           │
│  │      │  ┌──────────────┐     │
│  └──────┘  │ ● Safe       │     │
│            │ 30 days left │     │
│            └──────────────┘     │
│  Category: Skincare             │
│  Opened: Jan 15, 2026           │
└─────────────────────────────────┘
```

**Specifications**:
- Corner radius: 12pt
- Shadow: 0 2pt 8pt rgba(0,0,0,0.1)
- Padding: 16pt
- Image size: 80x80pt
- Status badge: Rounded pill, 8pt padding

#### Expiry Status Indicator

```
Safe:        🟢 Green circle with checkmark
Caution:     🟡 Yellow triangle with exclamation
Warning:     🟠 Orange triangle with exclamation
Critical:    🔴 Red octagon with X
Expired:     ⚫ Dark red circle with X
```

#### Navigation Structure

**Tab Bar** (Bottom):
```
┌────────────────────────────────────┐
│  🏠 Home  │  📦 Products  │  🌅 Routine  │  📊 Analytics  │  ⚙️ Settings  │
└────────────────────────────────────┘
```

**Tab Specifications**:
- Height: 49pt (83pt with Home Indicator)
- Icon size: 24x24pt
- Label: 10pt, Medium
- Active color: Brand Primary
- Inactive color: Text Secondary

### 6.5 Screen Designs

#### Home Screen

```
┌─────────────────────────────────────┐
│  FreshFace              [🔔] [⚙️]   │
├─────────────────────────────────────┤
│                                     │
│  ⚠️ Expiring Soon (3)               │
│  ┌─────────────────────────────┐   │
│  │ Product 1 - 2 days left     │   │
│  │ Product 2 - 5 days left     │   │
│  │ Product 3 - 7 days left     │   │
│  └─────────────────────────────┘   │
│                                     │
│  📊 Quick Stats                     │
│  ┌───────┬───────┬───────┐         │
│  │  24   │  3    │  2    │         │
│  │ Total │ Expiring │ Expired │    │
│  └───────┴───────┴───────┘         │
│                                     │
│  📦 Recent Products                 │
│  ┌─────────┐ ┌─────────┐           │
│  │ Product │ │ Product │           │
│  │   1     │ │   2     │           │
│  └─────────┘ └─────────┘           │
│                                     │
│  [   + Add Product   ]              │
│                                     │
└─────────────────────────────────────┘
```

#### Add Product Screen

```
┌─────────────────────────────────────┐
│  ← Add Product                      │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │    [📷 Scan Barcode]        │   │
│  │         OR                  │   │
│  │    [📸 Take Photo]          │   │
│  │         OR                  │   │
│  │    [✏️ Enter Manually]      │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  Product Name *                     │
│  ┌─────────────────────────────┐   │
│  │ Enter product name          │   │
│  └─────────────────────────────┘   │
│                                     │
│  Brand                              │
│  ┌─────────────────────────────┐   │
│  │ Enter brand name            │   │
│  └─────────────────────────────┘   │
│                                     │
│  Category *                         │
│  ┌─────────────────────────────┐   │
│  │ Skincare              ▼     │   │
│  └─────────────────────────────┘   │
│                                     │
│  Date Opened *                      │
│  ┌─────────────────────────────┐   │
│  │ April 7, 2026         📅   │   │
│  └─────────────────────────────┘   │
│                                     │
│  PAO (Months) *                     │
│  ┌─────────────────────────────┐   │
│  │ 12 months             ▼     │   │
│  └─────────────────────────────┘   │
│                                     │
│  [         Save Product       ]     │
│                                     │
└─────────────────────────────────────┘
```

### 6.6 Animation Guidelines

**Micro-interactions**:
- Duration: 0.2-0.3 seconds
- Easing: Ease-in-out
- Haptic feedback: Light impact

**Transitions**:
- Push/Pop: Default iOS navigation transition
- Modal: Slide up from bottom
- Tab switch: Crossfade (0.2s)

**Loading States**:
- Skeleton screens for content loading
- Progress indicators for uploads/scans
- Success/error animations

### 6.7 Accessibility

**Requirements**:
- VoiceOver support for all interactive elements
- Dynamic Type support (all text scalable)
- Minimum touch target: 44x44pt
- Color contrast ratio: 4.5:1 minimum
- Reduce motion support

**Implementation**:
```swift
Image(systemName: "checkmark.circle.fill")
    .accessibilityLabel("Product is safe to use")
    .accessibilityHint("Product has more than 30 days until expiry")
```

---

## 7. Implementation Workflow

### 7.0 Xcode Project Configuration (Based on Existing Empty Framework)

**Prerequisites**: You have already created an empty Xcode project with iOS 17+ support.

**Step 1: Configure Project Settings**

Open `freshface.xcodeproj` and configure:

1. **General Tab**:
   - **Display Name**: FreshFace
   - **Bundle Identifier**: `com.yourcompany.freshface` (replace with your actual identifier)
   - **Version**: 1.0 (Build: 1)
   - **Deployment Target**: iOS 17.0 (minimum)
   - **Device**: iPhone + iPad
   - **Team**: Select your Apple Developer Team
   - **Signing**: Automatic (or Manual with your certificate)

2. **Info Tab**:
   Add these keys to Info.plist:

   ```xml
   <!-- Camera Permission -->
   <key>NSCameraUsageDescription</key>
   <string>FreshFace needs camera access to scan product barcodes and capture product photos for automatic recognition.</string>

   <!-- Photo Library Permission -->
   <key>NSPhotoLibraryAddUsageDescription</key>
   <string>FreshFace needs permission to save product photos to your photo library.</string>

   <!-- Photo Library Read Permission -->
   <key>NSPhotoLibraryUsageDescription</key>
   <string>FreshFace needs access to your photo library to select existing product images.</string>

   <!-- Notifications Permission Description (iOS 15+) -->
   <key>NSUserNotificationsUsageDescription</key>
   <string>FreshFace sends notifications to remind you of expiring products and routine reminders.</string>

   <!-- Background Modes (if needed) -->
   <key>UIBackgroundModes</key>
   <array>
       <string>background-processing</string>
       <string>remote-notification</string>
   </array>
   ```

3. **Build Settings**:
   - Swift Language Version: 5.9+
   - iOS Deployment Target: 17.0
   - Enable Modules: Yes
   - Package Manager: Use default settings

**Step 2: Add Capabilities**

In Xcode, go to **Signing & Capabilities** tab, click **+ Capability**, add:

1. **iCloud**:
   - Check: CloudKit
   - Containers: `iCloud.com.yourcompany.freshface`
   - Purpose: Sync products across devices

2. **Push Notifications**:
   - Enable to send expiry reminders

3. **Background Modes** (optional):
   - Background fetch (for checking expiries)

**Note**: You need to manually configure these in Xcode's Signing & Capabilities tab.

**Step 3: Create Project Directory Structure**

```bash
# Navigate to project root
cd /Volumes/ORICO-APFS/app/20260407/freshface/freshface/freshface/

# Create directory structure following MVVM architecture
mkdir -p Presentation/Views/Home
mkdir -p Presentation/Views/Product
mkdir -p Presentation/Views/Scanner
mkdir -p Presentation/Views/Routine
mkdir -p Presentation/Views/Analytics
mkdir -p Presentation/Views/Settings
mkdir -p Presentation/ViewModels
mkdir -p Presentation/Coordinators
mkdir -p Domain/Entities
mkdir -p Domain/UseCases
mkdir -p Domain/RepositoryProtocols
mkdir -p Data/Repositories
mkdir -p Data/DataSources/Local
mkdir -p Data/DataSources/Remote
mkdir -p Data/Models/CoreData
mkdir -p Data/Models/API
mkdir -p Services/AI
mkdir -p Services/Notifications
mkdir -p Services/Sync
mkdir -p Services/Analytics
mkdir -p Utilities/Extensions
mkdir -p Utilities/Helpers
mkdir -p Utilities/Constants
```

**Step 4: Create Core Data Model File**

Create new file: `FreshFace.xcdatamodeld` in Resources folder.

**Step 5: Verify Project Configuration**

Before proceeding, verify:
- ✅ Project builds successfully (⌘+B)
- ✅ No warnings or errors
- ✅ Simulator launches app correctly (⌘+R)
- ✅ Basic SwiftUI view renders

---

### 7.1 Development Phases

#### Phase 1: Foundation (Week 1-2)

**Objectives**:
- Set up project structure
- Implement Core Data stack
- Create base UI framework

**Tasks**:
1. Initialize Xcode project with SwiftUI
2. Configure Core Data model
3. Set up MVVM architecture
4. Create base navigation structure
5. Implement dependency injection

**Deliverables**:
- ✅ Project structure complete
- ✅ Core Data models defined
- ✅ Basic navigation working
- ✅ Dependency injection container

---

#### Phase 2: Core Features (Week 3-4)

**Objectives**:
- Implement product CRUD operations
- Build expiry tracking system
- Create notification system

**Tasks**:
1. Implement Product Management module
2. Build Expiry Tracking module
3. Create Notification System module
4. Design and implement Home screen
5. Implement Product List and Detail views

**Deliverables**:
- ✅ Products can be added/edited/deleted
- ✅ Expiry dates calculated automatically
- ✅ Notifications scheduled correctly
- ✅ Home screen displays expiring products

---

#### Phase 3: AI Features (Week 5-6)

**Objectives**:
- Implement barcode scanning
- Build photo recognition
- Create PAO detection

**Tasks**:
1. Integrate Vision framework
2. Implement barcode scanner
3. Build photo recognition system
4. Train/integrate PAO detection model
5. Connect AI features to product creation

**Deliverables**:
- ✅ Barcode scanning works
- ✅ Photo recognition identifies products
- ✅ PAO symbols detected automatically
- ✅ Seamless integration with product creation

---

#### Phase 4: Advanced Features (Week 7-8)

**Objectives**:
- Implement routine management
- Build analytics system
- Create cloud sync

**Tasks**:
1. Build Routine Management module
2. Implement Analytics module
3. Integrate CloudKit for sync
4. Create settings and preferences
5. Implement usage tracking

**Deliverables**:
- ✅ Routines can be created and tracked
- ✅ Analytics dashboard shows insights
- ✅ Cloud sync works across devices
- ✅ Settings configurable

---

#### Phase 5: Polish & Testing (Week 9-10)

**Objectives**:
- UI/UX refinement
- Performance optimization
- Comprehensive testing

**Tasks**:
1. UI polish and animations
2. Performance profiling and optimization
3. Unit testing (80% coverage)
4. UI testing for critical flows
5. Accessibility audit

**Deliverables**:
- ✅ Polished UI with smooth animations
- ✅ Performance optimized
- ✅ Test coverage >80%
- ✅ Accessibility compliant

---

#### Phase 6: Launch Preparation (Week 11-12)

**Objectives**:
- App Store submission preparation
- Marketing materials
- Beta testing

**Tasks**:
1. Prepare App Store listing
2. Create screenshots and previews
3. Write App Store description
4. Set up TestFlight beta
5. Conduct beta testing
6. Address beta feedback

**Deliverables**:
- ✅ App Store listing ready
- ✅ Marketing materials complete
- ✅ Beta testing completed
- ✅ Critical issues resolved

---

### 7.2 Git Workflow

**Branch Strategy**:
```
main (production)
  └── develop (integration)
        ├── feature/product-management
        ├── feature/expiry-tracking
        ├── feature/ai-recognition
        ├── feature/notifications
        ├── feature/routines
        └── feature/analytics
```

**Commit Convention**:
```
feat: add product scanning feature
fix: resolve expiry calculation bug
refactor: clean up notification scheduler
docs: update API documentation
test: add unit tests for expiry calculator
chore: update dependencies
```

**Pull Request Process**:
1. Create feature branch from `develop`
2. Implement feature with tests
3. Create PR with description
4. Code review required
5. All tests must pass
6. Merge to `develop`
7. Squash and merge to `main` for release

---

## 8. Code Generation Rules & Standards

### 8.1 Naming Conventions

**Files**:
- Views: `[Feature]View.swift` (e.g., `ProductListView.swift`)
- ViewModels: `[Feature]ViewModel.swift`
- Use Cases: `[Action][Entity]UseCase.swift`
- Repositories: `[Entity]Repository.swift`
- Services: `[Purpose]Service.swift`

**Classes/Structs**:
- PascalCase: `ProductListView`, `ExpiryCalculator`
- Protocols: `[Purpose]able` or `[Entity]Repository`

**Functions/Methods**:
- camelCase: `calculateExpiryDate()`, `fetchProducts()`
- Clear, descriptive names
- Avoid abbreviations

**Variables**:
- camelCase: `productList`, `expiryDate`
- Booleans: `is`, `has`, `should` prefix (e.g., `isActive`, `hasExpired`)

**Constants**:
- camelCase for local: `defaultPAOMonths`
- PascalCase for global: `AppConstants.defaultPAO`

### 8.2 Code Organization

**Swift File Structure**:
```swift
// MARK: - Imports
import SwiftUI
import CoreData

// MARK: - View
struct ProductListView: View {
    // MARK: - Properties
    @StateObject private var viewModel: ProductViewModel
    
    // MARK: - Body
    var body: some View {
        // View implementation
    }
    
    // MARK: - Private Methods
    private func setupView() {
        // Setup logic
    }
}

// MARK: - Preview
#Preview {
    ProductListView()
}
```

**Class Structure**:
```swift
class ProductViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var products: [Product] = []
    
    // MARK: - Private Properties
    private let repository: ProductRepository
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(repository: ProductRepository) {
        self.repository = repository
        loadProducts()
    }
    
    // MARK: - Public Methods
    func loadProducts() {
        // Implementation
    }
    
    // MARK: - Private Methods
    private func handleError(_ error: Error) {
        // Error handling
    }
}

// MARK: - Extensions
extension ProductViewModel {
    // Additional functionality
}
```

### 8.3 Code Reusability Rules

**Rule of Three**:
- First occurrence: Write code
- Second occurrence: Copy code (note similarity)
- Third occurrence: Extract to reusable component/function

**Example - Before Extraction**:
```swift
// View 1
Text(product.name)
    .font(.headline)
    .foregroundColor(.primary)

// View 2
Text(product.name)
    .font(.headline)
    .foregroundColor(.primary)

// View 3
Text(product.name)
    .font(.headline)
    .foregroundColor(.primary)
```

**Example - After Extraction**:
```swift
struct ProductNameText: View {
    let name: String
    
    var body: some View {
        Text(name)
            .font(.headline)
            .foregroundColor(.primary)
    }
}

// Usage
ProductNameText(name: product.name)
```

### 8.4 Code Cleanup Standards

**When Replacing Code**:
1. Mark old code as deprecated:
```swift
@available(*, deprecated, message: "Use newMethod() instead")
func oldMethod() {
    // Old implementation
}
```

2. Verify no references:
```swift
// Search for all usages
// Ensure no compilation errors
```

3. Delete deprecated code:
```swift
// Remove old method completely
// Update all references to use new method
```

4. Document in commit:
```
refactor: replace oldMethod with newMethod

- Removed deprecated oldMethod
- Updated all references
- Improved performance by 20%
```

### 8.5 Documentation Standards

**Function Documentation**:
```swift
/// Calculates the expiry date based on opening date and PAO period
/// - Parameters:
///   - openDate: The date when the product was opened
///   - paoMonths: Period After Opening in months
/// - Returns: The calculated expiry date
/// - Note: PAO is typically indicated by a jar symbol with months (e.g., 6M, 12M)
static func calculateExpiryDate(openDate: Date, paoMonths: Int) -> Date {
    return Calendar.current.date(byAdding: .month, value: paoMonths, to: openDate) ?? openDate
}
```

**Class Documentation**:
```swift
/// Manages product expiry tracking and notifications
///
/// This class is responsible for:
/// - Calculating expiry dates
/// - Assessing risk levels
/// - Scheduling notifications
///
/// ## Example Usage
/// ```swift
/// let tracker = ExpiryTracker()
/// let expiryDate = tracker.calculateExpiryDate(openDate: Date(), paoMonths: 12)
/// ```
class ExpiryTracker {
    // Implementation
}
```

### 8.6 Error Handling

**Result Type**:
```swift
enum ProductError: Error {
    case notFound
    case invalidData
    case saveFailed
}

func fetchProduct(id: UUID) -> Result<Product, ProductError> {
    // Implementation
}
```

**Async/Await**:
```swift
func loadProducts() async throws {
    do {
        products = try await repository.fetchAll()
    } catch {
        throw ProductError.fetchFailed(error)
    }
}
```

### 8.7 Testing Standards

**Unit Test Structure**:
```swift
final class ExpiryCalculatorTests: XCTestCase {
    var sut: ExpiryCalculator!
    
    override func setUp() {
        super.setUp()
        sut = ExpiryCalculator()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - calculateExpiryDate Tests
    func testCalculateExpiryDate_WithValidInput_ReturnsCorrectDate() {
        // Given
        let openDate = Date()
        let paoMonths = 12
        
        // When
        let expiryDate = sut.calculateExpiryDate(openDate: openDate, paoMonths: paoMonths)
        
        // Then
        let expectedDate = Calendar.current.date(byAdding: .month, value: 12, to: openDate)
        XCTAssertEqual(expiryDate, expectedDate)
    }
}
```

**Test Coverage Requirements**:
- Use Cases: 100%
- ViewModels: 80%
- Services: 90%
- Utilities: 100%
- Overall: >80%

---

## 9. Testing & Acceptance Criteria

### 9.1 Unit Testing Checklist

#### Product Management Module

**Add Product**:
- ✅ Product saved successfully with all required fields
- ✅ Validation error for missing required fields
- ✅ Default values applied correctly
- ✅ Image saved and retrieved correctly

**Update Product**:
- ✅ Product updated successfully
- ✅ Updated date modified correctly
- ✅ Only changed fields updated

**Delete Product**:
- ✅ Product removed from database
- ✅ Related usage logs deleted
- ✅ Related routine items removed

**Fetch Products**:
- ✅ All products retrieved
- ✅ Filtered by category correctly
- ✅ Search works correctly
- ✅ Sorted by expiry date

---

#### Expiry Tracking Module

**Expiry Calculation**:
- ✅ Correct expiry date calculated
- ✅ Handles edge cases (leap year, month end)
- ✅ Returns nil for invalid input

**Risk Level Assessment**:
- ✅ Safe level (>30 days)
- ✅ Caution level (8-30 days)
- ✅ Warning level (4-7 days)
- ✅ Critical level (1-3 days)
- ✅ Expired level (≤0 days)

**Completion Prediction**:
- ✅ Predicts completion correctly
- ✅ Calculates recommended usage rate
- ✅ Handles zero usage frequency

---

#### Notification Module

**Notification Scheduling**:
- ✅ Notifications scheduled at correct times
- ✅ Multiple notifications for same product
- ✅ Notifications cancelled on product deletion
- ✅ Handles notification permission denied

**Notification Content**:
- ✅ Correct product name displayed
- ✅ Correct days remaining shown
- ✅ Deep link to product detail works

---

### 9.2 Integration Testing Checklist

**Product Creation Flow**:
1. ✅ User opens Add Product screen
2. ✅ User scans barcode
3. ✅ Product info auto-filled from API
4. ✅ User adjusts PAO if needed
5. ✅ User saves product
6. ✅ Product appears in list
7. ✅ Notification scheduled

**Expiry Warning Flow**:
1. ✅ Product approaching expiry
2. ✅ Notification triggered
3. ✅ User taps notification
4. ✅ Product detail opens
5. ✅ User can mark as used/discarded

**Routine Tracking Flow**:
1. ✅ User creates routine
2. ✅ Adds products to routine
3. ✅ Routine reminder triggered
4. ✅ User marks steps complete
5. ✅ Usage logged for each product

---

### 9.3 UI Testing Checklist

**Navigation**:
- ✅ Tab bar navigation works
- ✅ Push navigation works
- ✅ Modal presentation works
- ✅ Back navigation works

**Product List**:
- ✅ Products display correctly
- ✅ Scroll performance smooth
- ✅ Pull-to-refresh works
- ✅ Search filters correctly

**Add Product**:
- ✅ Form validation works
- ✅ Date picker works
- ✅ Category selector works
- ✅ Save button enabled/disabled correctly

**Scanner**:
- ✅ Camera permission requested
- ✅ Barcode scanning works
- ✅ Photo capture works
- ✅ Results display correctly

---

### 9.4 Performance Testing

**App Launch**:
- ✅ Cold launch < 2 seconds
- ✅ Warm launch < 1 second

**Product List**:
- ✅ Load 100 products < 500ms
- ✅ Scroll 60fps maintained
- ✅ Search response < 200ms

**Image Handling**:
- ✅ Image load < 1 second
- ✅ Memory usage < 100MB for 50 images
- ✅ Image compression optimized

**Database Operations**:
- ✅ Insert < 50ms
- ✅ Update < 50ms
- ✅ Delete < 50ms
- ✅ Fetch 100 items < 100ms

**Network Requests**:
- ✅ API response < 2 seconds
- ✅ Timeout handling works
- ✅ Retry logic works

---

### 9.5 Accessibility Testing

**VoiceOver**:
- ✅ All interactive elements accessible
- ✅ Labels descriptive and clear
- ✅ Hints provide context
- ✅ Navigation logical

**Dynamic Type**:
- ✅ All text scales correctly
- ✅ Layouts adapt to size changes
- ✅ No truncation at largest size

**Color Contrast**:
- ✅ Text meets 4.5:1 ratio
- ✅ Large text meets 3:1 ratio
- ✅ Status indicators distinguishable

**Motor Accessibility**:
- ✅ Touch targets ≥ 44x44pt
- ✅ Gestures have alternatives
- ✅ Switch Control compatible

---

### 9.6 User Acceptance Testing (UAT)

**Test Scenarios**:

**Scenario 1: New User Onboarding**
1. User downloads app
2. Opens app for first time
3. Sees onboarding tutorial
4. Adds first product
5. ✅ User can complete without help

**Scenario 2: Daily Usage**
1. User receives expiry notification
2. Opens app
3. Reviews expiring products
4. Updates usage status
5. ✅ User understands what to do

**Scenario 3: Product Management**
1. User wants to add new product
2. Scans barcode
3. Reviews auto-filled info
4. Saves product
5. ✅ Process takes < 30 seconds

**Scenario 4: Routine Tracking**
1. User creates morning routine
2. Adds 5 products
3. Receives reminder
4. Completes routine
5. ✅ All steps clear and easy

---

### 9.6 Test Execution Guide

**Running Unit Tests via Command Line**

```bash
# Navigate to project directory
cd /Volumes/ORICO-APFS/app/20260407/freshface/freshface

# Run all unit tests
xcodebuild test -scheme freshface \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.0' \
  -only-testing:freshfaceTests

# Run specific test file (e.g., ExpiryCalculator)
xcodebuild test -scheme freshface \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.0' \
  -only-testing:freshfaceTests/ExpiryCalculatorTests

# Run with code coverage report
xcodebuild test -scheme freshface \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.0' \
  -enableCodeCoverage YES \
  -resultBundlePath ./TestResults
```

**Running UI Tests**

```bash
# Run all UI tests
xcodebuild test -scheme freshface \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.0' \
  -only-testing:freshfaceUITests

# Run specific UI test (e.g., Product flow)
xcodebuild test -scheme freshface \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.0' \
  -only-testing:freshfaceUITests/ProductFlowTests
```

**Running Tests in Xcode GUI**

1. Open Xcode
2. Select **Product** → **Test** (⌘+U) to run all tests
3. Use Test Navigator (⌘+6) to:
   - View all test files and methods
   - Run individual tests by clicking diamond icon
   - Filter tests by name or status
4. View results in Report Navigator (⌘+9):
   - Click on test run to see details
   - Check coverage in Coverage tab (requires enable code coverage)

**Viewing Test Results & Coverage**

```bash
# Open coverage report in Xcode
open ./TestResults.xcresult

# Or view summary in terminal
xcrun xccov view --report --json ./TestResults.xcresult
```

**Continuous Integration (Optional)**

Create `.github/workflows/test.yml` for GitHub Actions:

```yaml
name: FreshFace Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    name: Run Tests
    runs-on: macos-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Select Xcode version
        uses: maxim-lobanov/setup-xcode@v1
        with:
          xcode-version: latest-stable
      
      - name: Run Unit Tests
        run: |
          xcodebuild test -scheme freshface \
            -destination 'platform=iOS Simulator,name=iPhone 15' \
            -enableCodeCoverage YES
      
      - name: Run UI Tests
        run: |
          xcodebuild test -scheme freshface \
            -destination 'platform=iOS Simulator,name=iPhone 15' \
            -only-testing:freshfaceUITests
```

**Test Execution Checklist Before Each Commit**

- [ ] All unit tests pass (>80% coverage)
- [ ] No failing tests
- [ ] New code has corresponding unit tests
- [ ] Critical user flows have UI tests
- [ ] Performance benchmarks within limits
- [ ] No accessibility regressions

---

### 9.7 Regression Testing

**Before Each Release**:
- ✅ All unit tests pass
- ✅ All integration tests pass
- ✅ All UI tests pass
- ✅ Performance benchmarks met
- ✅ No new accessibility issues
- ✅ Previous bugs not reintroduced

---

## 10. Development Roadmap

### 10.1 MVP Release (v1.0) - 8 Weeks

**Week 1-2: Foundation**
- [x] Project setup
- [x] Core Data implementation
- [x] Basic UI framework
- [x] Navigation structure

**Week 3-4: Core Features**
- [x] Product CRUD
- [x] Expiry calculation
- [x] Basic notifications
- [x] Product list view

**Week 5-6: AI Features**
- [x] Barcode scanning
- [x] Basic photo recognition
- [x] PAO detection
- [x] API integration

**Week 7-8: Polish & Launch**
- [x] UI refinement
- [x] Testing
- [x] Bug fixes
- [x] App Store submission

**MVP Features**:
- ✅ Manual product entry
- ✅ Barcode scanning
- ✅ Expiry tracking
- ✅ Basic notifications
- ✅ Product categories
- ✅ Search and filter

---

### 10.2 Standard Release (v1.5) - 4 Weeks

**Week 9-10: Advanced Features**
- [ ] Routine management
- [ ] Usage tracking
- [ ] Analytics dashboard
- [ ] Enhanced notifications

**Week 11-12: Cloud & Sync**
- [ ] iCloud integration
- [ ] CloudKit sync
- [ ] Conflict resolution
- [ ] Backup/restore

**Standard Features**:
- ✅ All MVP features
- ✅ Routine management
- ✅ Usage analytics
- ✅ Cloud sync
- ✅ Enhanced AI recognition

---

### 10.3 Premium Release (v2.0) - 4 Weeks

**Week 13-14: Premium Features**
- [ ] Product recommendations
- [ ] Advanced analytics
- [ ] Export data
- [ ] Multiple collections

**Week 15-16: Monetization**
- [ ] Subscription system
- [ ] IAP integration
- [ ] Premium features
- [ ] Family sharing

**Premium Features**:
- ✅ All Standard features
- ✅ AI recommendations
- ✅ Advanced analytics
- ✅ Data export
- ✅ Multiple collections
- ✅ Family sharing

---

### 10.4 Future Enhancements (v3.0+)

**Planned Features**:
- [ ] Social features (share routines)
- [ ] Product reviews integration
- [ ] AR product visualization
- [ ] Smart shopping list
- [ ] Integration with retailers
- [ ] Health app integration
- [ ] Apple Watch app
- [ ] Widget support

---

## 11. Apple App Store Compliance

### 11.1 App Store Requirements

**Minimum Requirements** (as of April 2025):
- ✅ Built with Xcode 16+
- ✅ iOS 18 SDK (or iOS 17 for backward compatibility)
- ✅ 64-bit architecture
- ✅ App Transport Security (ATS) compliance
- ✅ Privacy permissions justified

**App Store Review Guidelines**:

**1. Safety**
- ✅ No offensive content
- ✅ No user-generated content without moderation
- ✅ Clear age rating (4+)

**2. Performance**
- ✅ No crashes or bugs
- ✅ Fast launch time
- ✅ Efficient battery usage

**3. Business**
- ✅ Clear value proposition
- ✅ No misleading claims
- ✅ Transparent pricing

**4. Design**
- ✅ Follows Human Interface Guidelines
- ✅ Native iOS look and feel
- ✅ Intuitive navigation

**5. Legal**
- ✅ Privacy policy provided
- ✅ Terms of service
- ✅ Proper licensing

### 11.2 Privacy & Data Handling

**Data Collection**:
- Product information (user-entered)
- Product images (user-captured)
- Usage logs (locally stored)
- Preferences (locally stored)

**Data Storage**:
- Primary: Local (Core Data)
- Optional: iCloud (user-controlled)
- No third-party analytics (privacy-first)

**Privacy Permissions**:
```xml
<key>NSCameraUsageDescription</key>
<string>FreshFace needs camera access to scan product barcodes and capture product photos.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>FreshFace needs photo library access to save product images.</string>

<key>NSUserNotificationsUsageDescription</key>
<string>FreshFace sends notifications to remind you of expiring products.</string>
```

**Privacy Policy Requirements**:
- What data is collected
- How data is used
- How data is stored
- User rights (delete, export)
- Third-party services (Makeup API)

### 11.3 App Store Listing

**App Name**: FreshFace - Skincare Expiry Manager

**Subtitle**: Track Product Freshness & Stay Safe

**Keywords**: skincare, expiry, beauty, makeup, routine, tracker, PAO, cosmetics, freshness

**Description**:
```
Never Use Expired Skincare Again!

FreshFace is your intelligent skincare companion that helps you track product freshness, prevent health risks, and reduce waste.

KEY FEATURES:

🤖 AI-Powered Recognition
• Scan barcodes for instant product info
• Photo recognition for easy entry
• Automatic PAO symbol detection

⏰ Smart Expiry Tracking
• Automatic expiry date calculation
• Multi-level notifications (30/14/7/3/1 days)
• Risk level indicators

📊 Intelligent Insights
• Predict if you can finish products before expiry
• Usage analytics and statistics
• Personalized recommendations

🌅 Routine Management
• Plan morning & evening routines
• Track product usage
• Stay consistent with reminders

☁️ Privacy-First Design
• All data stored locally on your device
• Optional iCloud sync
• No account required

Perfect for skincare enthusiasts, beauty professionals, and anyone who wants to keep their products fresh and safe.

Download FreshFace today and take control of your skincare collection!
```

**Screenshots** (Required):
1. Home screen showing expiring products
2. Product list with categories
3. Barcode scanning in action
4. Product detail with expiry status
5. Routine management screen

**App Preview** (Optional but recommended):
- 15-30 second video showing key features
- Demonstrate barcode scanning
- Show notification flow

### 11.4 Age Rating

**Rating**: 4+ (Suitable for all ages)

**Justification**:
- No violence
- No sexual content
- No profanity
- No gambling
- No user-generated content
- Educational value (skincare safety)

### 11.5 In-App Purchases (Future)

**Premium Subscription**:
- Monthly: $4.99
- Yearly: $39.99 (33% savings)

**Premium Features**:
- Unlimited product tracking
- Advanced analytics
- Cloud sync
- Data export
- Multiple collections
- Priority support

---

## 12. Monetization Strategy

### 12.1 Revenue Model

**Freemium Model**:
- Free: Basic features (up to 20 products)
- Premium: Unlimited features ($4.99/month or $39.99/year)

**Value Proposition**:
- Free users get essential tracking
- Premium users get advanced features
- Clear upgrade path

### 12.2 Pricing Strategy

**Competitive Analysis**:
- FeelinMySkin: $49/year
- CosmeTick Premium: ~$50/year
- Smart Beauty Pro: $59.99/year

**FreshFace Pricing**:
- Monthly: $4.99 (competitive)
- Yearly: $39.99 (20% discount)
- Lifetime: $79.99 (future option)

**Justification**:
- Lower than competitors
- More features than free alternatives
- Clear value for premium features

### 12.3 Conversion Strategy

**Free Tier Limitations**:
- Max 20 products (enough to try)
- Basic notifications
- No cloud sync
- No advanced analytics

**Premium Upsell Points**:
- When reaching product limit
- When wanting cloud sync
- When needing analytics
- When wanting data export

**Trial Period**:
- 7-day free trial of Premium
- Full feature access
- No credit card required upfront

### 12.4 Marketing Strategy

**App Store Optimization (ASO)**:
- Keyword-optimized title and description
- High-quality screenshots
- Positive reviews (request after positive experience)
- Regular updates

**Social Media**:
- Instagram: Skincare tips, product features
- TikTok: Before/after, routine videos
- YouTube: Tutorials, reviews

**Influencer Partnerships**:
- Beauty bloggers
- Skincare influencers
- Makeup artists

**Content Marketing**:
- Blog posts on skincare safety
- Guides on product expiry
- Tips for sustainable beauty

---

## 13. Success Metrics & KPIs

### 13.1 Development Metrics

**Code Quality**:
- Test coverage: >80%
- Code review: 100% of PRs
- Bug rate: <5 bugs/1000 lines
- Technical debt: <10% of codebase

**Performance**:
- App launch: <2 seconds
- Screen load: <500ms
- API response: <2 seconds
- Memory usage: <150MB

### 13.2 User Metrics

**Acquisition**:
- Downloads: Target 10K in first month
- Conversion rate: >5% (free to premium)
- Cost per acquisition: <$2

**Engagement**:
- Daily active users (DAU): >20% of installs
- Monthly active users (MAU): >40% of installs
- Session duration: >3 minutes
- Products added per user: >5

**Retention**:
- Day 1 retention: >40%
- Day 7 retention: >25%
- Day 30 retention: >15%

**Revenue**:
- Monthly recurring revenue (MRR): Target $5K in month 3
- Average revenue per user (ARPU): $2/month
- Lifetime value (LTV): $20

### 13.3 Quality Metrics

**App Store Rating**:
- Target: >4.5 stars
- Response time to reviews: <24 hours
- Negative review rate: <5%

**Crash Rate**:
- Target: <0.1%
- ANR (App Not Responding): <0.05%

**Support**:
- Support ticket response: <24 hours
- Resolution rate: >90%
- User satisfaction: >4.5/5

---

## 14. Risk Management

### 14.1 Technical Risks

**Risk 1: AI Model Accuracy**
- **Impact**: High
- **Probability**: Medium
- **Mitigation**: 
  - Use multiple recognition methods
  - Allow manual correction
  - Continuous model improvement

**Risk 2: API Reliability**
- **Impact**: Medium
- **Probability**: Low
- **Mitigation**:
  - Cache API responses
  - Fallback to manual entry
  - Consider alternative APIs

**Risk 3: Data Loss**
- **Impact**: High
- **Probability**: Low
- **Mitigation**:
  - Core Data with CloudKit backup
  - Export functionality
  - Regular backups

### 14.2 Business Risks

**Risk 1: Low User Adoption**
- **Impact**: High
- **Probability**: Medium
- **Mitigation**:
  - Strong ASO strategy
  - Influencer partnerships
  - Free trial period

**Risk 2: Competition**
- **Impact**: Medium
- **Probability**: High
- **Mitigation**:
  - Unique AI features
  - Superior UX
  - Regular feature updates

**Risk 3: App Store Rejection**
- **Impact**: High
- **Probability**: Low
- **Mitigation**:
  - Follow guidelines strictly
  - Pre-submission checklist
  - Quick response to feedback

---

## 15. Post-Launch Plan

### 15.1 Immediate (Week 1-4)

**Monitoring**:
- Daily crash reports
- User feedback monitoring
- App Store reviews
- Support tickets

**Quick Wins**:
- Bug fixes (within 24-48 hours)
- UI improvements based on feedback
- Performance optimizations

### 15.2 Short-Term (Month 2-3)

**Feature Iterations**:
- Most requested features
- UI improvements
- Performance enhancements

**Marketing**:
- Influencer outreach
- Social media campaigns
- Content marketing

### 15.3 Long-Term (Month 4-6)

**Major Updates**:
- v1.5 release (routines, analytics)
- v2.0 release (premium features)
- Platform expansion (Apple Watch, Widgets)

**Scaling**:
- Localization (top markets)
- Feature expansion
- Partnership opportunities

---

## 16. Conclusion

FreshFace represents a significant opportunity in the growing skincare app market. By combining AI-powered recognition, smart expiry tracking, and a privacy-first approach, we can differentiate from competitors and provide genuine value to users.

**Key Success Factors**:
1. **Superior UX**: Intuitive, beautiful, native iOS design
2. **AI Innovation**: First-to-market PAO detection
3. **Privacy Focus**: Local-first data storage
4. **Clear Value**: Solve real user pain points
5. **Sustainable Business**: Freemium model with clear upgrade path

**Next Steps**:
1. Set up development environment
2. Clone and analyze ShelfLife repository
3. Begin Phase 1 development
4. Establish testing infrastructure
5. Create marketing materials

---

**Document Version History**:
- v1.0 (2026-04-07): Initial release

**Document Maintainer**: Development Team  
**Review Cycle**: Monthly  
**Next Review**: May 7, 2026
