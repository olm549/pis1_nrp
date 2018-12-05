import 'dart:async';

import 'package:aqueduct/aqueduct.dart';   

class Migration1 extends Migration { 
  @override
  Future upgrade() async {
   database.createTable(SchemaTable("_authclient", [
SchemaColumn("id", ManagedPropertyType.string, isPrimaryKey: true, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("hashedSecret", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false),
SchemaColumn("salt", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false),
SchemaColumn("redirectURI", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: true),
SchemaColumn("allowedScope", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false),
],
));

database.createTable(SchemaTable("_User", [
SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("username", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: true),
SchemaColumn("hashedPassword", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("salt", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
],
));

database.createTable(SchemaTable("_Project", [
SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("projectID", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: true),
SchemaColumn("name", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("description", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("effortLimit", ManagedPropertyType.doublePrecision, isPrimaryKey: false, autoincrement: false, defaultValue: "0.0", isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("active", ManagedPropertyType.boolean, isPrimaryKey: false, autoincrement: false, defaultValue: "false", isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn.relationship("owner", ManagedPropertyType.bigInteger, relatedTableName: "_User", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: true, isUnique: false),
],
));

database.createTable(SchemaTable("_Client", [
SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("clientID", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: true),
SchemaColumn("name", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("surname", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
],
));

database.createTable(SchemaTable("_ProjectClient", [
SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("weight", ManagedPropertyType.doublePrecision, isPrimaryKey: false, autoincrement: false, defaultValue: "0.0", isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn.relationship("project", ManagedPropertyType.bigInteger, relatedTableName: "_Project", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: true, isUnique: false),
SchemaColumn.relationship("client", ManagedPropertyType.bigInteger, relatedTableName: "_Client", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: true, isUnique: false),
],
));

database.createTable(SchemaTable("_Requirement", [
SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("requirementID", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: true),
SchemaColumn("title", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("description", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
],
));

database.createTable(SchemaTable("_authtoken", [
SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("code", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: true, isUnique: true),
SchemaColumn("accessToken", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: true, isUnique: true),
SchemaColumn("refreshToken", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: true, isUnique: true),
SchemaColumn("scope", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false),
SchemaColumn("issueDate", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("expirationDate", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: false),
SchemaColumn("type", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: true, isUnique: false),
SchemaColumn.relationship("resourceOwner", ManagedPropertyType.bigInteger, relatedTableName: "_User", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: false, isUnique: false),
SchemaColumn.relationship("client", ManagedPropertyType.string, relatedTableName: "_authclient", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: false, isUnique: false),
],
));

database.createTable(SchemaTable("_ProjectRequirement", [
SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("estimatedEffort", ManagedPropertyType.doublePrecision, isPrimaryKey: false, autoincrement: false, defaultValue: "0.0", isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("satisfaction", ManagedPropertyType.doublePrecision, isPrimaryKey: false, autoincrement: false, defaultValue: "0.0", isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn.relationship("project", ManagedPropertyType.bigInteger, relatedTableName: "_Project", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: true, isUnique: false),
SchemaColumn.relationship("requirement", ManagedPropertyType.bigInteger, relatedTableName: "_Requirement", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: true, isUnique: false),
],
));

database.createTable(SchemaTable("_RequirementValue", [
SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn("value", ManagedPropertyType.doublePrecision, isPrimaryKey: false, autoincrement: false, defaultValue: "0.0", isIndexed: false, isNullable: false, isUnique: false),
SchemaColumn.relationship("project", ManagedPropertyType.bigInteger, relatedTableName: "_Project", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: true, isUnique: false),
SchemaColumn.relationship("requirement", ManagedPropertyType.bigInteger, relatedTableName: "_Requirement", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: true, isUnique: false),
SchemaColumn.relationship("client", ManagedPropertyType.bigInteger, relatedTableName: "_Client", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: true, isUnique: false),
],
));


  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    