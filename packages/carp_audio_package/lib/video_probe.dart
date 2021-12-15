/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of audio;

/// A probe that captures a video or image.
///
/// This probes does not in itself capture the video/image. It merely takes
/// a video/image file and wraps it into a [VideoDatum].
///
/// The video probe generates an [VideoDatum] that holds the meta-data for each
/// recording along with the actual recording in an video file.
/// How to upload this data to a data backend is up to the implementation of the
/// [DataManager], which is used in the [Study].
class VideoProbe extends DatumProbe {
  @override
  Future<Datum?> getDatum() async =>
      null; // the datum is created in the app from the VideoUserTask
}
