// swiftlint:disable all
import Amplify
import Foundation

extension Entry {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case description
    case image
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let entry = Entry.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Entries"
    model.syncPluralName = "Entries"
    
    model.attributes(
      .primaryKey(fields: [entry.id])
    )
    
    model.fields(
      .field(entry.id, is: .required, ofType: .string),
      .field(entry.name, is: .required, ofType: .string),
      .field(entry.description, is: .optional, ofType: .string),
      .field(entry.image, is: .optional, ofType: .string),
      .field(entry.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(entry.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Entry: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}