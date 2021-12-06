/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

/// Handles retrieving and storing informed consent definitions as [RPOrderedTask]
/// json definitions.
abstract class InformedConsentManager {
  Future<void> initialize() async {}

  /// The latest downloaded informed consent document.
  ///
  /// Returns `null` if no consent has been downloaded yet.
  /// Use the [getInformedConsent] method to get the informed consent document
  /// from CARP.
  RPOrderedTask? get informedConsent;

  /// Get the informed consent to be shown for this study.
  ///
  /// This method return a [RPOrderedTask] which is an ordered list of [RPStep]
  /// which are shown to the user as the informed consent flow.
  /// See [research_package](https://pub.dev/packages/research_package) for a
  /// description on how to create an informed consent in the research package
  /// domain model.
  ///
  /// If there is no informed consent, `null` is returned.
  Future<RPOrderedTask?> getInformedConsent();

  /// Set the informed consent to be used for this study.
  Future<bool> setInformedConsent(RPOrderedTask informedConsent);

  /// Delete the informed consent for this study.
  ///
  /// Returns `true` if delete is successful, `false` otherwise.
  Future<bool> deleteInformedConsent();
}
