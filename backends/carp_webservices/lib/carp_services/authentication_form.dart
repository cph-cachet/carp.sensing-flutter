/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

class CARPEmailValidator extends TextFieldValidator {
  // regex pattern to validate email inputs.
  final Pattern _emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  CARPEmailValidator({required String errorText}) : super(errorText);

  @override
  bool isValid(String? value) => hasMatch(_emailPattern as String, value!);
}

class CarpAuthenticationForm extends StatefulWidget {
  final String? username;
  CarpAuthenticationForm({this.username});
  _CarpAuthenticationFormState createState() => _CarpAuthenticationFormState();
}

class _CarpAuthenticationFormState extends State<CarpAuthenticationForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("CACHET Research Platform"),
        ),
        body: Builder(
            // Create an inner BuildContext so that the onPressed methods
            // can refer to the Scaffold with Scaffold.of().
            builder: (BuildContext context) {
          return Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _LogoWidget(),
                    _InputWidget(username: widget.username),
                    _ResetPasswordWidget(),
                    _CancelButtonWidget(),
                    //_MessageWidget(),
                  ],
                ),
              ));
        }));
  }
}

class _InputWidget extends StatefulWidget {
  final String? username;
  _InputWidget({this.username});
  _InputState createState() => _InputState();
}

class _InputState extends State<_InputWidget> {
  final int delay = 3;
  var _usernameKey = GlobalKey<FormFieldState>();
  var _passwordKey = GlobalKey<FormFieldState>();
  String? get _username => _usernameKey.currentState?.value?.trim();
  String? get _password => _passwordKey.currentState?.value?.trim();

  Widget build(BuildContext context) {
    return Column(children: [_emailInput, _passwordInput, _signinButton]);
  }

  Widget get _emailInput {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
        key: _usernameKey,
        initialValue: widget.username,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Enter email as abc@cachet.dk',
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: MultiValidator([
          RequiredValidator(errorText: "* Required"),
          CARPEmailValidator(errorText: "Enter valid email."),
        ]) as String? Function(String?)?,
      ),
    );
  }

  Widget get _passwordInput {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        key: _passwordKey,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: 'Password',
            hintText: 'Enter password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: MultiValidator([
          RequiredValidator(errorText: "* Required"),
          MinLengthValidator(8,
              errorText: "Password should be at least 8 characters"),
        ]) as String? Function(String?)?,
      ),
    );
  }

  Widget get _signinButton {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          width: 300,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue[900],
            child: new Text('Sign in with CARP',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }

  Future _validateAndSubmit() async {
    bool success = true;

    ScaffoldMessenger.of(context).showSnackBar(_getSnackBar());

    try {
      await CarpService()
          .authenticate(username: _username!, password: _password!);
    } catch (exception) {
      warning('Exception in authentication via form - $exception');
      success = false;
    }

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(_getSnackBar(failure: true));
    }
  }

  SnackBar _getSnackBar({bool failure = false}) => SnackBar(
      duration: Duration(seconds: delay),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          failure ? Text('Sign in failed...') : Text('Signing in...'),
          failure ? Icon(Icons.error) : CircularProgressIndicator(),
        ],
      ));
}

class _ResetPasswordWidget extends StatefulWidget {
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<_ResetPasswordWidget> {
  final int delay = 3;

  Widget build(BuildContext context) {
    return new TextButton(
      child: Text('Forgot passord?',
          style: TextStyle(
            //color: ThemeData.light().buttonColor,
            fontSize: 18.0,
            fontWeight: FontWeight.w300,
          )),
      onPressed: _sendResetPasswordEmail,
    );
  }

  Future _sendResetPasswordEmail() async {
    bool success = true;
    ScaffoldMessenger.of(context).showSnackBar(_resettingSnackBar);

    try {
      // TODO - implement call to sendForgottenPasswordEmail() once tested.
      await CarpService()
          .sendForgottenPasswordEmail(email: 'this@shouldnotwork.dk');
    } catch (exception) {
      warning(
          'Exception in sending forgotten password email via form - $exception');
      success = false;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(success ? _successfulSnackBar : _failureSnackBar);
  }

  SnackBar get _resettingSnackBar => SnackBar(
      duration: Duration(seconds: delay),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Resetting password...'),
          CircularProgressIndicator(),
        ],
      ));

  SnackBar get _successfulSnackBar => SnackBar(
      duration: Duration(seconds: delay),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Email send.'),
          Icon(Icons.mail),
        ],
      ));

  SnackBar get _failureSnackBar => SnackBar(
      duration: Duration(seconds: delay),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Reset password failed...'),
          Icon(Icons.error),
        ],
      ));
}

class _CancelButtonWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return new TextButton(
      child: Text('Cancel',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w300,
          )),
      onPressed: () => Navigator.pop(context),
    );
  }
}

class _LogoWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Image.asset('asset/images/carp_logo.png',
          package: 'carp_webservices'),
    );
  }

  // Widget _build0(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 60.0),
  //     child: Center(
  //       child: Container(
  //         width: 300,
  //         //height: 150,
  //         child: Image.asset('asset/images/carp_logo.png',
  //             package: 'carp_webservices'),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildLogo1() {
  //   return Image.asset('asset/images/carp_logo.png',
  //       package: 'carp_webservices');
  // }

  // Widget _buildLogo2() {
  //   return Container(
  //     width: 300,
  //     height: 150,
  //     child: Image.asset('asset/images/carp_logo_small.png',
  //         package: 'carp_webservices'),
  //   );
  // }

  // Widget _buildLogo3() {
  //   return new Hero(
  //       tag: 'hero',
  //       child: Padding(
  //         padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
  //         child: Image.asset(
  //           'assets/images/carp_logo_small.png',
  //           package: 'carp_webservices',
  //           // child: CircleAvatar(
  //           //   backgroundColor: Colors.transparent,
  //           //   radius: 48.0,
  //           //   child: Image.asset(
  //           //     'assets/images/carp_logo_small.png',
  //           //     package: 'carp_webservices',
  //           //   ),
  //           // ),
  //         ),
  //       ));
  // }
}
