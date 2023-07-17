import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tdtrong_mockup/app/common/helper_function.dart';
import 'package:tdtrong_mockup/app/models/finger_scan_model.dart';
import 'package:tdtrong_mockup/app/native_invoke/native_utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = HomeController();
  List<CameraDescription> cameras = [];
  late CameraController _cameraController;
  @override
  void initState() {
    controller.onInit();
    initializeCamera();

    super.initState();
  }

  @override
  void dispose() {
    controller.onClose();
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
  }

  Future<void> takePortraitPhoto() async {
    final CameraController cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );

    await cameraController.initialize();

    if (cameraController.value.isInitialized) {
      final ImagePicker picker = ImagePicker();

      XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        var hash = await toHashSHA256(File(photo.path));
        var file = File(photo.path);
        controller.face.value = Biometrics(
          file: file,
          base64: fileToBase64(file),
          hash256: hash,
        );
      }
    }
  }

  Future<void> onfingerScan() async {
    var res = await NativeUtils.fingerScan();
    if (res != null) {
      var data = Finger.fromJson(res);
      if (data.imagePath != null) {
        var file = File(data.imagePath!);
        var x = Biometrics(
          base64: data.wspBase64,
          hash256: await toHashSHA256(file),
          file: file,
        );
        controller.finger.value = x;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fingers Scan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGroupFace(context),
              const SizedBox(height: 16),
              _buildGroupFinger(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupFinger(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black26),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              Obx(
                () {
                  if (controller.finger.value.file == null) {
                    return Container();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.file(controller.finger.value.file!)),
                  );
                },
              ),
              Obx(() {
                if (controller.finger.value.hash256 == null) {
                  return Container();
                }
                return Text(controller.finger.value.hash256!);
              }),
              TextButton(
                onPressed: onfingerScan,
                child: Text(
                  'Click to Scan Finger',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.blue),
                ),
              ),
              Obx(
                () => ElevatedButton(
                  onPressed: (controller.finger.value.hash256 == null)
                      ? null
                      : () => controller.onSubmit(type: 1),
                  child: const Text('Upload'),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          if (controller.finger.value.hash256 == null) {
            return Container();
          }
          return Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                controller.finger.value = Biometrics();
              },
              icon: const Icon(Icons.close),
            ),
          );
        })
      ],
    );
  }

  Widget _buildGroupFace(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black26),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              Obx(
                () {
                  if (controller.face.value.file == null) {
                    return Container();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.file(controller.face.value.file!)),
                  );
                },
              ),
              Obx(() {
                if (controller.face.value.hash256 == null) {
                  return Container();
                }
                return Text(controller.face.value.hash256!);
              }),
              TextButton(
                onPressed: takePortraitPhoto,
                child: Text(
                  'Click to take photo',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.blue),
                ),
              ),
              Obx(
                () => ElevatedButton(
                  onPressed: (controller.face.value.hash256 == null)
                      ? null
                      : () => controller.onSubmit(type: 0),
                  child: const Text('Upload'),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          if (controller.face.value.hash256 == null) {
            return Container();
          }
          return Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                controller.face.value = Biometrics();
              },
              icon: const Icon(Icons.close),
            ),
          );
        })
      ],
    );
  }
}
