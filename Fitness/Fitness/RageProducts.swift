import Foundation
public struct RageProducts {
  public static let GirlfriendOfDrummerRage1 = "com.basila.Intermediatelevel"
  public static let GirlfriendOfDrummerRage2 = "com.basila.Advancedlevel"
  fileprivate static let productIdentifiers: Set<ProductIdentifier> = [RageProducts.GirlfriendOfDrummerRage1, RageProducts.GirlfriendOfDrummerRage2]
  public static let store = IAPHelper(productIds: RageProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}
