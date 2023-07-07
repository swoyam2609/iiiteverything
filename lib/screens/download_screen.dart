import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

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
      print('Error fetching subjects: $error');
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
      print("Error found at $e");
    }
  }

  Future<List<Map<String, dynamic>>> getFiles() async {
    var response = await http.get(Uri.parse(
        "https://dbiiit.swoyam.engineer/find?sub=${_selectedSubject}&docType=${_selectedDocType}"));

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
    return Container(
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
                              fontFamily: "Montserrat",
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
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: DropdownButtonHideUnderline(
                          child: _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : DropdownButton<String>(
                                  hint: const Text(
                                    "Please choose a subject",
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
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
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: _isDocsLoading
                            ? Center(child: CircularProgressIndicator())
                            : ListView.separated(
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: ShapeDecoration(
                                      gradient: RadialGradient(
                                        center: Alignment(0, 1),
                                        radius: 0,
                                        colors: [
                                          Color(0xFF403A5F),
                                          Color(0xFF211E2E)
                                        ],
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(13.23),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                child: Text(
                                                  "Name:",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Colors.purple[200],
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Text(
                                                  "Subject:",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Colors.purple[200],
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Text(
                                                  "Doc Type:",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Colors.purple[200],
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Text(
                                                  "Date:",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Colors.purple[200],
                                                    fontWeight: FontWeight.w500,
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
                                              Container(
                                                width: double.infinity,
                                                child: Text(
                                                  _files[index]["filename"],
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Text(
                                                  _files[index]["sub"],
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Text(
                                                  _files[index]["documentType"],
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Text(
                                                  formatDate(_files[index]
                                                      ["upload_date"]),
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
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
                                                  color: Color(0xFFC0B7E8),
                                                  borderRadius:
                                                      BorderRadius.circular(70),
                                                ),
                                                child: TextButton(
                                                  onPressed: () {},
                                                  child: Center(
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
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF262336),
                                                  borderRadius:
                                                      BorderRadius.circular(70),
                                                  border: Border.all(
                                                    color: Color(0xFFFFFFFF),
                                                  ),
                                                ),
                                                child: TextButton(
                                                  onPressed: () {},
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
                                  return SizedBox(
                                    height: 5,
                                  );
                                },
                                itemCount: _files.length,
                              ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        getDocs();
                        setState(() {});
                      },
                      child: Text("Press here"),
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
