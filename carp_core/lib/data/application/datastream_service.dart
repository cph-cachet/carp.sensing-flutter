/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_data;

/// Store and retrieve data streams for study deployments.
abstract class DataStreamService {
  /// Start accepting data for a study deployment for data streams configured
  /// in [configuration].
  ///
  /// Throws IllegalStateException when data streams for the specified study
  /// deployment have already been configured.
  void openDataStreams(DataStreamsConfiguration configuration);

  /// Append a [batch] of data point sequences to corresponding data streams in [studyDeploymentId].
  ///
  /// Throws IllegalArgumentException when:
  ///  - the `studyDeploymentId` of one or more sequences in [batch] does not match [studyDeploymentId]
  ///  - the start of one or more of the sequences contained in [batch]
  ///  precede the end of a previously appended sequence to the same data stream
  ///  - [batch] contains a sequence with [DataStreamId] which wasn't configured for [studyDeploymentId]
  /// Throws IllegalStateException when data streams for [studyDeploymentId] have been closed.
  void appendToDataStreams(String studyDeploymentId, DataStreamBatch batch);

  /// Retrieve all data points in [dataStream] that fall within the inclusive range
  /// defined by [fromSequenceId] and [toSequenceIdInclusive].
  /// If [toSequenceIdInclusive] is null, all data points starting [fromSequenceId]
  /// are returned.
  ///
  /// In case no data for [dataStream] is stored in this repository, or is
  /// available for the specified range, an empty [DataStreamBatch] is returned.
  ///
  /// Throws IllegalArgumentException if:
  ///  - [dataStream] has never been opened
  ///  - [fromSequenceId] is negative or [toSequenceIdInclusive] is smaller than [fromSequenceId]
  DataStreamBatch getDataStream(
    DataStreamId dataStream,
    int fromSequenceId, [
    int? toSequenceIdInclusive,
  ]);

  /// Stop accepting incoming data for all data streams for each of the [studyDeploymentIds].
  ///
  /// Throws IllegalArgumentException when no data streams were ever opened for
  /// any of the [studyDeploymentIds].
  void closeDataStreams(List<String> studyDeploymentIds);

  /// Close data streams and remove all data for each of the [studyDeploymentIds].
  ///
  /// Returns the IDs of the study deployments for which data streams were configured.
  /// IDs for which no study deployment exists are ignored.
  Set<String> removeDataStreams(List<String> studyDeploymentIds);
}
