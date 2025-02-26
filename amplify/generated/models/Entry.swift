// swiftlint:disable all
import Amplify
import Foundation

public struct Entry: Model, Identifiable {
  public let id: String
  public var name: String
  public var description: String?
  public var image: String?
  public var latitude: Double?
  public var longitude: Double?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      name: String,
      description: String? = nil,
      image: String? = nil,
      latitude: Double? = nil,
      longitude: Double? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.description = description
      self.image = image
      self.latitude = latitude
      self.longitude = longitude
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}
