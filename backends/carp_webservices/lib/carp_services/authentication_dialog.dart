/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// A modal dialog shown to the user to input username and password.
class AuthenticationDialog {
  var _usernameKey = GlobalKey<FormFieldState>();
  var _passwordKey = GlobalKey<FormFieldState>();
  String? get _username => _usernameKey.currentState?.value?.trim();
  String? get _password => _passwordKey.currentState?.value?.trim();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Dialog build(
    context, {
    String? username,
  }) =>
      Dialog(child: Builder(
          // Create an inner BuildContext so that the onPressed methods
          // can refer to the Scaffold with Scaffold.of().
          builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _getHeader(),
              _getForm(username: username),
              _getLoginButton(context),
              _getResetPasswordButton(context),
            ],
          ),
        );
      }));

  Widget _getHeader() => Padding(
        padding: const EdgeInsets.fromLTRB(32, 32, 32, 64),
        child: Image.asset(
          'asset/images/carp_logo.png',
          package: 'carp_webservices',
        ),
      );

  Form _getForm({String? username}) => Form(
      key: _formkey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AutofillGroup(
        child: Column(
          children: <Widget>[
            TextFormField(
              key: _usernameKey,
              autocorrect: false,
              initialValue: username,
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              validator: MultiValidator([
                RequiredValidator(errorText: "Required"),
                CARPEmailValidator(errorText: "Enter valid email."),
              ]),
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Username',
                hintText: 'Enter email as abc@cachet.dk',
              ),
              autofillHints: [
                AutofillHints.email,
                AutofillHints.username,
              ],
            ),
            TextFormField(
              key: _passwordKey,
              validator: MultiValidator([
                RequiredValidator(errorText: "Required"),
                MinLengthValidator(8, errorText: "At least 8 characters."),
              ]),
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'Password',
                hintText: 'Enter password',
              ),
              autofillHints: [
                AutofillHints.password,
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
              child: StreamBuilder(
                  stream: CarpService().authStateChanges,
                  builder: (BuildContext context,
                          AsyncSnapshot<AuthEvent> event) =>
                      (event.hasData && event.data == AuthEvent.failed)
                          ? Text(
                              'Sign in failed. Please retry.',
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            )
                          : Text('')),
            ),
          ],
        ),
      ));

  OutlinedButton _getLoginButton(BuildContext context) => OutlinedButton(
        onPressed: () async {
          try {
            CarpUser user = await CarpService()
                .authenticate(username: _username!, password: _password!);
            Navigator.pop(context, user);
          } catch (exception) {
            warning('Exception in authentication - $exception');
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
        child: Text(
          "Sign in",
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      );

  TextButton _getResetPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        try {
          info("Reset password at url: '${CarpService().resetPasswordUrl}'");
          await launchUrl(Uri(path: CarpService().resetPasswordUrl));
        } catch (exception) {
          warning('Exception in launching Reset Password URL - $exception');
        }
      },
      child: Text(
        "Reset Password",
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
