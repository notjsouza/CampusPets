// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "3d16ed16b6277aa6578cda6ffce33950"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Entry.self)
  }
}