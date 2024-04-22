/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of 'carp_backend.dart';

/// Handles retrieving and storing language localization mappings.
abstract class LocalizationManager {
  Future<void> initialize() async {}

  /// Whether resources for the given [locale] can be loaded by this manager.
  ///
  /// Return true if the instance of `T` loaded by this delegate's [load]
  /// method supports the given `locale`'s language.
  bool isSupported(Locale locale);

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
