import UIKit

public enum Images {
    //Main
    public static let user = Image(named: "user")

    private static func Image(named: String) -> UIImage {
        return UIImage(named: named, in: .main, with: nil)!
    }
}
