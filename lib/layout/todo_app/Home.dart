import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../../components/components/app_textformfield.dart';
import '../../components/constaints/constaints.dart';
import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

//1-create database
//2-create tables
//3-open database
//4-insert database
//5-get from database
//6-update in database
//7-Delete database


class _HomeState extends State<Home> {
  int currentIndex=0;

  List<Widget>screens=
  [
    const NewTasks(),
    const DoneTasks(),
    const ArchivedTasks()
  ];

  List<String>title=
  [
    "New Tasks",
    "Done Tasks",
    "Archived Tasks"
  ];
  late Database database;
  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();
  bool isBottomSheetShown=false;
  IconData fabIcon=Icons.edit;
  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();



  @override
  void initState() {
    super.initState();
    createDatabase();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xff880e4f),
        title: Center(
          child: Text(
              title[currentIndex]
          ),
        ),
      ),
      body:ConditionalBuilder(
        condition: tasks.isNotEmpty,
        builder:(context) => screens[currentIndex],
        fallback:(context) => const Center(child: CircularProgressIndicator()), ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff880e4f),
        onPressed: () {
          if(isBottomSheetShown){
            if(formKey.currentState!.validate())
            {
              insertToDatabase(
                title: titleController.text,
                time:  timeController.text,
                date:  dateController.text,
              ).then((value){
                getDataFromDatabase(database).then((value){
                  Navigator.pop(context);
                  setState(() {
                    isBottomSheetShown=false;
                    fabIcon= Icons.edit;
                    tasks=value;
                  });
                });
              });
            }
          }
          else{
            scaffoldKey.currentState?.showBottomSheet(
                    (context) => Container(
                  color: Colors.grey[300],
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        appTextFormField(
                          controller: titleController,
                          keyboardType: TextInputType.text,
                          label: "Task Title",
                          hint: "Task Title",
                          prefix: Icons.title,
                          prefixColor: Colors.grey[600],
                          validate: (value){
                            if(value!.isEmpty){
                              return "title must not be empty";
                            }
                            return null;
                          },
                          focusedColor: const Color(0xff880e4f),
                          lColor:const Color(0xff880e4f),
                          hColor:const Color(0xff880e4f),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        appTextFormField(
                          controller: timeController,
                          keyboardType: TextInputType.datetime,
                          label: "Time Title",
                          hint: "Time Title",
                          prefix: Icons.watch_later_outlined,
                          prefixColor: Colors.grey[600],
                          onTap: (){
                            showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now()).
                            then((value){
                              timeController.text=value!.format(context).toString();
                              debugPrint(value.format(context));
                            });
                          },
                          validate: (value){
                            if(value!.isEmpty){
                              return "time must not be empty";
                            }
                            return null;
                          },
                          focusedColor: const Color(0xff880e4f),
                          lColor:const Color(0xff880e4f),
                          hColor:const Color(0xff880e4f),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        appTextFormField(
                          controller: dateController,
                          keyboardType: TextInputType.datetime,
                          label: "Date Title",
                          hint: "Date Title",
                          prefix: Icons.calendar_today,
                          prefixColor: Colors.grey[600],
                          onTap: (){
                            showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse("2023-04-01")).
                            then((value){
                              debugPrint(DateFormat.yMMMd().format(value!));
                              dateController.text=DateFormat.yMMMd().format(value);
                            });
                          },
                          validate: (value){
                            if(value!.isEmpty){
                              return "date must not be empty";
                            }
                            return null;
                          },
                          focusedColor: const Color(0xff880e4f),
                          lColor:const Color(0xff880e4f),
                          hColor:const Color(0xff880e4f),
                        ),
                      ],
                    ),
                  ),
                )).
            closed.then((value)
            {
              isBottomSheetShown=false;
              setState(() {
                fabIcon= Icons.edit;});
            });
            isBottomSheetShown=true;
            setState(() {
              fabIcon=Icons.add;
            });
          }

          //async {
          // try{
          //   var name= await getName();
          //   print(name);
          //   print("Zeyad");
          //
          //   // throw("error!!!!!!!!!!!!");
          // }
          // catch(error){
          //   print("error ${error.toString()}");
          // }
          // getName().then((value) {
          //   debugPrint(value );
          //   debugPrint("Hasnaa");
          //   throw("error!!!!!");
          // }).catchError((error){
          //   debugPrint("error $error");
          // });
        },
        // onPressed: () async {
        //   var name= await getName();
        //   print(name);
        // },
        child: Icon(fabIcon),
      ) ,
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: const IconThemeData(
          color: Color(0xff880e4f),
        ),
        unselectedIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        type:BottomNavigationBarType.fixed ,
        elevation: 50,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex=index;
          });
        },
        backgroundColor: Colors.grey[900],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label:"Tasks", ),

          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              label:"Done" ),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined),
              label:"Archived" ),
        ],

      ),
    );
  }
  // Future<String?> getName() async
  // {
  //   return "Hello";
  // }
  void createDatabase()async{

    database= await openDatabase(
      "todo.db",
      version:1,
      onCreate: (database,version) {
        //1-id int
        //2-title string
        //3-date string
        //4-time string
        //5-status string
        debugPrint("database created");
        database.execute("CREATE TABLE tasks ("
            "id INTEGER PRIMARY KEY,"
            "title TEXT,"
            "date TEXT,"
            "time TEXT,"
            "status TEXT)")
            .then((value){
          debugPrint("table created");}
        ).catchError((error){
          debugPrint("Error when creating Table"
              " ${error.toString()}");
        });
      },

      onOpen: (database){
        getDataFromDatabase(database).then((value){
          setState(() {
            tasks=value;
          });
        });
        debugPrint("database opened");
      },

    );
  }
  Future insertToDatabase(
      {required String title,
        required String time,
        required String date,}
      )async{
    return await database.transaction((txn)async{
      await txn.rawInsert
        ('INSERT INTO tasks(title,date,time,status)VALUES("$title","$date","$time","new")')
          .then((value){
        debugPrint("$value inserted successfully");
      })
          .catchError((error){
        debugPrint("Error when inserting New record ${error.toString()}");
      });
    });
  }

  Future <List<Map>> getDataFromDatabase(database) async
  {
    return await database.rawQuery('SELECT * FROM tasks');
  }
}