import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:email_validator/email_validator.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      appId: "1:220906854342:android:14f3bc203565d3cc5104c7",
      projectId: "auth-app-project-darsh",
      apiKey: 'AIzaSyCGIttJPfBV8HKvY36zANmnuwpfzWNNaq0',
      messagingSenderId: 'auth-app-project-darsh',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      home: AuthenticationScreen(),
    );
  }
}

class AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisterEmailSection()),
                );
              },
              child: Text('Register'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailPasswordForm()),
                );
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user?.email;
    } catch (e) {
      return null;
    }
  }

  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user?.email;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}

class RegisterEmailSection extends StatefulWidget {
  RegisterEmailSection({Key? key}) : super(key: key);

  @override
  _RegisterEmailSectionState createState() => _RegisterEmailSectionState();
}

class _RegisterEmailSectionState extends State<RegisterEmailSection> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success = false;
  bool _initialState = true;
  String? _userEmail;

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter an email';
    } else if (!email.endsWith('@gsu.com')) {
      return 'Email must end with @gsu.com';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter a password';
    } else if (password.length < 6) {
      return 'Password should be at least 6 characters long';
    }
    return null;
  }

  void _register() async {
    String? email = await _authService.registerWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );
    setState(() {
      _success = email != null;
      _userEmail = email;
      _initialState = false;
    });

    if (_success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreen(email: _userEmail!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: _validateEmail,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: _validatePassword,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _register();
                    }
                  },
                  child: Text('Register'),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  _initialState
                      ? 'Please Register'
                      : _success
                          ? 'Successfully registered $_userEmail'
                          : 'Registration failed',
                  style: TextStyle(color: _success ? Colors.green : Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailPasswordForm extends StatefulWidget {
  EmailPasswordForm({Key? key}) : super(key: key);

  @override
  _EmailPasswordFormState createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success = false;
  bool _initialState = true;
  String _userEmail = '';

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter an email';
    } else if (!email.endsWith('@gsu.com')) {
      return 'Email must end with @gsu.com';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter a password';
    } else if (password.length < 6) {
      return 'Password should be at least 6 characters long';
    }
    return null;
  }

  void _signInWithEmailAndPassword() async {
    String? email = await _authService.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );
    setState(() {
      _success = email != null;
      _userEmail = email ?? '';
      _initialState = false;
    });

    if (_success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreen(email: _userEmail)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: _validateEmail,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: _validatePassword,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _signInWithEmailAndPassword();
                    }
                  },
                  child: Text('Sign In'),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _initialState
                      ? 'Please sign in'
                      : _success
                          ? 'Successfully signed in $_userEmail'
                          : 'Sign in failed',
                  style: TextStyle(color: _success ? Colors.green : Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String email;
  ProfileScreen({required this.email});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome, $email', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _authService.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AuthenticationScreen()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
