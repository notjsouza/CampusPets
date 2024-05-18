// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "e90609f79aab8c516feead44fc30a6b3"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Entry.self)
  }
}