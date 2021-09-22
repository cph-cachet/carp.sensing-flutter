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
    bool canLaunchResetPasswordUrl = false,
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
              if (canLaunchResetPasswordUrl) _getResetPasswordButton(context),
            ],
          ),
        );
      }));

  Widget _getHeader() => Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Image.asset('asset/images/cachet_logo_new.png',
            package: 'carp_webservices'),
      );

  Form _getForm({String? username}) => Form(
      key: _formkey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: <Widget>[
          TextFormField(
            key: _usernameKey,
            initialValue: username,
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            validator: MultiValidator([
              RequiredValidator(errorText: "* Required"),
              CARPEmailValidator(errorText: "Enter valid email."),
            ]),
            decoration: InputDecoration(
              icon: Icon(Icons.account_circle),
              labelText: 'Username',
              hintText: 'Enter email as abc@cachet.dk',
            ),
          ),
          TextFormField(
            key: _passwordKey,
            validator: MultiValidator([
              RequiredValidator(errorText: "* Required"),
              MinLengthValidator(8, errorText: "At least 8 characters."),
            ]),
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Password',
              hintText: 'Enter password',
            ),
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
        style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
        child: Text(
          "LOGIN",
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      );

  OutlinedButton _getResetPasswordButton(BuildContext context) =>
      OutlinedButton(
        onPressed: () async {
          try {
            info("Reset password at url: '${CarpService.RESET_PASSWORD_URL}'");
            await launch(CarpService.RESET_PASSWORD_URL);
          } catch (exception) {
            warning('Exception in launching Reset Password URL - $exception');
          }
        },
        child: Text("Reset Password"),
      );
}
