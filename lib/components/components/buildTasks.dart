
import 'package:flutter/material.dart';
import 'package:todoo_app/shared/cubit/cubit.dart';

class buildTasks extends StatelessWidget {
  final Map? model;
  const buildTasks(
      {Key? key,
        this.model,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key:Key(model!["id"].toString()),
      onDismissed: (direction){
        AppCubit.get(context).Deletedata(id: model!["id"],);
      },
      background: Container(
        color: Colors.grey[300],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundColor: const Color(0xff880e4f),
              child: Text("${model!["time"]}",
                style: const TextStyle(fontSize: 14),),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min ,
                children: [
                  Text("${model!["title"]}",
                    style:const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0
                    ),),
                  Text("${model!["date"]}",
                    style:const TextStyle(
                        color:Colors.grey ,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0
                    ),),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(onPressed: (){
              AppCubit.get(context).Updatedata(
                status:"done", id:model!["id"]);
            },
                icon:const Icon(Icons.check_box),
            color: Colors.green,),
            IconButton(onPressed: (){
              AppCubit.get(context).Updatedata(
                status:" archive", id:model!['id']);
            },
                icon:const Icon(Icons.archive),
                color: Colors.black,),
          ],
        ),
      ),
    );
  }
}


