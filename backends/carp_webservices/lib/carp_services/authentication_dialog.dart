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
      Dialog.fullscreen(
          child: Builder(
              // Create an inner BuildContext so that the onPressed methods
              // can refer to the Scaffold with Scaffold.of().
              builder: (BuildContext context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        _getHeader(),
                        SizedBox(height: 150),
                        _getForm(username: username),
                        _getLoginButton(context),
                        _getResetPasswordButton(context),
                        if (CarpService()._app!.baseUri.path.isNotEmpty)
                          _getEnvironmentText(context),
                      ],
                    ),
                  )));

  Widget _getHeader() => Container(
        height: 150.0,
        width: 190.0,
        padding: EdgeInsets.only(top: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
        ),
        child: Center(
          child: Image.asset(
            'asset/images/carp_logo.png',
            package: 'carp_webservices',
          ),
        ),
      );

  Form _getForm({String? username}) => Form(
      key: _formkey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AutofillGroup(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
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
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                  prefixIcon: Icon(Icons.account_circle_outlined),
                  labelText: 'Username',
                  hintText: 'Enter email as abc@cachet.dk',
                ),
                autofillHints: [
                  AutofillHints.email,
                  AutofillHints.username,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                key: _passwordKey,
                validator: MultiValidator([
                  RequiredValidator(errorText: "Required"),
                  MinLengthValidator(8, errorText: "At least 8 characters."),
                ]),
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                  labelText: 'Password',
                  hintText: 'Enter password',
                ),
                autofillHints: [
                  AutofillHints.password,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                  stream: CarpService().authStateChanges,
                  builder: (BuildContext context,
                          AsyncSnapshot<AuthEvent> event) =>
                      (event.hasData && event.data == AuthEvent.failed)
                          ? Text(
                              'Sign in failed. Please retry.',
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            )
                          : Text(' ')),
            ),
          ],
        ),
      ));

  Widget _getLoginButton(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(48, 16, 48, 8),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 99, 152),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextButton(
          onPressed: () async {
            try {
              if (!_formkey.currentState!.validate()) return;
              CarpUser user = await CarpService()
                  .authenticate(username: _username!, password: _password!);
              Navigator.pop(context, user);
            } catch (exception) {
              warning('Exception in authentication - $exception');
            }
          },
          child: Text(
            "Sign in",
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      );

  TextButton _getResetPasswordButton(BuildContext context) => TextButton(
        onPressed: () async {
          try {
            info("Reset password at url: '${CarpService().resetPasswordURI}'");
            await launchUrl(
              CarpService().resetPasswordURI,
              mode: LaunchMode.inAppWebView,
            );
          } catch (exception) {
            warning('Exception in launching Reset Password URL - $exception');
          }
        },
        child: Text(
          "Reset password",
          style: const TextStyle(color: Colors.grey),
        ),
      );

  Text _getEnvironmentText(BuildContext context) => Text(
        'Environment: ${CarpService()._app!.baseUri}',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      );
}
