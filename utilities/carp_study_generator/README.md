# CARP Study Generator Utility Package

This utility package helps generate the configuration files needed for a CARP Mobile Sensing study, and uploading this to the CARP web server. 

## Configuration and Setup

To use the study generator, do the following in you app:

1. Include [`carp_study_generator`](https://pub.dev/packages/carp_study_generator) and [`test`](https://pub.dev/packages/test) as part of the `dev_dependencies` in the `pubspec.yaml` file.
1. Copy the folder `carp` to the root of you project.
1. Configure `carp.yaml`, and the json files `protocol.json`, `consent.json`, and the language json files (`en.json`, etc.).

## File Structure

All files used for creating and uploading configurations to CARP is stored in the `carp` folder in the root of your (app) project file. The name of the json files to upload is specified in the `carp.yaml` file.

| Folder |   Description |
|--------|---------------|
| `protocols` | The file(s) containing the json definition of your `StudyProtocol`. |  
| `consents` | The file(s) containing the json definition of your `RPOrderedTask` with the informed consent to show to the user. | 
| `lang` | The json language file for each language supported of the form `<language>.json`. | 

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
 protocol       Create a study protocol based on the file 'protocol.json' and uploads it to the CARP server.
 consent        Create an informed consent based on the file 'consent.json' and uploads it to the CARP server.
 localization   Create localization support based on the files '<locale>.json' and upload them to the CARP server.
````

Before uploading a any json files to CARP, run the `dryrun` command first. It will check and output a list like the following:

```bash
[!] Authenticating - CarpServiceException: 401 Unauthorized -  The requested email account: user@dtu.dk cannot be found. Request cannot be completed!
[✓] Protocol load - filename: carp/protocols/protocol.json
[!] Protocol parse - FormatException: Unexpected end of input (at character 1)
[✓] Consent load - filename: carp/consents/consent.json
[!] Consent parse - FormatException: Unexpected end of input (at character 1)
[✓] Locale - en
[✓] Locale - da
 •  3 issues found!
 ```



