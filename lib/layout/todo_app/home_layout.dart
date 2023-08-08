
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoo_app/shared/cubit/cubit.dart';
import 'package:todoo_app/shared/cubit/states.dart';
import '../../components/components/app_textformfield.dart';
import '../../components/constaints/constaints.dart';
import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();
  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();



  // @override
  // void initState() {
  //   super.initState();
  //   createDatabase();
  //
  // }
  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context,AppStates state) {
          if (state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context,AppStates state) {

          AppCubit cubit=AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: const Color(0xff880e4f),
              title: Center(
                child: Text(
                    cubit.title[cubit.currentIndex]
                ),
              ),
            ),
            body:ConditionalBuilder(
              condition:state is! AppGetDatabaseLoadingState,
              builder:(context) => cubit.screens[cubit.currentIndex],
              fallback:(context) => const Center(child: CircularProgressIndicator()), ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xff880e4f),
              onPressed: () {
                if(cubit.isBottomSheetShown){
                  if(formKey.currentState!.validate())
                  {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
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
                    cubit.ChangeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit);
                  });

                  cubit.ChangeBottomSheetState(
                      isShow: true,
                      icon: Icons.add);
                }

              },
              // onPressed: () async {
              //   var name= await getName();
              //   print(name);
              // },
              child: Icon(cubit.fabIcon),
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
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
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

      ),
    );
  }
  // Future<String?> getName() async
  // {
  //   return "Hello";
  // }
}


//1-create database
//2-create tables
//3-open database
//4-insert database
//5-get from database
//6-update in database
//7-Delete da
