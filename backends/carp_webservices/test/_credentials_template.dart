// ====================================================================//
//                                                                     //
//                DO NOT CHECK IN TO VERSION CONTROL!                  //
//                                                                     //
//  This file contains confidential authentication information to CARP //
//                                                                     //
// ====================================================================//

// This file contains a template for properties needed for unit testing.
// Fill in the details below and rename the file to 'credentials.dart'.
// HOWEVER, remember to add the file to .gitignore in order not to commit
// the authentication details.

const String cawsUri = 'dev.carp.dk';

// Username + password for the user doing the testing
const String username = 'a_username';
const String password = 'the_password';

// Protocol details
//
// Non-motorized transport study
// - define the role names in the protocol, since they are used across
//   all sub-services
const phoneRoleName = "Participant's phone";
const bikeRoleName = "Participant's bike";
const testProtocolId = '24f45a10-ae25-11ed-9d8a-f37a675e7b0c';
const testProtocolVersion = '3.0';

// The IDs for a specific study created in CAWS
const testStudyId = '851b6b23-0e1f-4952-ae7e-1cd9581a4a84';
const testDeploymentId = 'e76c4f3a-5f10-4233-832d-eadc2d974159';
