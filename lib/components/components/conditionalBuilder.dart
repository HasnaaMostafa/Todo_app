


import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import 'buildTasks.dart';

class taskBuilder extends StatelessWidget {
  final List<Map> tasks;
  const taskBuilder(
      {Key? key,
        required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (BuildContext context)=>ListView.separated(
          itemBuilder: (context,index)=> buildTasks(model: tasks[index],),
          separatorBuilder:(context,index)=>Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 20.0
            ),
            child: Container(
              width: double.infinity,
              height: 0.1,
              color: Colors.grey[500],
            ),
          ),
          itemCount:tasks.length),
      fallback: (BuildContext context)=>Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.menu,size: 80,color: Colors.grey),
            Text("No Tasks yet , Please Add Some Tasks",
              style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
              ),),
          ],
        ),
      ),

    );
  }
}
