
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:nket/services/firebase/auth.dart';
import 'package:nket/services/firebase/firestore.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLogin = false;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;





  Future<void> formAction()async{
    if(isLogin){
      Auth().login(
          email: _email.text, password: _password.text
      ).then((value){
        print("successo!");
      }).catchError((err){
        SnackBar errorSnackbar = SnackBar(content: Text(err.message));
        ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
      });
    }else{
      Auth().registration(
          email: _email.text, password: _password.text
      ).then((value)async{
        UserCredential credentials = value;
        final uid = credentials.user!.uid;
        await Firestore().addUser(uid: uid.toString());
      }).catchError((err){
        SnackBar errorSnackbar = SnackBar(content: Text(err.message));
        ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double formLength = width / 1.3;

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: SizedBox(
                  width: formLength,
                  height: height / 2,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                            decoration: const InputDecoration(
                                helperText: "email"
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            enableSuggestions: true,
                            controller: _email,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: "email obbligatoria"
                              ),
                              FormBuilderValidators.email(errorText: "email non valida")
                            ])),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              helperText: "password",
                              suffixIcon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  icon: Icon(  _obscureText ? Icons.visibility : Icons.visibility_off)
                              )
                          ),
                          obscureText: _obscureText,
                          autocorrect: false,
                          obscuringCharacter: "*",
                          controller: _password,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.minLength(8,
                                allowEmpty: false,
                                errorText: "lunghezza minima 8 caratteri")
                          ]),
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                                onPressed: () async{

                                  bool? formValid = _formKey.currentState?.validate();
                                  if(formValid == true) return await formAction();
                                  SnackBar errorSnackbar = const SnackBar(content: Text("si è verificato un errore"));
                                  ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
                                },
                                child: Text(isLogin ? "accedi" : "iscriviti")),
                            TextButton(
                                child: Text(isLogin
                                    ? "non hai un account? iscriviti"
                                    : "hai già un account? accedi"),
                                onPressed: () {
                                  setState(() {
                                    isLogin = !isLogin;
                                  });
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ));
  }
}


/*TextField(
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelText: 'Password',
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
      ),

      --- oppure ---

       TextFormField(
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelText: 'Password',
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
      ),


* */