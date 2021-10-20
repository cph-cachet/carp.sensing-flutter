# CARP Study Generator Utility Package

This utility package helps generate the configuration files needed for a CARP Mobile Sensing study, and uploading this to the CARP web server. 

## Configuration and Setup

To use the study generator, do the following in you app:

1. Include [`carp_study_generator`](https://pub.dev/packages/carp_study_generator) and [`test`](https://pub.dev/packages/test) as part of the `dev_dependencies` in the `pubspec.yaml` file.
1. Copy the folder `carp` to the root of you project.
1. Configure `carpspec.yaml`, and the json files `protocol.json`, `consent.json`, and the language json files (`en.json`, etc.).

## Configuration of `carpspec.yaml`

The `carpspec.yaml` can be configured using the following properties for:

 * the CARP Server 
 * the study ID
 * the protocol
 * the informed consent
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
  study_deployment_id: ae8076a3-7170-4bcf-b66c-64639a7a9eee

# the location of the protocol to be uploaded
protocol:
  path: carp/resources/protocol.json

# the location of the informed consent to be uploaded
consent:
  path: carp/resources/consent.json

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

Please ignore the test scripts in the `carp` folder (these are used to execute the commands).

## Usage

Each command is run like this:

```bash
flutter test carp/<command>
```

The available commands are:

```bash
  help           Prints this help message.
  dryrun         Makes a dryrun testing access to the CARP server, and the protocol, consent, and localizations.
  create         Create a study protocol based on a json file and uploads it to the CARP server.
  update         Update an existing study protocol based on a json file and uploads it to the CARP server as a new version.
  consent        Create an informed consent based on a json file and uploads it to the CARP server.
  localization   Create localization support based on the files '<locale>.json' and upload them to the CARP server.
``` 

Before uploading a any json files to CARP, run the `dryrun` command first. It will check and output a list like the following:

```bash
[✓] CARP App             CarpApp - name: CARP server at 'https://cans.cachet.dk/', uri: https://cans.cachet.dk/, studyDeploymentId: null, studyId: 7be8da9b-7e8f-46c6-a070-d3fa186914a2
[!] CARP Server          CarpServiceException: 401 Unauthorized -  The requested email account: user@dtu.dk cannot be found. 
[✓] Protocol path        carp/protocols/protocol.json
[✓] Protocol parse       name: test_protocol
[✓] Consent path         carp/consents/consent.json
[!] Consent parse        FormatException: Unexpected end of input (at character 1)
[✓] Locale - en          carp/lang/en.json
[✓] Locale - da          carp/lang/da.json
 •  2 issues found!
 ```



