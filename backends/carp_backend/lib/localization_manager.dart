/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

/// Handles retrieving and storing language localization mappings.
abstract class LocalizationManager {
  Future initialize() async {}

  /// Get localization mapping as json for the specified [locale].
  ///
  /// Locale json is named according to the [locale] languageCode.
  /// For example, the Danish translation is named `da`
  ///
  /// If there is no language resource, `null` is returned.
  Future<Map<String, String>?> getLocalizations(Locale locale);

  /// Set localization mapping for the specified [locale].
  ///
  /// Locale json is named according to the [locale] languageCode.
  /// For example, the Danish translation is named `da`
  ///
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> setLocalizations(
      Locale locale, Map<String, dynamic> localizations);

  /// Delete the localization for the [locale].
  ///
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> deleteLocalizations(Locale locale);
}
