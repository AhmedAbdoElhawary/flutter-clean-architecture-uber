import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:uber/core/resources/color_manager.dart';
import 'package:uber/core/resources/styles_manager.dart';
import 'package:uber/presentation/common_widgets/custom_elevated_button.dart';
import 'package:uber/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import 'package:uber/presentation/pages/register/code_verification/logic/code_verification_logic.dart';
import 'package:uber/presentation/pages/register/widgets/next_button.dart';

class CodeVerificationPage extends StatelessWidget {
  final String mobilePhone;
  const CodeVerificationPage({Key? key, required this.mobilePhone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CodeVerificationLogic controller= Get.put(CodeVerificationLogic(mobilePhone));
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: REdgeInsets.symmetric(vertical: 35.0, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Enter the 4-digit code sent to you at\n$mobilePhone."),
              Container(
                padding: REdgeInsets.only(top: 35, bottom: 15),
                constraints: BoxConstraints(maxWidth: 380.w),
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.scale,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5.r),
                    fieldHeight: 50.h,
                    fieldWidth: 50.w,
                    borderWidth: 2.4.w,
                    activeFillColor: ColorManager.veryLightGrey,
                    activeColor: ColorManager.black,
                    inactiveColor: ColorManager.transparent,
                    inactiveFillColor: ColorManager.veryLightGrey,
                    selectedColor: ColorManager.black,
                    selectedFillColor: ColorManager.veryLightGrey,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  controller: controller.verificationController.value,
                  onCompleted: (v) {
                    controller.otpCode.value = v;
                  },
                  onChanged: (value) {
                    controller.otpCode.value = value;
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                ),
              ),
              const _DidNotReceiveCodeButton(),
              const Spacer(),
              Padding(
                padding: REdgeInsets.only(bottom: 35.0),
                child: Row(
                  children: [
                    ElevatedButton(
                        style: buildStyleFrom(),
                        onPressed: () {
                          Navigator.of(context).maybePop();
                        },
                        child: Icon(Icons.arrow_back, size: 30.r)),
                    const Spacer(),
                    _BuildNextButton(controller: controller),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildNextButton extends StatelessWidget {
  final CodeVerificationLogic controller;
  const _BuildNextButton({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<FirebaseAuthCubit, FirebaseAuthCubitState>(
      listenWhen: (previous, current) => previous != current,
      listener: controller.nextButtonListener,
      child: Obx(
        () => NextButton(
          enableButton: controller.enableNextButton,
          onPressed: () async => await controller.onPressedVerify(context),
        ),
      ),
    );
  }
}

class _DidNotReceiveCodeButton extends StatelessWidget {
  const _DidNotReceiveCodeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buildStyleFrom(),
      onPressed: () {
        bottomSheet(context);
      },
      child: Text(
        "I didn't receive a code",
        style: getBoldStyle(fontSize: 16),
      ),
    );
  }

  Future<void> bottomSheet(BuildContext context) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return const _CustomBottomSheet();
      },
    );
  }
}

class _CustomBottomSheet extends StatelessWidget {
  const _CustomBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).splashColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0.r)),
      ),
      child: Padding(
        padding: REdgeInsets.symmetric(vertical: 15.0, horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const RSizedBox(height: 18),
            CustomElevatedButton(
                child: Text("Call me with code",
                    style: getBoldStyle(fontSize: 17)),
                onPressed: () {}),
            const RSizedBox(height: 18),
            CustomElevatedButton(
                child: Text("Resend code via SMS",
                    style: getBoldStyle(fontSize: 17)),
                onPressed: () {}),
            const RSizedBox(height: 18),
            CustomElevatedButton(
                child: Text("Send code via WhatsApp",
                    style: getBoldStyle(fontSize: 17)),
                onPressed: () {}),
            const RSizedBox(height: 18),
            CustomElevatedButton(
                backgroundColor: ColorManager.black,
                child: Text("Cancel",
                    style:
                        getBoldStyle(fontSize: 17, color: ColorManager.white)),
                onPressed: () {
                  Navigator.of(context).maybePop();
                }),
            const RSizedBox(height: 7),
          ],
        ),
      ),
    );
  }
}

ButtonStyle buildStyleFrom(
    {EdgeInsetsGeometry? padding, Color? backgroundColor}) {
  return ElevatedButton.styleFrom(
    backgroundColor: backgroundColor ?? ColorManager.veryLightGrey,
    minimumSize: const Size(0, 0),
    padding: padding,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(35.0.r),
    ),
  );
}
