// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension RegForm {
  static var entity: String = "reg_form"
}

extension RegForm {

  struct Keys {
    static let id = "id"
    static let eventId = "event_id"
    static let formName = "form_name"
    static let description = "description"
    static let regFields = "reg_fields"
  }
}

extension RegForm: ResponseRepresentable { }

extension RegForm: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.foreignId(for: Event.self, optional: false, unique: false, foreignIdKey: Keys.eventId, foreignKeyName: self.entity + "_" + Keys.eventId)
      builder.string(Keys.formName)
      builder.string(Keys.description)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension RegForm: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.eventId, eventId)
    try json.set(Keys.formName, formName)
    try json.set(Keys.description, description)
    try json.set(Keys.regFields, regFields().makeJSON())
    return json
  }
}
