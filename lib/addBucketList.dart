import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddBucketList extends StatefulWidget {
  int newIndex;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Bucket List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 30,
          children: [
            TextField(
              controller: itemText,
              decoration: InputDecoration(label: Text("Item")),
            ),
            TextField(
              controller: costText,
              decoration: InputDecoration(label: Text("Estimated Cost")),
            ),
            TextField(
              controller: imageURLText,
              decoration: InputDecoration(label: Text("Image Url")),
            ),
            Expanded(
              child: Row(
                children: [
                  ElevatedButton(onPressed: addData, child: Text("Add Item"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
