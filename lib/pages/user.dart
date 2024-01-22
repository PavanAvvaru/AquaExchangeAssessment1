import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:assesmentproject/Service/database.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  State<User> createState() => UserState();
}

class UserState extends State<User> {
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPhoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 152, 224, 224),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "Add a new user",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: userNameController,
                labelText: 'Name',
              ),
              _buildTextField(
                controller: userEmailController,
                labelText: 'Email',
                isEmail: true,
              ),
              _buildTextField(
                controller: userPhoneNumberController,
                labelText: 'Phone Number',
                isPhoneNumber: true,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      String Id = randomAlphaNumeric(10);
                      Map<String, dynamic> userInfoMap = {
                        "Id": Id,
                        "Name": userNameController.text,
                        "Email": userEmailController.text,
                        "Phone Number": userPhoneNumberController.text,
                      };
                      await DatabaseMethods()
                          .addUserDetails(userInfoMap, Id)
                          .then((value) => Fluttertoast.showToast(
                                msg: "User added successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              ));
                    }
                  },
                  child: Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool isEmail = false,
    bool isPhoneNumber = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        keyboardType: isPhoneNumber
            ? TextInputType.phone
            : (isEmail ? TextInputType.emailAddress : TextInputType.text),
        validator: (value) {
          if (isEmail) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            } else if (!value.endsWith('@gmail.com')) {
              return 'Please enter a valid gmail address';
            }
          } else if (isPhoneNumber) {
            if (value == null || value.isEmpty) {
              return 'please enter your phone number';
            } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
              return 'please enter a valid 10-digit phone number starts with 6to9';
            }
          }
          return null;
        },
      ),
    );
  }
}
