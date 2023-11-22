import 'package:fahem/core/utils/enums.dart';
import 'package:flutter/material.dart';

class JobDetailsProvider with ChangeNotifier {

  JobDetailsMode _jobDetailsMode = JobDetailsMode.jobDetails;
  JobDetailsMode get jobDetailsMode => _jobDetailsMode;
  changeJobDetailsMode(JobDetailsMode jobDetailsMode) {_jobDetailsMode = jobDetailsMode; notifyListeners();}
}