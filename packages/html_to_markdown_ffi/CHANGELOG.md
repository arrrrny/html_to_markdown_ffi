# Changelog

## 1.1.0

- Zuraffa-native rebuild (spec 064 / epic #214): the preserved public API
  (`convert`, options, results, visitor, exceptions) now backed by the
  zuraffa stack — port, service, generated domain, and a native datasource
  wrapping the existing dart:ffi bridge.
- Native binaries moved to the federated adapters (byte-identical
  artifacts); the loader chain is preserved with an additive resolver seam.

## 1.0.0

- Initial zuraffa-native scaffold (`zfa package create-plugin`).
