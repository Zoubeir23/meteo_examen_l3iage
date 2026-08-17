import Foundation

/// Clé Google Maps lue depuis Info.plist (`GMSApiKey`), elle-même alimentée
/// par `MapsKey.xcconfig` (gitignored, voir `MapsKey.xcconfig.example` et le
/// README). Ce fichier ne contient jamais de secret et compile toujours,
/// même sans clé configurée localement (la valeur est alors simplement
/// vide).
enum ApiKeys {
    static var googleMaps: String {
        Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String ?? ""
    }
}
