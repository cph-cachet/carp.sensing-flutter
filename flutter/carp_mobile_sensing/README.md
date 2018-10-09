# CARP Mobile Sensing Framework in Flutter

This library contains the software architecture for the CARP sensing framework implemented in Flutter/Dart.
Supporting cross-platform (iOS and Android) sensing.

## Ontology

The library makes use of a set of core concepts (i.e., classes).

Data collection is configures as a `Study`. A `Study` holds a set of `Task`s which again hold a set of `Measure`s.

    Study---*Task---*Meassure
    
A `Study` can be fetched via a `StudyManager`.
 
The `TaskExecutor` collects data for a `Task` as specified in the task's `Measure`s.
The TaskExecutor used a `Probe` for each `Measure`, and each probe collects a piece of data called a `Datum`.
Data (i.e., `Datum`s) are handed over to the task executor's `DataManager`.
 
There are four main types of probes:
 
 * `DatumProbe` -   a probe that collects one piece of data and then returns. 
                    Used to collect a single piece of information, which may take a while to collect. 
                    For example, network dependent sensors. 
 * `ListeningProbe` -   are triggered by a change in state within the underlying device or sensor. 
                        For example, the `AccelerometerProbe` register itself as a listener on the accelerometer and collects movement data via a callback method.
 * `PollingProbe` - are triggered at regular intervals, specified by its `interval` property in 
                    the `Measure`.
 * `SurveyProbe` -  can issue a survey for the user to fill out.
                    Is not implemented (yet).


  
## Usage


A simple test / usage example:

    To come...



## Extending the library

The main purpose of this library is to extend it with domain-specific studies, tasks, measures, probes, and datums (i.e., data).
This is done by implementing classes that inherits from the (abstract) classes in the library.

There are a couple of ways to extend the library according to the following scenarios.

#### Scenario #1 - Adding New Sensing Capabilities

If you want to add new sensing capabilities you would basically create new classes of 

* `Measure` - specifies what to collect and how.
* `Datum` - specifies the data model of the data collected
* `Probe` - specifies how data is collected

See e.g. the `task_executor.probes.location` folder for an example of how these three classes are created for sampling location data.

#### Scenario #2 - Adding a New Data and/or Study Manager

By implementing the interfaces (which actually are abstract classes in Dart) of `StudyManager` and `DataManager` you can create new ways 
to get a study protocol and to store data. 

The library also provide a `AuthenticationManager` interface. 
This can be used to implement authentication on a (remote) data and/or study manager. 




 
## Features and bugs

Please file feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing-flutter/issues

## License

This software is copyright (c) 2018 [Copenhagen Center for Health Technology (CACHET)](http://www.cachet.dk/) at the [Technical University of Denmark (DTU)](http://www.dtu.dk).
This software is made available 'as-is' in a MIT [license](/LICENSE).


