import 'package:flutter/material.dart';
import 'package:hive_task_manager/boxes.dart';
import 'package:hive_task_manager/Model/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_task_manager/util/textform_field.dart';

class HiveDBPage extends StatefulWidget {
  const HiveDBPage({Key? key}) : super(key: key);

  @override
  State<HiveDBPage> createState() => _HiveDBPageState();
}

class _HiveDBPageState extends State<HiveDBPage> {
  final _formKey = GlobalKey<FormState>();

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  bool isEditPage = false;

  late UserModel _currentModel;

  @override
  void dispose() {
    super.dispose();

    /// Closing All Boxes
    Hive.close();

    ///Hive.box('users').close();
    /// Closing Selected Box
  }

  Future<void> addUser(String uId, String uName, String uEmail) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (isEditPage) {
        final user = UserModel()
          ..userId = uId
          ..userName = uName
          ..email = uEmail;

        final myBox = Boxes.getUsers();
        myBox.put(_currentModel.key, user);

        setState(() {
          isEditPage = true;
        });

        clearPage();
      } else {
        final user = UserModel()
          ..userId = uId
          ..userName = uName
          ..email = uEmail;

        final box = Boxes.getUsers();
        debugPrint(box.keys.toString());
        //Key Auto Increment
        box.add(user).then((value) => clearPage());
      }
    }
  }

  Future<void> editUser(UserModel userModel) async {
    setState(() {
      isEditPage = true;
    });

    idController.text = userModel.userId;
    nameController.text = userModel.userName;
    emailController.text = userModel.email;
    _currentModel = userModel;

    // if you want to do with key you can use that too.
    //final myUser = myBox.get("myKey");
    //myBox.values; // Access All Values
    //myBox.keys; // Access By Key
  }

  Future<void> deleteUser(UserModel userModel) async {
    userModel.delete();
  }

  clearPage() {
    idController.text = '';
    nameController.text = '';
    emailController.text = '';
    isEditPage = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Hive'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                CustomTextFormField(
                    controller: idController,
                    hintName: "User ID",
                    iconData: Icons.person),
                const SizedBox(height: 10),
                CustomTextFormField(
                    controller: nameController,
                    hintName: "User Name",
                    iconData: Icons.person_outline),
                const SizedBox(height: 10),
                CustomTextFormField(
                    controller: emailController,
                    textInputType: TextInputType.emailAddress,
                    hintName: "Email",
                    iconData: Icons.email),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black, // foreground
                          ),
                          onPressed: () => addUser(idController.text,
                              nameController.text, emailController.text),
                          child: Text(isEditPage ? "Update" : "Add"),
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black, // foreground
                          ),
                          onPressed: clearPage,
                          child: const Text("Clear"),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: ValueListenableBuilder(
                    valueListenable: Boxes.getUsers().listenable(),
                    builder: (BuildContext context, Box box, Widget? child) {
                      final users = box.values.toList().cast<UserModel>();
                      for (var element in users) {
                        debugPrint("listener : ${element.key}");
                      }
                      return genContent(users);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget genContent(List<UserModel> user) {
    if (user.isEmpty) {
      return const Center(
        child: Text(
          "No Users Found",
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: user.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.white,
            child: ExpansionTile(
              title: Text(
                "${user[index].userId} (${user[index].email})",
                maxLines: 2,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(user[index].userName),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      onPressed: () => editUser(user[index]),
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                      label: const Text(
                        "Edit",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => deleteUser(user[index]),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      label: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      );
    }
  }
}
