part of 'carp_services.dart';

/// Provide access to a CARP Web Services (CAWS) endpoints.
class CarpService extends CarpBaseService {
  static final CarpService _instance = CarpService._();
  CarpService._();

  /// Returns the singleton default instance of the [CarpService].
  /// Before this instance can be used, it must be configured using the
  /// [configure] method.
  factory CarpService() => _instance;
  CarpService.instance() : this._();

  // RPC is not used in the CarpService endpoints which are named differently.
  @override
  String get rpcEndpointName => throw UnimplementedError();

  // --------------------------------------------------------------------------
  // CONSENT DOCUMENT
  // --------------------------------------------------------------------------

  /// The URL for the consent document end point for this [CarpService].
  String get consentDocumentEndpointUri =>
      "${app.uri.toString()}/api/deployments/${app.studyDeploymentId}/consent-documents";

  /// Create a new (signed) consent document for this user.
  /// Returns the created [ConsentDocument] if the document is uploaded correctly.
  @Deprecated('The Informed Consent endpoints are deprecated in CAWS. '
      'Informed Consent is uploaded as [InformedConsentInput] participant input '
      'data using a [ParticipationReference].')
  Future<ConsentDocument> createConsentDocument(
      Map<String, dynamic> document) async {
    debug('REQUEST: POST $consentDocumentEndpointUri');

    // POST the document to the CARP web service
    http.Response response = await _post(
      consentDocumentEndpointUri,
      body: json.encode(document),
    );

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson =
        json.decode(response.body) as Map<String, dynamic>;

    if ((httpStatusCode == HttpStatus.ok) ||
        (httpStatusCode == HttpStatus.created)) {
      return ConsentDocument._(responseJson);
    }

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"].toString(),
      path: responseJson["path"].toString(),
    );
  }

  /// Get a previously uploaded (signed) [ConsentDocument] based on its [id].
  @Deprecated('The Informed Consent endpoints are deprecated in CAWS. '
      'Informed Consent is uploaded as [InformedConsentInput] participant input '
      'data using a [ParticipationReference].')
  Future<ConsentDocument> getConsentDocument(int id) async {
    String url = "$consentDocumentEndpointUri/$id";

    // GET the consent document from the CARP web service
    http.Response response = await _get(Uri.encodeFull(url));

    debug('RESPONSE: ${response.statusCode}\n${response.body}');

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson =
        json.decode(response.body) as Map<String, dynamic>;

    if (httpStatusCode == HttpStatus.ok) return ConsentDocument._(responseJson);

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"].toString(),
      path: responseJson["path"].toString(),
    );
  }

  // --------------------------------------------------------------------------
  // DATA POINT
  // --------------------------------------------------------------------------

  /// Creates a new [DataPointReference] initialized at the current
  /// CarpService storage location.
  @Deprecated('The DataPoint endpoints is deprecated in CAWS. '
      'Data should be uploaded using the CARP-Core Data Stream endpoint.')
  DataPointReference getDataPointReference() => DataPointReference._(this);

  // --------------------------------------------------------------------------
  // FILES
  // --------------------------------------------------------------------------

  /// The URL for the file end point for this [CarpService].
  String get fileEndpointUri =>
      "${app.uri.toString()}/api/studies/${app.studyId}/files";

  /// Get a [FileStorageReference] that reference a file at the current
  /// CarpService storage location.
  /// [id] can be omitted if a local file is not uploaded yet.
  FileStorageReference getFileStorageReference([int id = -1]) =>
      FileStorageReference._(this, id);

  /// Get a [FileStorageReference] that reference a file with the original name
  /// [name] at the current CarpService storage location.
  ///
  /// If more than one file with the same name exists, the first one is returned.
  /// If no files with that name exists, `null` is returned.
  Future<FileStorageReference?> getFileStorageReferenceByName(
      String name) async {
    final List<CarpFileResponse> files =
        await queryFiles('original_name==$name');

    return (files.isNotEmpty)
        ? FileStorageReference._(this, files[0].id)
        : null;
  }

  /// Get all file objects in the study.
  Future<List<CarpFileResponse>> getAllFiles() async => await queryFiles();

  /// Returns file objects in the study based on a [query].
  ///
  /// If [query] is omitted, all file objects are returned.
  Future<List<CarpFileResponse>> queryFiles([String? query]) async {
    final String url =
        (query != null) ? "$fileEndpointUri?query=$query" : fileEndpointUri;

    http.Response response =
        await httpr.get(Uri.encodeFull(url), headers: headers);
    int httpStatusCode = response.statusCode;

    switch (httpStatusCode) {
      case HttpStatus.ok:
        {
          List<dynamic> list = json.decode(response.body) as List<dynamic>;
          List<CarpFileResponse> fileList = [];
          for (var element in list) {
            fileList.add(CarpFileResponse._(element as Map<String, dynamic>));
          }
          return fileList;
        }
      default:
        // All other cases are treated as an error.
        {
          Map<String, dynamic> responseJson =
              json.decode(response.body) as Map<String, dynamic>;
          throw CarpServiceException(
            httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
            message: responseJson["message"].toString(),
            path: responseJson["path"].toString(),
          );
        }
    }
  }

  // --------------------------------------------------------------------------
  // DOCUMENTS & COLLECTIONS
  // --------------------------------------------------------------------------

  /// Gets a [DocumentReference] for the specified unique id.
  DocumentReference documentById(int id) => DocumentReference._id(this, id);

  /// Gets a [DocumentReference] for the specified [path].
  DocumentReference document(String path) =>
      DocumentReference._path(this, path);

  /// The URL for the document end point for this [CarpService].
  String get documentEndpointUri =>
      "${app.uri.toString()}/api/studies/${app.studyId}/documents";

  /// Get a list documents based on a query.
  ///
  /// The [query] string uses the RSQL query language for RESTful APIs.
  /// See the [RSQL Documentation](https://developer.here.com/documentation/data-client-library/dev_guide/client/rsql.html).
  ///
  /// Can only be accessed by users who are authenticated as researchers.
  Future<List<DocumentSnapshot>> documentsByQuery(String query) async {
    // GET the list of documents in this collection from the CARP web service
    http.Response response = await httpr.get(
        Uri.encodeFull('$documentEndpointUri?query=$query'),
        headers: headers);
    int httpStatusCode = response.statusCode;

    if (httpStatusCode == HttpStatus.ok) {
      List<dynamic> documentsJson = json.decode(response.body) as List<dynamic>;
      List<DocumentSnapshot> documents = [];
      for (var item in documentsJson) {
        Map<String, dynamic> documentJson = item as Map<String, dynamic>;
        String key = documentJson["name"].toString();
        documents.add(DocumentSnapshot._(key, documentJson));
      }
      return documents;
    }

    // All other cases are treated as an error.
    Map<String, dynamic> responseJson =
        json.decode(response.body) as Map<String, dynamic>;
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"].toString(),
      path: responseJson["path"].toString(),
    );
  }

  /// Get all documents for this study.
  ///
  /// Can only be accessed by users who are authenticated as researchers.
  ///
  /// Note that this might return a very long list of documents and the
  /// request may time out.
  Future<List<DocumentSnapshot>> documents() async {
    http.Response response =
        await httpr.get(Uri.encodeFull(documentEndpointUri), headers: headers);
    int httpStatusCode = response.statusCode;

    if (httpStatusCode == HttpStatus.ok) {
      List<dynamic> documentsJson = json.decode(response.body) as List<dynamic>;
      List<DocumentSnapshot> documents = [];
      for (var item in documentsJson) {
        Map<String, dynamic> documentJson = item as Map<String, dynamic>;
        String key = documentJson["name"].toString();
        documents.add(DocumentSnapshot._(key, documentJson));
      }
      return documents;
    }

    // All other cases are treated as an error.
    Map<String, dynamic> responseJson =
        json.decode(response.body) as Map<String, dynamic>;
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"].toString(),
      path: responseJson["path"].toString(),
    );
  }

  /// Gets a [CollectionReference] for the specified [path].
  CollectionReference collection(String path) =>
      CollectionReference._(this, path);
}
