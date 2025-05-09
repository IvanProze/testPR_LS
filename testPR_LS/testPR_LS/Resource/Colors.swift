import UIKit

public enum Colors {
    public static let main = Color(named: "Main")
    public static let secondMain = Color(named: "SecondMain")
    public static let text = Color(named: "Text")
    public static let subText = Color(named: "SubText")
    
    private static func Color(named: String) -> UIColor {
        return UIColor(named: named, in: .main, compatibleWith: nil)!
    }
}
