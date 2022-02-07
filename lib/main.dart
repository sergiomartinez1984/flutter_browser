// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      title: 'Flutter Browser',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(),
    ));

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebViewController _webViewController;
  final TextEditingController _teController = TextEditingController();
  bool showLoading = false;

  void updateLoading(bool ls) {
    setState(() {
      showLoading = ls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const Flexible(
                              flex: 2,
                              child: Text(
                                "https://",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              )),
                          Flexible(
                            flex: 4,
                            child: TextField(
                              autocorrect: false,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                              decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        color: Colors.black,
                                        width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        color: Colors.white,
                                        width: 2),
                                  )),
                              controller: _teController,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Center(
                              child: IconButton(
                                  icon: const Icon(
                                    Icons.manage_search_outlined,
                                    color: Colors.black,
                                  ),
                                  onPressed: () async {
                                    String finalURL = _teController.text;
                                    if (!finalURL.startsWith("https://")) {
                                      finalURL = "https://" + finalURL;
                                    }
                                    updateLoading(true);
                                    _webViewController
                                        .loadUrl(finalURL)
                                        .then((onValue) {})
                                        .catchError((e) {
                                      updateLoading(false);
                                    });
                                    try {
                                      http.Response response =
                                          await http.get(Uri.parse(finalURL));

                                      if (response.statusCode == 200) {
                                        _webViewController.loadUrl(finalURL);
                                      }
                                    } catch (e) {
                                      _webViewController.loadUrl(
                                          "https://www.google.es/search?q="
                                          "$finalURL");
                                    }
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                    flex: 9,
                    child: Stack(
                      children: <Widget>[
                        WebView(
                          initialUrl: 'https://www.google.com',
                          onPageFinished: (data) {
                            updateLoading(false);
                          },
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated: (webViewController) {
                            _webViewController = webViewController;
                          },
                        ),
                        (showLoading)
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const Center()
                      ],
                    )),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
                margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          _webViewController.goBack();
                        },
                        iconSize: 27.0,
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _webViewController.goForward();
                        },
                        iconSize: 27.0,
                        icon: const Icon(
                          Icons.arrow_forward,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            _webViewController.clearCache();
                          },
                          iconSize: 27.0,
                          icon: const Icon(
                            Icons.arrow_drop_down_circle_sharp,
                          ))
                    ]))));
  }
}
