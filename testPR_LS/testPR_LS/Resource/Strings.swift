import Foundation

public enum Strings {
    public static func Comments(_ value1: String) -> String {
        return label("Comments (%@)", value1)
    }
    
    public static let name = label("Name")
    public static let loading = label("Loading")
    
    private static func label(_ key: String, _ args: CVarArg...) -> String {
        let format = Bundle.main.localizedString(forKey: key, value: key, table: "Localizable")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}
