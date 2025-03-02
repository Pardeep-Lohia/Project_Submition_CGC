import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Screens/MultiStepForm.dart';
import 'package:flutter_application_1/AuthenticationScreens/SignUp.dart';

import 'package:flutter_application_1/AuthenticationScreens/SignUp.dart';
import 'package:flutter_application_1/Services/summerization_data.dart';

class Homescreennew extends StatefulWidget {
  const Homescreennew({super.key});

  @override
  State<Homescreennew> createState() => _HomescreennewState();
}

class _HomescreennewState extends State<Homescreennew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.account_circle),
        //   onPressed: () {},
        // ),
        leading: InkWell(
          child: Image.asset("Assets/image.png"),
        ),
        // title: Text('Home'),
      ),
      backgroundColor: Colors.white,
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  // color: Colors.blue,
                  ),
              // child: Text(
              //   'Menu',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 24,
              //   ),
              // ),.
              child: TextField(),
            ),
            ListTile(
              // leading: Icon(Icons.home),
              title: Text('Summerization'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(title: "geg")),
                );
              },
            ),
            ListTile(
              // leading: Icon(Icons.settings),
              title: Text('Courses'),
              onTap: () {},
            ),
            ListTile(
              // leading: Icon(Icons.info),
              title: Text('Services'),
              onTap: () {},
            ),
            ListTile(
              // leading: Icon(Icons.help),
              title: Text('About Us'),
              onTap: () {},
            ),
            ListTile(
              // leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: () {},
            ),
            ListTile(
              // leading: Icon(Icons.help),
              title: Text('Jobs'),
              onTap: () {},
            ),
            ListTile(
              // leading: Icon(Icons.help),
              title: Text('Contact us'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('+1 123 456 7890'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('EduHaven Team'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              // width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('Assets/HomeImg.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "All-in-One",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Text(
                  //   "ult",
                  //   style: TextStyle(
                  //       color: Colors.blue,
                  //       fontSize: 28,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  Text("Learning Hub",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  // RichText(
                  //   text: TextSpan(
                  //     text:
                  //     children: [
                  //       TextSpan(
                  //         text:
                  //       ),
                  //       TextSpan(text: " learning platform"),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 15),
                  // Text(
                  //   "All-In-One Learning Hub",
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     color: Colors.grey[700],
                  //     height: 1.5,
                  //   ),
                  // ),
                  Text(
                    "A platform for personalized learning, seamless revision, and knowledge discovery.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MultiStepForm()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Enroll Today",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Container(
            //   width: 150,
            //   child: Container(
            //     child: FloatingActionButton(
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => MultiStepForm()),
            //         );
            //       },
            //       child: Container(
            //         padding: EdgeInsets.all(10),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Text(
            //               "Enroll Now",
            //               style: TextStyle(
            //                 fontSize: 18,
            //                 fontWeight: FontWeight.w600,
            //                 color: Colors.white,
            //               ),
            //             ),
            //             SizedBox(width: 8),
            //             Icon(Icons.arrow_forward_sharp, color: Colors.white),
            //           ],
            //         ),
            //       ),
            //       backgroundColor: Colors.blue[800],
            //       elevation: 4,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
