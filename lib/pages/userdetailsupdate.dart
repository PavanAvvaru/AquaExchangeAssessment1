import 'package:flutter/material.dart';
import 'package:assesmentproject/Service/database.dart';

class UserDetailsUpdatePage extends StatefulWidget {
  final String userId;
  const UserDetailsUpdatePage({Key? key, required this.userId})
      : super(key: key);

  @override
  _UserDetailsUpdatePageState createState() => _UserDetailsUpdatePageState();
}

class _UserDetailsUpdatePageState extends State<UserDetailsUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPhoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    try {
      Map<String, dynamic>? userData =
          await DatabaseMethods().getUserDetailsById(widget.userId);

      if (userData != null) {
        setState(() {
          userNameController.text = userData["Name"];
          userEmailController.text = userData["Email"];
          userPhoneNumberController.text = userData["Phone Number"];
        });
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  void updateUserDetails() async {
    try {
      String updatedName = userNameController.text;
      String updatedEmail = userEmailController.text;
      String updatedPhoneNumber = userPhoneNumberController.text;

      await DatabaseMethods().updateUserDetails(widget.userId, {
        "Name": updatedName,
        "Email": updatedEmail,
        "Phone Number": updatedPhoneNumber,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User details updated successfully"),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error updating user details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          "Update User Details",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      updateUserDetails();
                    }
                  },
                  child: Text("Update"),
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
        color: Colors.white,
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
              return 'Please enter a valid Gmail address';
            }
          } else if (isPhoneNumber) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
              return 'Please enter a valid 10-digit phone number starting with 6, 7, 8, or 9';
            }
          }
          return null;
        },
      ),
    );
  }
}
