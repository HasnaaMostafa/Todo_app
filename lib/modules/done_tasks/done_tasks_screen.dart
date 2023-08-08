import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoo_app/components/components/conditionalBuilder.dart';

import '../../components/components/buildTasks.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class DoneTasks extends StatelessWidget {
  const DoneTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, Object? state) {  },
        builder: (BuildContext context, state){

          var tasks=AppCubit.get(context).doneTasks;
          return taskBuilder(tasks: tasks);
        }

    );
  }
}