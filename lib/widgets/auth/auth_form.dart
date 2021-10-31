import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key? key,
    required this.submitFn,
    required this.loading,
  }) : super(key: key);
  final bool loading;
  final void Function(String email, String username, String password,
      bool isLogin, BuildContext ctx) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = "";
  String _username = "";
  String _password = "";
  void _trySubmit() {
    final _isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
          _email.trim(), _username.trim(), _password, _isLogin, context);

      /// Now use the values to auth
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ]),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  key: ValueKey("email"),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains("@")) {
                      return "Email field is required";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email address"),
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey("username"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Username field is required";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _username = value!;
                    },
                    decoration: InputDecoration(labelText: "Username"),
                  ),
                TextFormField(
                  key: ValueKey("password"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password field is required";
                    }
                    if (value.length < 8) {
                      return "Password too short (min. 8 character)";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                SizedBox(
                  height: 16,
                ),
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width / 2,
                  color: Colors.indigo.shade600,
                  textColor: Colors.white,
                  elevation: 0,
                  onPressed: _trySubmit,
                  child: widget.loading
                      ? Container(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _isLogin ? "Login" : "Sign up",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(
                    _isLogin
                        ? "Create new account"
                        : "I already have an account",
                    style: TextStyle(
                        color: Colors.indigo.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
