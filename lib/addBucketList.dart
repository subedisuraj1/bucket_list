import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddBucketList extends StatefulWidget {
  final int newIndex;
  AddBucketList({super.key, required this.newIndex});

  @override
  State<AddBucketList> createState() => _AddBucketListState();
}

class _AddBucketListState extends State<AddBucketList> {
  TextEditingController itemText = TextEditingController();
  TextEditingController costText = TextEditingController();
  TextEditingController imageURLText = TextEditingController();

  Future<void> addData() async {
    try {
      Map<String, dynamic> data = {
        "item": itemText.text,
        "cost": costText.text,
        "image": imageURLText.text,
        "completed": false
      };
      Response response = await Dio().patch(
          "https://bucketlist-b8539-default-rtdb.asia-southeast1.firebasedatabase.app/bucketlist/${widget.newIndex}.json",
          data: data);
      Navigator.pop(context, "refresh");
    } catch (e) {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var addForm = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Bucket List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: addForm,
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.toString().length < 3) {
                    return "must be more than 3 character";
                  }
                  if (value == null || value.isEmpty) {
                    return "This must not be empty";
                  }
                },
                controller: itemText,
                decoration: InputDecoration(label: Text("Item")),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.toString().length < 3) {
                    return "must be more than 3 character";
                  }
                  if (value == null || value.isEmpty) {
                    return "This must not be empty";
                  }
                },
                controller: costText,
                decoration: InputDecoration(label: Text("Estimated Cost")),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.toString().length < 3) {
                    return "must be more than 3 character";
                  }
                  if (value == null || value.isEmpty) {
                    return "This must not be empty";
                  }
                },
                controller: imageURLText,
                decoration: InputDecoration(label: Text("Image Url")),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      if (addForm.currentState!.validate()) {
                        addData();
                      }
                    },
                    child: Text("Add Item")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
