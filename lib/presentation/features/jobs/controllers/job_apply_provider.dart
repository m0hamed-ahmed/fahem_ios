import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/network/api_constants.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/services/notification_service.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/core/utils/upload_file_provider.dart';
import 'package:fahem/data/models/jobs/employment_applications/employment_application_model.dart';
import 'package:fahem/domain/usecases/jobs/employment_applications/insert_employment_application_usecase.dart';
import 'package:fahem/domain/usecases/shared/upload_file_usecase.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobApplyProvider with ChangeNotifier {
  final InsertEmploymentApplicationUseCase _insertEmploymentApplicationUseCase;

  JobApplyProvider(this._insertEmploymentApplicationUseCase);

  Future<Either<Failure, void>> insertEmploymentApplication(InsertEmploymentApplicationParameters parameters) async {
    return await _insertEmploymentApplicationUseCase.call(parameters);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  bool _isButtonClicked = false;
  bool get isButtonClicked => _isButtonClicked;
  setIsButtonClicked(bool isButtonClicked) => _isButtonClicked = isButtonClicked;
  changeIsButtonClicked(bool isButtonClicked) {_isButtonClicked = isButtonClicked; notifyListeners();}

  FilePickerResult? _cvFile;
  FilePickerResult? get cvFile => _cvFile;
  setCvFile(FilePickerResult? cvFile) => _cvFile = cvFile;
  changeCvFile(FilePickerResult? cvFile) {_cvFile = cvFile; notifyListeners();}

  bool isDataValid(BuildContext context) {
    // AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    if(_cvFile == null) {return false;}
    // else if(_cvFile!.files.single.path!.split('.').last.toLowerCase() != 'pdf') {
    //   Dialogs.showBottomSheetMessage(
    //     context: context,
    //     message: Methods.getText(StringsManager.thisExtensionIsNotAllowedOnlyPdfIsAllowed, appProvider.isEnglish).toCapitalized(),
    //   );
    //   return false;
    // }
    return true;
  }

  void resetAllData() {
    setIsButtonClicked(false);
    setCvFile(null);
  }

  String getKeyword(String targetName) {
    if(targetName == ConstantsManager.lawyersTargetName) {
      return ConstantsManager.fahemBusinessLawyersKeyword;
    }
    else if(targetName == ConstantsManager.publicRelationsTargetName) {
      return ConstantsManager.fahemBusinessPublicRelationsKeyword;
    }
    else if(targetName == ConstantsManager.legalAccountantsTargetName) {
      return ConstantsManager.fahemBusinessLegalAccountantsKeyword;
    }
    return '';
  }

  Future<void> onPressedSendEmploymentApplication({required BuildContext context, required EmploymentApplicationModel employmentApplicationModel, required String jobTitle}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    UploadFileProvider uploadFileProvider = Provider.of<UploadFileProvider>(context, listen: false);

    changeIsLoading(true);

    // Upload File
    UploadFileParameters parameters = UploadFileParameters(
      file: File(_cvFile!.files.single.path!),
      directory: ApiConstants.employmentApplicationsDirectory,
    );
    Either<Failure, String> response = await uploadFileProvider.uploadFileImpl(parameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (fileName) async {
      // Insert Employment Application
      employmentApplicationModel.cv = fileName;
      InsertEmploymentApplicationParameters parameters = InsertEmploymentApplicationParameters(
        employmentApplicationModel: employmentApplicationModel,
      );
      Either<Failure, void> response = await insertEmploymentApplication(parameters);
      response.fold((failure) async {
        changeIsLoading(false);
        Dialogs.failureOccurred(context, failure);
      }, (_) async {
        NotificationService.pushNotification(topic: '${employmentApplicationModel.targetId}${getKeyword(employmentApplicationModel.targetName)}', title: 'طلب توظيف', body: 'العميل ${employmentApplicationModel.name} تقدم بطلب الى وظيفة $jobTitle');
        changeIsLoading(false);
        Dialogs.showBottomSheetMessage(
          context: context,
          message: Methods.getText(StringsManager.yourJobApplicationHasBeenSentSuccessfully, appProvider.isEnglish).toCapitalized(),
          showMessage: ShowMessage.success,
          thenMethod: () => Navigator.pop(context),
        );
      });
    });
  }
}