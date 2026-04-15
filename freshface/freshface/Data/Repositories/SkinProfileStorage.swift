import Foundation

class SkinProfileStorage {
    static let shared = SkinProfileStorage()

    private let userDefaults = UserDefaults.standard
    private let storageKey = "skinProfile"

    private init() {}

    func save(_ profile: SkinProfile) {
        if let encoded = try? JSONEncoder().encode(profile) {
            userDefaults.set(encoded, forKey: storageKey)
        }
    }

    func load() -> SkinProfile? {
        guard let data = userDefaults.data(forKey: storageKey),
              let profile = try? JSONDecoder().decode(SkinProfile.self, from: data) else {
            return nil
        }
        return profile
    }

    func clear() {
        userDefaults.removeObject(forKey: storageKey)
    }
}
