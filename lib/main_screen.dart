import 'package:bucket_list/addBucketList.dart';
import 'package:bucket_list/viewItem.dart';
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
  bool isError = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      Response response = await Dio().get(
          "https://bucketlist-b8539-default-rtdb.asia-southeast1.firebasedatabase.app/bucketlist.json");
      if (response.data is List) {
        bucketListData = response.data;
      } else {
        bucketListData = [];
      }
      setState(() {
        isLoading = false;
        isError = false;
      });
    } catch (e) {
      isLoading = false;
      isError = true;
      setState(() {});
    }
  }

  @override
  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget errorWidget({required String errorText}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning),
          Text(errorText),
          ElevatedButton(onPressed: getData, child: Text("Try Again"))
        ],
      ),
    );
  }

  Widget listDataWidget() {
    return ListView.builder(
      itemCount: bucketListData.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: (bucketListData[index] is Map)
              ? ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ViewItem(
                            index: index,
                            title: bucketListData[index]['item'] ?? "",
                            image: bucketListData[index]['image'] ?? "",
                          );
                        },
                      ),
                    ).then((value) {
                      if (value == "refresh") {
                        getData();
                      }
                    });
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        NetworkImage(bucketListData[index]?['image'] ?? ""),
                  ),
                  title: Text(bucketListData[index]?['item'] ?? ""),
                  trailing:
                      Text(bucketListData[index]?['cost'].toString() ?? ""),
                )
              : SizedBox(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddBucketList();
          }));
        },
      ),
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
        onRefresh: () async {
          getData();
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : isError
                ? errorWidget(errorText: "Error conneting....")
                : bucketListData.length < 1
                    ? Center(child: Text("No data on bucket list"))
                    : listDataWidget(),
      ),
    );
  }
}
