import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letter_generator/Connectivity/DataE.dart';
import 'package:letter_generator/Connectivity/DevHelp.dart';
import 'package:letter_generator/Connectivity/HelpScreen.dart';
import 'package:letter_generator/ImageP/ImagePick.dart';
import 'package:provider/provider.dart';
import 'package:letter_generator/Providers/ProviderClass.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Printing/WebView.dart';

class FirstInputScreen extends StatefulWidget {
  const FirstInputScreen({super.key});

  @override
  State<FirstInputScreen> createState() => _FirstInputScreenState();
}

class _FirstInputScreenState extends State<FirstInputScreen> {

  bool translateButton = false;
  bool animation = false;
  ImagePick imageObj = ImagePick();
  DevHelp helpObj = DevHelp();
  DartData info = DartData();

  late TextEditingController lNumber;
  late TextEditingController lDate;
  late TextEditingController lName;
  late TextEditingController lAddress;
  late TextEditingController lSubject;
  late TextEditingController lBody;
  late TextEditingController lReference1;
  List<TextEditingController> controllerList = [];

  @override
  void initState() {
    super.initState();
    lNumber = TextEditingController();
    lDate = TextEditingController();
    lName = TextEditingController();
    lAddress = TextEditingController();
    lSubject = TextEditingController();
    lBody = TextEditingController();
    lReference1 = TextEditingController();
    info.getIns();
  }

  void addController(){
    setState(() {
      controllerList.add(TextEditingController());
    });
  }
  List<String> text1 = [];
  void extractText() {
    for (var controller in controllerList) {
      text1.add(controller.text);
      // print(controller.text);
    }
  }

  @override
  void dispose() {
    lNumber.dispose();
    lDate.dispose();
    lName.dispose();
    lAddress.dispose();
    lSubject.dispose();
    lBody.dispose();
    lReference1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderClassChange>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Letter Content'),
        actions: [IconButton(onPressed: (){

          helpObj.sendMessageToTelegram('goes to help screen');
          Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen()));

        }, icon: Icon(Icons.help_outline),color: Colors.white)]
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 55),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              textFieldMethod(lNumber, "Letter Number"),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: textFieldMethod(lDate, "Date"),
                  ),
                  SizedBox(width: 10), // Add spacing between the fields
                  ElevatedButton(
                    onPressed: () {
                      var cDate = DateTime.now();
                      String formatedDate = DateFormat('dd-MM-yyyy').format(cDate);
                      // print(formatedDate);
                      provider.mapData({"lDate":formatedDate});
                      setState(() {
                        lDate.text = provider.mapC["lDate"] ?? "";
                      });
                    },
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        backgroundColor: Color(0xFF0096AF)),
                    child: Text('Today Date',
                        style: TextStyle(color: Colors.white,fontSize: 15)),

                  ),
                ],
              ),

              SizedBox(
                height: 15,
              ),
              textFieldMethod(lName, "Receiver Name"),
              SizedBox(
                height: 15,
              ),
              textFieldMethod(lAddress, "Receiver Address"),
              SizedBox(
                height: 15,
              ),
              textFieldMethod(lSubject, "Subject"),
              SizedBox(
                height: 15,
              ),
              // textFieldMethod(lBody, "Body"),
              TextField(
                controller: lBody,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 4,
                decoration: InputDecoration(
                  hintText: 'Letter Body',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(child:
                  textFieldMethod(lReference1, "Reference 1"),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      addController();
                    },
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Color(0xFF0096AF),),
                    child: Text('Add Rows',
                        style: TextStyle(color: Colors.white,fontSize: 15)),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              ListView.builder(
                shrinkWrap: true,
                itemCount: controllerList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: controllerList[index],
                          decoration: InputDecoration(
                            hintText: "Reference ${index + 2}",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              ),

              SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child:ElevatedButton(onPressed: () async {
                  provider.mapData({
                    'lNumber': lNumber.text,
                    'lDate': lDate.text,
                    'lName': lName.text,
                    'lAddress': lAddress.text,
                    'lSubject': lSubject.text,
                    'lBody': lBody.text,
                    'lReference1': lReference1.text
                  });
                  int i=2;
                  for (var controller in controllerList) {
                    String re = controller.text;
                    provider.mapC["lReference$i"] = re;
                    i++;
                  }

                  if(lNumber.text.isEmpty || lDate.text.isEmpty || lName.text.isEmpty || lSubject.text.isEmpty || lBody.text.isEmpty){
                    showToast1('fill necessary fields');
                  }
                  else {
                    await geminiResponse(context);
                    setState(() {
                      lNumber.text = provider.mapC["lNumber"] ?? "";
                      lDate.text = provider.mapC["lDate"] ?? "";
                      lName.text = provider.mapC["lName"] ?? "";
                      lAddress.text = provider.mapC["lAddress"] ?? "";
                      lSubject.text = provider.mapC["lSubject"] ?? "";
                      lBody.text = provider.mapC["lBody"] ?? "";
                      lReference1.text = provider.mapC["lReference1"] ?? "";
                      translateButton = true;
                    });
                  }
                },
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Color(0xFF0096AF),),
                  child: Text('Convert to Hindi',
                      style: TextStyle(color: Colors.white,fontSize: 17)),),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child:
                animation
                    ? Center(
                  child: SizedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child:  CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 3.5,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text('Loading ...'),
                      ],
                    ),
                  ),
                )

                    : ElevatedButton(onPressed: () {
                  if(translateButton) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SimpleWeb()));
                  }
                  else{
                    showToast1('please translate first');
                  }
                },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)
                      ),
                      backgroundColor: Color(0xFF0096AF),
                    ),
                    child: Text("Generate Latter",
                        style: TextStyle(color: Colors.white,fontSize: 17))),
              ),
              SizedBox(height: 20,),
              SizedBox(width: double.infinity,
                child: ElevatedButton(onPressed: () async {
                  // print('................................................................');
                  String lSign = await imageObj.signatureImage();
                  provider.mapC["lSign"] = lSign;
                },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00C2DD),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text('Signature [optional]',style: TextStyle(color: Colors.white,fontSize: 17))),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: SizedBox(),
    );
  }

  SizedBox textFieldMethod(TextEditingController controller, String fieldName) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: fieldName,
          border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(8))),
        ),
      ),
    );
  }

//
  Future<String> geminiResponse(BuildContext context) async {
    final provider = Provider.of<ProviderClassChange>(context, listen: false);
    final map = provider.mapC;

    if (map.isEmpty) {
      // print('Error: The data map is empty. No data to process.');
      showToast1('Error: The data is empty. No data to process.');
      return 'Error: No data to process.';
    }

    String apiKey = 'gemini api ..........';
    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-002:generateContent?key=$apiKey';

    // Prompt construction
    final prompt = '''
Translate the following English text into Hindi and return the result as a JSON object in a single-line string. The JSON structure must strictly match the following format:

{
  "lNumber": "",
  "lDate" : "",
  "lName": "",
  "lAddress": "",
  "lSubject": "",
  "lBody": "",
  "lReference1": ""
  "lReference2": ""
  "lReference3": ""
  "lReference4": ""
}

Input values:
1. lName: ${map["lName"]}
2. lAddress: ${map["lAddress"]}
3. lSubject: ${map["lSubject"]}
4. lBody: ${map["lBody"]}
5. lNumber: ${map["lNumber"]}
6. lDate: ${map["lDate"]}
7. lReference1: ${map["lReference1"]}
8. lReference2: ${map["lReference2"]}
9. lReference3: ${map["lReference3"]}
10. lReference4: ${map["lReference4"]}


### Notes:
- Only translate the values of the fields (e.g., "lName", "lAddress") into Hindi.
- Maintain the same JSON structure in the response.
- Ensure proper handling of special characters (e.g., Unicode for Hindi text).
- Do not include additional fields or comments in the JSON output.

Example Input:
1. lName: "John Doe"
2. lAddress: "123 Main Street"
3. lSubject: "Meeting Reminder"
4. lBody: "Please attend the meeting tomorrow at 10 AM."
5. lNumber: "12345"
6. lDate: "2024-12-23"
7. lReference1: "Notice Board"
8. lReference2: "All Departments"
9. lReference3: "Ref-003"
10. lReference3: ""

Expected Response:
{"lDate": "12/12/2020", "lNumber": "12345", "lName": "जॉन डो", "lAddress": "123 मुख्य सड़क", "lSubject": "बैठक अनुस्मारक", "lBody": "कृपया कल सुबह 10 बजे बैठक में उपस्थित हों।", "lReference1": "
नोटिस बोर्ड", "lReference2": "सभी विभाग", "lReference3": "संदर्भ-003", "lReference4": ""}
''';

    // print('prompt is !!!!!!!!!!!!!!!!!!!! $prompt');
    final body = {
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ]
    };

    try {
      animation = true;
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      // print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final jsonResponse = jsonDecode(response.body);

          // Safely extract translated text
          final candidates = jsonResponse['candidates'];
          if (candidates == null || candidates.isEmpty) {
            throw Exception('No candidates found in the response.');
          }

          final content = candidates[0]['content'];
          if (content == null || content['parts'] == null ||
              content['parts'].isEmpty) {
            throw Exception('Invalid content structure in the response.');
          }

          String translatedText = content['parts'][0]['text'];
          // print('Raw translated text: $translatedText');

          // Extract JSON from markdown
          final cleanText = extractJsonFromMarkdown(translatedText);
          if (cleanText.isEmpty) {
            throw Exception('Failed to extract JSON from markdown.');
          }

          // print('Cleaned translated text: $cleanText');

          // Parse the cleaned JSON string
          final parsedData = jsonDecode(cleanText) as Map<String, dynamic>;
          // print('Parsed data: $parsedData');

          // Update provider
          provider.mapData(parsedData);

          return cleanText; // Return raw cleaned JSON string
        } catch (e) {
          // print('Error processing response: $e');
          showToast1('something went wrong, try again');
          return 'Error: Invalid response format.';
        }
      } else {
        // print('API request failed with status code: ${response.statusCode}');
        // print('Response body: ${response.body}');
        showToast1("Error: API request failed.");
        return 'Error: API request failed.';
      }
    } catch (error) {
      // print('Error occurred during the request: $error');
      showToast1('something went wrong, try again');
      return 'Error occurred while processing the request.';
    }
    finally{
      animation = false;
    }
  }
  String extractJsonFromMarkdown(String markdownText) {
    try {

      final regExp = RegExp(r'```json\s*(.*?)\s*```', dotAll: true);
      final match = regExp.firstMatch(markdownText);

      if (match != null && match.groupCount > 0) {
        return match.group(1)?.trim() ?? '';
      }

      final fallbackRegExp = RegExp(r'{.*}', dotAll: true);
      final fallbackMatch = fallbackRegExp.firstMatch(markdownText);

      if (fallbackMatch != null) {
        return fallbackMatch.group(0)?.trim() ?? '';
      }
      showToast1('something went wrong, try again');
      // print('Error: No JSON block or fallback JSON found in the response.');
      return '';
    } catch (e) {
      showToast1('something went wrong, try again');
      // print('Error extracting JSON from markdown: $e');
      return '';
    }
  }
  void showToast1(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      // backgroundColor: Colors.black,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }
}