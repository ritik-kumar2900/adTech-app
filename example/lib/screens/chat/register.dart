import 'package:example/screens/chat/login.dart';
import 'package:example/screens/chat/users.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

class SRegisterPage extends StatefulWidget {
  String sub;
  SRegisterPage(this.sub);
  @override
  _SRegisterPageState createState() => _SRegisterPageState();
}

class _SRegisterPageState extends State<SRegisterPage> {
  TextEditingController? _firstName;
  FocusNode? _focusNode;
  TextEditingController? _lastName;
  bool _registering = false;
  TextEditingController? _passwordController;
  TextEditingController? _usernameController;

  @override
  void initState() {
    super.initState();
    final faker = Faker();
    _firstName = TextEditingController(text: "");
    _lastName = TextEditingController(text: "");
    _focusNode = FocusNode();
    _passwordController = TextEditingController(text: '');
    _usernameController = TextEditingController(
      text: "",
    );
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _passwordController?.dispose();
    _usernameController?.dispose();
    super.dispose();
  }

  void _register() async {
    await FirebaseAuth.instance.signOut();

    String t = DateTime.now().toString();
    FocusScope.of(context).unfocus();

    setState(() {
      _registering = true;
    });

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _usernameController!.text,
        password: _passwordController!.text,
      );
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: _firstName!.text,
          id: credential.user!.uid,
          imageUrl: 'https://i.pravatar.cc/300?u=$t',
          lastName: _lastName!.text,
        ),
      );

      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => UsersPage(widget.sub),
        ),
      );
    } catch (e) {
      setState(() {
        _registering = false;
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
          content: Text(
            e.toString(),
          ),
          title: const Text('Error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text('New Session'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 80, left: 24, right: 24),
          child: Column(
            children: [
              TextField(
                autocorrect: false,
                autofillHints: _registering ? null : [AutofillHints.name],
                autofocus: true,
                controller: _firstName,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  labelText: 'Name',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => _firstName?.clear(),
                  ),
                ),
                keyboardType: TextInputType.name,
                onEditingComplete: () {
                  _focusNode?.requestFocus();
                },
                readOnly: _registering,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
              ),
              TextField(
                autocorrect: false,
                autofillHints: _registering ? null : [AutofillHints.name],
                autofocus: true,
                controller: _lastName,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  labelText: 'Class',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => _lastName?.clear(),
                  ),
                ),
                keyboardType: TextInputType.number,
                onEditingComplete: () {
                  _focusNode?.requestFocus();
                },
                readOnly: _registering,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
              ),
              TextField(
                autocorrect: false,
                autofillHints: _registering ? null : [AutofillHints.email],
                autofocus: true,
                controller: _usernameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  labelText: 'Email',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => _usernameController?.clear(),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                onEditingComplete: () {
                  _focusNode?.requestFocus();
                },
                readOnly: _registering,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  autocorrect: false,
                  autofillHints: _registering ? null : [AutofillHints.password],
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () => _passwordController?.clear(),
                    ),
                  ),
                  focusNode: _focusNode,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  onEditingComplete: _register,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.done,
                ),
              ),
              TextButton(
                onPressed: _registering ? null : _register,
                child: const Text('Register'),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: RaisedButton(
                  onPressed: () {
                    // getCurrentUser(
                    //   nameController.text,
                    //   numberController.text,
                    //   clasController.text,
                    //   addressController.text,
                    // );
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage(widget.sub)));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: size.width * 0.5,
                    decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(80.0),
                    ),
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
