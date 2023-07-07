import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  String _selectedDocType = "";
  List<String> _subjects = [];
  String? _selectedSubject;
  bool _isLoading = true;
  bool _isDocsLoading = true;
  List<Map<String, dynamic>> _files = [];

  String formatDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat formatter = DateFormat('d MMMM');
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  Future<void> fetchSubjects() async {
    try {
      List<String> subjects = await getSubjects();
      setState(() {
        _subjects = subjects;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<String>> getSubjects() async {
    var response =
        await http.get(Uri.parse("https://dbiiit.swoyam.engineer/getsubjects"));

    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      List<String> subjects = result["unique_sub_values"].cast<String>();
      return subjects;
    } else {
      throw Exception('Failed to fetch subjects');
    }
  }

  Future<void> getDocs() async {
    try {
      _files = await getFiles();
      setState(() {
        _isDocsLoading = false;
      });
    } catch (e) {
      _isDocsLoading = false;
    }
  }

  Future<List<Map<String, dynamic>>> getFiles() async {
    var response = await http.get(Uri.parse(
        "https://dbiiit.swoyam.engineer/find?sub=$_selectedSubject&docType=$_selectedDocType"));

    if (response.statusCode == 200) {
      List<dynamic> result = json.decode(response.body);
      List<Map<String, dynamic>> files = result.cast<Map<String, dynamic>>();
      return files;
    } else {
      throw Exception("Failed to load files");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF302C42),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SafeArea(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70),
                        child: SvgPicture.asset(
                          "lib/assets/logo.svg",
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF211E2E),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: const Color(0xFFFFFFFF),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              elevation: 2,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              isExpanded: true,
                              dropdownColor: const Color(0xFF211E2E),
                              value: _selectedDocType,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 10),
                              items: const [
                                DropdownMenuItem<String>(
                                  value: "",
                                  child:
                                      Text("Please Select Document Type (All)"),
                                ),
                                DropdownMenuItem<String>(
                                  value: "NOTES",
                                  child: Text("Notes"),
                                ),
                                DropdownMenuItem<String>(
                                  value: "PAPER",
                                  child: Text("Question Papers"),
                                ),
                                DropdownMenuItem<String>(
                                  value: "BOOKS",
                                  child: Text("Books"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  value == null
                                      ? _selectedDocType = ""
                                      : _selectedDocType = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF211E2E),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: const Color(0xFFFFFFFF),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: DropdownButtonHideUnderline(
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : DropdownButton<String>(
                                    hint: const Text(
                                      "Please choose a subject",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    value: _selectedSubject,
                                    items: _subjects.map((e) {
                                      return DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(e),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedSubject = val!;
                                      });
                                    },
                                  ),
                          ),
                        ),
                      ),
                      Container(
                        height: 35,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC0B7E8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          child: Text(
                            "BROWSE",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.purple[900],
                            ),
                          ),
                          onPressed: () {
                            getDocs();
                            setState(() {});
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: _isDocsLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.separated(
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            image: AssetImage(
                                              "lib/assets/rectangle.jpg",
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                            color: Colors.white,
                                            style: BorderStyle.solid,
                                            width: 0.2,
                                          )),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    "Name:",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Colors.purple[200],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    "Subject:",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Colors.purple[200],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    "Doc Type:",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Colors.purple[200],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    "Date:",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Colors.purple[200],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    _files[index]["filename"],
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    _files[index]["sub"],
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    _files[index]
                                                        ["documentType"],
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    formatDate(_files[index]
                                                        ["upload_date"]),
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFC0B7E8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            70),
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      var url =
                                                          "https://dbiiit.swoyam.engineer/download/${_files[index]["_id"]}";

                                                      launch(url);
                                                    },
                                                    child: const Center(
                                                      child: Text(
                                                        "DOWNLOAD",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            color: Color(
                                                                0xFF343045)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF262336),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            70),
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xFFFFFFFF),
                                                    ),
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      String url =
                                                          "https://dbiiit.swoyam.engineer/download/${_files[index]["_id"]}";
                                                      Share.share(url);
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        "SHARE",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            color: Colors
                                                                .purple[200]),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 5,
                                    );
                                  },
                                  itemCount: _files.length,
                                ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
