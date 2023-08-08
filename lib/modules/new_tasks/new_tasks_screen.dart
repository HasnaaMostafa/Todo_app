
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoo_app/components/components/conditionalBuilder.dart';
import 'package:todoo_app/shared/cubit/cubit.dart';
import 'package:todoo_app/shared/cubit/states.dart';
import '../../components/components/buildTasks.dart';
import '../../components/constaints/constaints.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, Object? state) {  },
      builder: (BuildContext context, state){

        var tasks=AppCubit.get(context).newTasks;
        return taskBuilder(
            tasks: tasks);
      }

    );
  }
}
