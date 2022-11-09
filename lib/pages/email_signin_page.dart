part of 'pages.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //* TITLE
            Text(
              'SIGN IN WITH EMAIL/PASSWORD',
              style:
                  GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            //* SIGN IN STATUS
            // CODE HERE: Change status based on current user
            StreamBuilder<User?>(
                stream: FirebaseAuth.instance.userChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text("SIGN IN : ${snapshot.data?.email}");
                  } else {
                    return const Text("You haven't signed in yet");
                  }
                }),

            //* EMAIL TEXTFIELD
            Container(
              margin: const EdgeInsets.fromLTRB(30, 15, 30, 10),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: emailController,
                cursorColor: Colors.orange,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Email'),
              ),
            ),

            //* PASSWORD TEXTFIELD
            Container(
              margin: const EdgeInsets.fromLTRB(30, 0, 30, 15),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: passwordController,
                cursorColor: Colors.orange,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Password'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //* SIGN UP BUTTON
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.orange.shade900)),
                      onPressed: () async {
                        if (FirebaseAuth.instance.currentUser == null) {
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text);
                          } on FirebaseAuthException catch (e) {
                            showNotification(context, e.message.toString());
                          }
                        } else {
                          await FirebaseAuth.instance.signOut();
                        }
                        // CODE HERE: Sign up with email & password / Sign out from firebase
                      },
                      // CODE HERE: Change button text based on current user
                      child: StreamBuilder<User?>(
                          stream: FirebaseAuth.instance.userChanges(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return const Text("Sign Out");
                            } else {
                              return const Text("Sign Up");
                            }
                          })),
                ),
                const SizedBox(
                  width: 15,
                ),

                //* SIGN IN BUTTON
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.orange.shade900)),
                      onPressed: () async {
                        // CODE HERE: Sign in with email & password / Sign out form firebase
                        if (FirebaseAuth.instance.currentUser == null) {
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text);
                          } on FirebaseAuthException catch (e) {
                            showNotification(context, e.message.toString());
                          }
                        } else {
                          await FirebaseAuth.instance.signOut();
                        }
                      },
                      // CODE HERE: Change button text based on current user
                      child: StreamBuilder<User?>(
                          stream: FirebaseAuth.instance.userChanges(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return const Text("Sign Out");
                            } else {
                              return const Text("Sign in");
                            }
                          })),
                ),
              ],
            ),

            //* RESET PASSWORD BUTTON
            TextButton(
                onPressed: () async {
                  // CODE HERE: Send reset code to the given email
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: emailController.text);
                  } on FirebaseAuthException catch (e) {
                    showNotification(context, e.message.toString());
                  }
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.orange.shade900),
                ))
          ],
        ),
      ),
    );
  }

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orange.shade900,
        content: Text(message.toString())));
  }
}
