import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:itunes/util/image_resource.dart';
import 'package:itunes/util/string_resource.dart';
import 'package:itunes/view/media_list_page.dart';
import 'package:root_checker_plus/root_checker_plus.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchFieldController = TextEditingController();

  Future<void> showRootedDeviceAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(StringResource.warning),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(StringResource.yourDeviceRoot),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(StringResource.exit),
              onPressed: () => FlutterExitApp.exitApp(iosForceExit: true),
            ),
          ],
        );
      },
    );
  }

  Future<void> androidRootChecker() async {
    bool rootedCheck;
    try {
      rootedCheck = (await RootCheckerPlus.isRootChecker())!;
    } on PlatformException {
      rootedCheck = false;
    }
    if (rootedCheck) {
      await showRootedDeviceAlert();
    }
  }

  Future<void> iosJailbreak() async {
    bool jailbreak;
    try {
      jailbreak = (await RootCheckerPlus.isJailbreak())!;
    } on PlatformException {
      jailbreak = false;
    }
    if (jailbreak) {
      await showRootedDeviceAlert();
    }
  }

  void checkRootCheck() {
    if (Platform.isAndroid) {
      androidRootChecker();
    }
    if (Platform.isIOS) {
      iosJailbreak();
    }
  }

  @override
  void initState() {
    checkRootCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> mediaList = ["album", "movie", "musicVideo", "song"];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: bodyView(mediaList, context),
      ),
    );
  }

  Container bodyView(List<String> mediaList, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageResource.appleIcon),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const Text(
                StringResource.iTunes,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            StringResource.iTunesDes,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: searchFieldController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: StringResource.enterTextHere,
              hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.grey.shade800,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.grey.shade800,
                  width: 1.0,
                ),
              ),
              filled: true,
              fillColor: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            StringResource.searchDes,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            height: 120,
            padding: const EdgeInsets.all(10),
            // width: double.infinity,
            color: Colors.grey.shade800,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: mediaList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    searchFieldController.clear();
                    searchFieldController.text += mediaList[index];
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        mediaList[index],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(width: 10);
              },
            ),
          ),
          const SizedBox(height: 45),
          const Spacer(),
          submitBtnView(context),
        ],
      ),
    );
  }

  void clickSubmitBtn() {
    if (searchFieldController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MediaListPage(
            searchTerm: searchFieldController.text,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please enter some text.'),
        ),
      );
    }
  }

  ElevatedButton submitBtnView(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: clickSubmitBtn,
      child: const Text(
        StringResource.submit,
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
