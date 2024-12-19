import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ViewItem extends StatefulWidget {
  String title;
  String image;
  int index;
  ViewItem(
      {super.key,
      required this.title,
      required this.image,
      required this.index});

  @override
  State<ViewItem> createState() => _ViewItemState();
}

class _ViewItemState extends State<ViewItem> {
  Future<void> deleteData() async {
    Navigator.pop(context);
    try {
      Response response = await Dio().delete(
          "https://bucketlist-b8539-default-rtdb.asia-southeast1.firebasedatabase.app/bucketlist/${widget.index}.json");
      Navigator.pop(context, "refresh");
    } catch (e) {
      print("error");
    }
  }

  Future<void> markAsComplete() async {
    try {
      Response response = await Dio().patch(
          "https://bucketlist-b8539-default-rtdb.asia-southeast1.firebasedatabase.app/bucketlist/${widget.index}.json");
      Navigator.pop(context, "refresh");
    } catch (e) {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.title}"), actions: [
        PopupMenuButton(onSelected: (value) {
          if (value == 1) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Are you sure to delete?"),
                    actions: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("cancel"),
                      ),
                      InkWell(
                        onTap: deleteData,
                        child: Text("confirm"),
                      )
                    ],
                  );
                });
          }
          if (value == 2) {
            markAsComplete();
          }
        }, itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: Text("Delete"),
              value: 1,
            ),
            PopupMenuItem(
              child: Text("Mark as complete"),
              value: 2,
            )
          ];
        })
      ]),
      body: Column(
        children: [
          Text(widget.index.toString()),
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.image),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
