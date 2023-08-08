
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoo_app/shared/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit() : super(AppInitialState());

  static AppCubit get(context)=>BlocProvider.of(context);

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

  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List <Map> newTasks=[];
  List <Map> doneTasks=[];
  List <Map> archivedTasks=[];

  void createDatabase(){
    openDatabase(
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
        getDataFromDatabase(database);
        debugPrint("database opened");
      },
    ).then((value){
      database=value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase(
      {required String title,
        required String time,
        required String date,}
      )async{
     await database.transaction((txn)async{
      await txn.rawInsert
        ('INSERT INTO tasks(title,date,time,status)VALUES("$title","$date","$time","new")')
          .then((value){
        debugPrint("$value inserted successfully");
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      })
          .catchError((error){
        debugPrint("Error when inserting New record ${error.toString()}");
      });
    });
  }

  void getDataFromDatabase(database)
  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value){

      value.forEach((element) {
        if(element["status"]=="new") {
          newTasks.add(element);
        } else if(element["status"]=="done") {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void Updatedata({
    required String status,
    required int id,
}) {
     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id])
     .then((value){
       getDataFromDatabase(database);
       emit(AppUpdateDatabaseState());
     });
  }


  void Deletedata({
    required int id,
  }) {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id])
        .then((value){
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }


  bool isBottomSheetShown=false;
  IconData fabIcon=Icons.edit;

  void ChangeBottomSheetState(
  {
    required bool isShow,
    required IconData icon,
}){
    isBottomSheetShown=isShow;
    fabIcon=icon;

    emit(AppChangeBottomSheetState());
  }
}