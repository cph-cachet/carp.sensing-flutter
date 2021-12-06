# CARP Study Generator Utility Package

This utility package helps generate the configuration files needed for a CARP Mobile Sensing study, and uploading this to the CARP web server. 

## Configuration and Setup

To use the study generator, do the following in you app:

1. Include [`carp_study_generator`](https://pub.dev/packages/carp_study_generator) and [`test`](https://pub.dev/packages/test) as part of the `dev_dependencies` in the `pubspec.yaml` file.
1. Copy the folder `carp` to the root of you project.
1. Configure `carpspec.yaml`, and the json files `protocol.json`, `consent.json`, and the message and language json files (`en.json`, etc.).

## Configuration of `carpspec.yaml`

The `carpspec.yaml` can be configured using the following properties for:

 * the CARP Server 
 * the study ID
 * the protocol
 * the informed consent
 * messages
 * language localizations

```yaml
server:
  uri: https://cans.cachet.dk
  client_id: carp
  client_secret: carp
  username: user@dtu.dk
  password: pw

# basic study ids
study:
  study_id: 01cf04a7-d154-40f0-9a75-ab759cf74eb3

# the location of the protocol to be uploaded
protocol:
  path: carp/resources/protocol.json

# the location of the informed consent to be uploaded
consent:
  path: carp/resources/consent.json

# configuration of the messages to be uploaded
message:
  # the location of the messages to be uploaded
  path: carp/messages/
  # list the messages to be uploaded 
  # add each message as a <name>.json file in the [path] folder
  messages: 
    - 1
    - 2

localization:
  path: carp/lang/
  # list the locales supported 
  # for each locale, a json file in the 'lang' folder must be added
  locales:
    - en
    - da
```

Note that the `carpspec.yaml` file contains username and password in clear text and hence **SHOULD NOT BE ADDED TO VERSION CONTOL** - add it to `.gitignore`.

## File Structure

All files used for creating and uploading configurations to CARP is stored in the `carp` folder in the root of your (app) project file. The name of the json files to upload is specified in the `carpspec.yaml` file (see above). The default file structure is:

| File                      |   Description |
|---------------------------|---------------|
| `resources/protocol.json` | JSON definition of your [`SmartphoneStudyProtocol`](https://pub.dev/documentation/carp_mobile_sensing/latest/domain/SmartphoneStudyProtocol-class.html). |  
| `resources/consent.json`  | JSON definition of your [`RPOrderedTask`](https://pub.dev/documentation/research_package/latest/research_package_model/RPOrderedTask-class.html) with the informed consent to show to the user. | 
| `lang/<language>.json`    | The JSON language file for each language supported of the form `<language>.json`. | 
| `messages/<name>.json`    | The name of each JSON message file to upload. | 

Please ignore the test scripts in the `carp` folder (these are used to execute the commands).

## Usage

Each command is run like this:

```bash
flutter test carp/<command>
```

The available commands are:

```bash
  help                   Prints this help message.
  dryrun                 Makes a dryrun testing access to the CARP server the correctness of the json resources.
  create                 Create a study protocol based on a json file and uploads it to the CARP server.
  update                 Update an existing study protocol as a new version.
  consent                Create an informed consent based on a json file and uploads it to the CARP server.
  localization           Upload the localization files to the CARP server.
  message                Upload the list of messages to the CARP server.
  message-delete-all     Delete all messages on the CARP server.
``` 

Before uploading a any json files to CARP, run the `dryrun` command first. It will check and output a list like the following:

```bash
[✓] CARP App             CarpApp - name: CARP server at 'https://cans.cachet.dk/dev', uri: https://cans.cachet.dk/dev, studyDeploymentId: null, studyId: 33441683-bbec-4c85-95de-b27aec09afce
[!] CARP Server          CarpServiceException: 401 Unauthorized -  Full authentication is required to access this resource - 
[✓] Protocol path        carp/resources/protocol.json
[✓] Protocol parse       name: CAMS App Study No. 2
[✓] Consent path         carp/resources/consent.json
[✓] Consent              identifier: consentTaskID
[✓] Locale - en          carp/lang/en.json
[✓] Locale - da          carp/lang/da.json
[✓] Message - 1          carp/messages/1.json
[✓] Message - 2          carp/messages/2.json
 •  1 issues found!
 ```



