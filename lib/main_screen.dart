import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> bucketListData = [];
  bool isLoading = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      Response response = await Dio().get(
          "https://bucketlist-b8539-default-rtdb.asia-southeast1.firebasedatabase.app/bucketlist.json");

      setState(() {
        bucketListData = response.data;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      setState(() {});
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Cannot connect to the server! Try after few seconds!"),
          );
        },
      );
    }
  }

  @override
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: getData,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.refresh),
            ),
          )
        ],
        title: const Text("Bucket List"),
      ),
      body: RefreshIndicator(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: bucketListData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage(bucketListData[index]['image'] ?? ""),
                      ),
                      title: Text(bucketListData[index]['item'] ?? ""),
                      trailing:
                          Text(bucketListData[index]['cost'].toString() ?? ""),
                    ),
                  );
                },
              ),
        onRefresh: () async {
          getData();
        },
      ),
    );
  }
}
