import 'package:assesmentproject/Service/database.dart';
import 'package:flutter/material.dart';

class UserDetailsUpdatePage extends StatefulWidget {
  final String userId;
  const UserDetailsUpdatePage({Key? key, required this.userId})
      : super(key: key);

  @override
  _UserDetailsUpdatePageState createState() => _UserDetailsUpdatePageState();
}

class _UserDetailsUpdatePageState extends State<UserDetailsUpdatePage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPhoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //existing user details using widget.userId
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    Map<String, dynamic>? userData =
        await DatabaseMethods().getUserDetailsById(widget.userId);

    // display existing user details
    if (userData != null) {
      setState(() {
        userNameController.text = userData["Name"];
        userEmailController.text = userData["Email"];
        userPhoneNumberController.text = userData["Phone Number"];
      });
    }
  }

  void updateUserDetails() async {
    String updatedName = userNameController.text;
    String updatedEmail = userEmailController.text;
    String updatedPhoneNumber = userPhoneNumberController.text;

    //update the user details
    await DatabaseMethods().updateUserDetails(widget.userId, {
      "Name": updatedName,
      "Email": updatedEmail,
      "Phone Number": updatedPhoneNumber,
    });

    //success msg and navigate to back
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("User details updated successfully"),
      ),
    );
    Navigator.pop(context);
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
            ),
            _buildTextField(
              controller: userPhoneNumberController,
              labelText: 'Phone Number',
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  updateUserDetails();
                },
                child: Text("Update"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
