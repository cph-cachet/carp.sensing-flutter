# CARP Study Generator Utility Package

This utility package helps generate the configuration files needed for a CARP Mobile Sensing study, and uploading this to the CARP web server. 

## Configuration and Setup

1. Include `carp_study_generator` as part of the `dependencies` in the `pubspec.yaml` file.
1. Include `test` as part of the `dev_dependencies` in the `pubspec.yaml` file.
1. Copy the folder `carp` to the root of you project.

## Usage

Each command is run like this:

```
  flutter test carp/<command>
```

The available commands are:

```
  help           Prints this help message.
  create         Create the configuration files for a CAMS study.
  protocol       Create a study protocol based on the file 'protocol.dart' and uploads it to the CARP server.
  consent        Create an informed consent based on the file 'consent.dart' and uploads it to the CARP server.
  localization   Create localization support based on the files '<locale>.json' and upload them to the CARP server.
````

## File Structure

All files used for creating and uploading configurations to CARP is stored in the `carp` folder in the root of your (app) project file. 

| File      | Folder |   Description |
|-----------|--------|---------------|
| `StudyProtocol.dart` | `protocol` | The dart file containing the definition of your `StudyProtocol`. | 
| `Consent.dart` | `consent` | The dart file containing the definition of your `RPOrderedTask` with the informed consent to show to the user. | 
| `<language>.json` | `lang` | The json language file for each language supported. | 

Please ignore the test scripts in the `carp` folder (these are used to execute the commands).

