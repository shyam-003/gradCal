import 'package:flutter/material.dart';

class signInScreen extends StatefulWidget {
  const signInScreen({super.key});

  @override
  State<signInScreen> createState() => _signInScreenState();
}

class _signInScreenState extends State<signInScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  bool _isUserValid = true;
  bool _isEmailValid = true;
  bool _ispassValid = true;
  bool _ispassSame = true;

    @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _confirmPassController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Color.fromARGB(255, 190, 155, 250),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 32,
                    color: Color.fromARGB(255, 177, 137, 246),
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    errorText: _isUserValid ? null : 'User must be a valid username',
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  ),
                  // obscureText: true,
                ),
                SizedBox(
                height: 20,
              ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'email',
                    errorText: _isEmailValid ? null : 'use College Id',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  ),
                  // obscureText: true,
                ),
                SizedBox(
                height: 20,
              ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: _ispassValid ? null : 'Password must Contain letters',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  ),
                  obscureText: true,
                ),
                SizedBox(
                height: 20,
              ),
                TextField(
                  controller: _confirmPassController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    errorText: _ispassSame ? null : 'Password different',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: () {
                    _validateEmail();
                    _validatePass();
                    _validateUser();
                    if (_isEmailValid && _ispassSame && _ispassValid && _isUserValid) {
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 177, 142, 240),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateEmail() {
    setState(() {
      RegExp regex = RegExp(r'^[a-zA-Z0-9]+@iitj\.ac\.in$');
      if (!regex.hasMatch(_emailController.text)) {
        _isEmailValid = false;
      } else {
        _isEmailValid = true;
      }
    });
  }

  void _validateUser(){
  setState(() {
    String username = _userNameController.text.trim(); 
    if (username.isEmpty) {
      _isUserValid = false;
    } else {
      RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');
      _isUserValid = regex.hasMatch(username);
    }
  });
}

  void _validatePass() {
  setState(() {
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPassController.text.trim();

    RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');

    if (password.isEmpty || confirmPassword.isEmpty) {
      _ispassSame = false;
    } else if (password != confirmPassword || !regex.hasMatch(password) || !regex.hasMatch(confirmPassword)) {
      _ispassSame = false;
    } else {
      _ispassSame = true;
    }
  });
}

}
