// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({
    super.key,
  });

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final Group_Controller = TextEditingController();

  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text('Create Group'),
      content: SizedBox(
        height: 150,
        width: 150,
        child: Form(
          key: formkey,
          child: Column(
            children: [
              TextFormField(
                controller: Group_Controller,
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter group name";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 241, 156, 10)),
            onPressed: () {
              if (formkey.currentState!.validate()) {
                String group_name = Group_Controller.text.toString();

                Navigator.pop(context, group_name);
              }
            },
            child: const Text(
              "Create",
              style: TextStyle(color: Colors.black),
            )),
        TextButton(
            style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 241, 156, 10)),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ))
      ],
    );
  }
}
