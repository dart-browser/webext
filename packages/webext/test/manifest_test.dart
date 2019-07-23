import 'package:test/test.dart';
import 'package:webext/manifest.dart';

void main() {
  group("Manifest:", () {
    final json = <String, Object>{
      "manifest_version": 2,
      "name": "hello",
      "version": "0.0.1",
      "permissions": ["permission_0", "permission_1"],
      "optional_permissions": [
        "optional_permission_0",
        "optional_permission_1"
      ],
    };

    test("Deserialize a simple example", () {
      final manifest = Manifest()..fromJson(json);
      expect(manifest.manifestVersion, 2);
      expect(manifest.name, "hello");
      expect(manifest.version, "0.0.1");
      expect(manifest.permissions, ["permission_0", "permission_1"]);
      expect(manifest.optionalPermissions,
          ["optional_permission_0", "optional_permission_1"]);
      expect(manifest.toJson(), json);
    });

    test("Serialize a simple example", () {
      final manifest = Manifest()..fromJson(json);
      expect(manifest.toJson(), json);
    });
  });
}
