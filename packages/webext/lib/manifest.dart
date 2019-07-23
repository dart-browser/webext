library webext.manifest;

/// Manifest object that supports JSON deserialization/serialization.
class Manifest extends ManifestObjectElement {
  int manifestVersion = 2;
  String name = "";
  String version = "";
  String description;
  String homepageUrl;
  String contentSecurityPolicy;
  final List<String> permissions = <String>[];
  final List<String> optionalPermissions = <String>[];

  BrowserSpecificSettings browserSpecificSettings;

  Manifest();

  void validate() {
    if (manifestVersion == null || manifestVersion < 2) {
      throw StateError(
          "Manifest property 'manifest_version' must be 2 or greater");
    }
    if (name == null || name.isEmpty) {
      throw StateError("Manifest property 'name' must be non-blank");
    }
    if (version == null || version.isEmpty) {
      throw StateError("Manifest property 'version' must be non-blank");
    }
  }

  void fromJsonObject(Map<String, Object> json) {
    for (var entry in json.entries) {
      final value = entry.value;
      switch (entry.key) {
        case "browser_specific_settings":
          browserSpecificSettings = BrowserSpecificSettings()..fromJson(value);
          break;

        case "content_security_policy":
          contentSecurityPolicy = value as String;
          break;

        case "description":
          description = value as String;
          break;

        case "homepage_url":
          homepageUrl = value as String;
          break;

        case "manifest_version":
          manifestVersion = (value as num).toInt();
          break;

        case "name":
          name = value as String;
          break;

        case "permissions":
          permissions.addAll((value as List).cast<String>());
          break;

        case "optional_permissions":
          optionalPermissions.addAll((value as List).cast<String>());
          break;

        case "version":
          version = value as String;
          break;

        default:
          additionalProperties[entry.key] = value;
          break;
      }
    }
  }

  @override
  void toJsonObject(Map<String, Object> json) {
    // Browser specific settings
    _putIfNotNull(json, "browser_specific_settings", browserSpecificSettings);

    // Content Security Policy
    _putIfNotNull(json, "content_security_policy", contentSecurityPolicy);

    // Homepage URL
    _putIfNotNull(json, "homepage_url", homepageUrl);

    // Manifest version
    json["manifest_version"] = manifestVersion;

    // Name
    json["name"] = name;

    // Permissions
    if (permissions.isNotEmpty) {
      json["permissions"] = permissions;
    }

    // Optional permissions
    if (permissions.isNotEmpty) {
      json["optional_permissions"] = optionalPermissions;
    }

    // Version
    json["version"] = version;

    // Other properties
    super.toJsonObject(json);
  }
}

class BrowserSpecificSettings extends ManifestObjectElement {
  GeckoSettings gecko;

  @override
  void fromJsonObject(Map<String, Object> json) {
    for (var entry in json.entries) {
      final value = entry.value;
      switch (entry.key) {
        case "gecko":
          gecko = GeckoSettings()..fromJsonObject(value);
          break;

        default:
          additionalProperties[entry.key] = value;
          break;
      }
    }
  }

  @override
  Map<String, Object> toJsonObject(Map<String, Object> json) {
    json ??= <String, Object>{};
    _putIfNotNull(json, "gecko", gecko?.toJsonObject());
    super.toJsonObject(json);
    return json;
  }
}

class GeckoSettings extends ManifestObjectElement {
  String id;

  GeckoSettings();

  @override
  void fromJsonObject(Map<String, Object> json) {
    for (var entry in json.entries) {
      final value = entry.value;
      switch (entry.key) {
        case "id":
          id = value as String;
          break;

        default:
          additionalProperties[entry.key] = value;
          break;
      }
    }
  }

  Map<String, Object> toJsonObject([Map<String, Object> json]) {
    json ??= <String, Object>{};
    _putIfNotNull(json, "id", id);
    super.toJsonObject(json);
    return json;
  }
}

/// Abstract superclass for JSON objects in the manifest document.
abstract class ManifestObjectElement {
  ManifestObjectElement();

  /// Other properties
  final Map<String, Object> additionalProperties = <String, Object>{};

  /// Converts from JSON.
  ///
  /// If the manifest is invalid, throws [CastError] or [ArgumentError].
  void fromJson(Object json) {
    if (json is Map<String, Object>) {
      fromJsonObject(json);
    } else {
      throw ArgumentError.value(json);
    }
  }

  /// Converts from JSON object. Called by [fromJson].
  ///
  /// If the manifest is invalid, throws [CastError] or [ArgumentError].
  void fromJsonObject(Map<String, Object> json);

  /// Converts to JSON object. Called by [toJson].
  void toJsonObject(Map<String, Object> json) {
    additionalProperties.forEach((k, v) {
      if (json.containsKey(k)) {
        throw StateError("Additional keys can't contain '$k'");
      }
      json[k] = v;
    });
  }

  /// Converts to JSON.
  Map<String, Object> toJson() {
    final json = <String, Object>{};
    toJsonObject(json);
    return json;
  }
}

void _putIfNotNull(Map<String, Object> json, String key, Object value) {
  if (value != null) {
    json[key] = value;
  }
}
