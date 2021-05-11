import 'package:flutter/material.dart';
import 'package:todo/database_helper.dart';
import 'package:todo/screens/taskpage.dart';
import 'package:todo/screens/widgets.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbhelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xffF6F6F6),
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 32,
            right: 24,
            left: 24,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 32,
                    ),
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage(
                            'assets/images/logo.png',
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Text(
                          "Todos",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff211551),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbhelper.getTasks(),
                      builder: (context, snapshot) {
                        return ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => TaskPage(
                                                task: snapshot.data[index],
                                              ))).then((value) {
                                    setState(() {});
                                  });
                                },
                                child: TaskcardWidget(
                                  title: snapshot.data[index].title,
                                  body: snapshot.data[index].description,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 24,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskPage(
                          task: null,
                        ),
                      ),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff7349FE),
                          Color(0xff643FDB),
                        ],
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, 1.0),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image(
                      image: AssetImage("assets/images/add_icon.png"),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
