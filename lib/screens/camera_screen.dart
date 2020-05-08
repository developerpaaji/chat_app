import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:chat_app/screens/story_create_screen.dart';
import 'package:chat_app/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat_app/widgets/thumbnail_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chat_app/widgets/camera_button.dart';
import 'package:chat_app/widgets/switch_icon.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin<CameraScreen> {
  CameraController controller;
  TabController tabController;
  String videoPath;
  VoidCallback videoPlayerListener;
  String imagePath;
  List<CameraDescription> cameras;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    WidgetsBinding.instance.addObserver(this);
    getCameras();
    tabController = TabController(length: 2, vsync: this);
    getPermissions();
  }

  Future getPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions(
            [PermissionGroup.storage, PermissionGroup.camera]);
    if (permissions[PermissionGroup.storage] == PermissionStatus.granted &&
        permissions[PermissionGroup.camera] == PermissionStatus.granted) {
      setState(() {
        isPermitted = true;
      });
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.medium);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future getCameras() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
  Future<String> takePicture({bool video = false}) async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    Directory extDir;
    extDir = await getTemporaryDirectory();

    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';
    int seconds = DateTime.now().second;
    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    int after = DateTime.now().second;
    print("Time taken in ${after - seconds}seconds");
    print(filePath);
    controller.dispose();
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => StoryCreateScreen(
                  imagePath: filePath,
                )))
        .then((val) {
      getCameras();
    });
    if (!video)
      setState(() {
        imagePath = filePath;
      });
    else {
      imagePath = filePath;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    print(e.code + e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  bool isPermitted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: !isPermitted
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Camera Permission Not Given",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: RoundedButton(
                      "Give Permissions",
                      onTap: () {
                        getPermissions();
                      },
                    ),
                  )
                ],
              )
            : Stack(
                children: <Widget>[_cameraPreviewWidget(), getOptionsWidget()],
              ),
      ),
    );
  }

  Widget getOptionsWidget() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        leading: CloseButton(),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.flash_off),
              onPressed: () {
                showInSnackBar("Flash not implemented yet");
              }),
          IconButton(
              icon: Icon(Icons.brightness_2),
              onPressed: () {
                showInSnackBar("Feature not implemented");
              }),
        ],
      ),
      bottomNavigationBar: getCameraButtonRow(),
    );
  }

  Widget _cameraPreviewWidget() {
    final size = MediaQuery.of(context).size;
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Transform.scale(
        scale: controller.value.aspectRatio / size.aspectRatio,
        child: Center(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
        ),
      );
    }
  }

  Widget _getThumbnail() {
    return ThumbnailWidget(
      imagePath: imagePath,
      size: 36.0,
    );
  }

  Widget _getCameraSwitch() {
    return SwitchIcon(
      size: 24.0,
      onTap: () {
        if (controller != null && !controller.value.isRecordingVideo) {
          CameraLensDirection direction = controller.description.lensDirection;
          CameraLensDirection required = direction == CameraLensDirection.front
              ? CameraLensDirection.back
              : CameraLensDirection.front;
          for (CameraDescription cameraDescription in cameras) {
            if (cameraDescription.lensDirection == required) {
              onNewCameraSelected(cameraDescription);
              return;
            }
          }
        }
      },
    );
  }

  Widget getCameraButtonRow() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CameraButton(
          takePicture: takePicture,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _getThumbnail(),
              Expanded(
                child: Container(
                  height: 50.0,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: TabBar(
                    isScrollable: false,
                    tabs: [
                      Tab(
                        text: "Camera",
                      ),
                      Tab(
                        text: "Video",
                      ),
                    ],
                    indicatorColor: Colors.white,
                    indicatorWeight: 3.0,
                    indicatorSize: TabBarIndicatorSize.tab,
                    controller: tabController,
                    onTap: (index) {
                      if (index == 1) {
                        showInSnackBar("Sorry video not supported yet.");
                      }
                    },
                  ),
                ),
              ),
              _getCameraSwitch()
            ],
          ),
        ),
      ],
    );
  }

  // Start Video Recording
  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getExternalStorageDirectory();

    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';
    await takePicture(video: true);
    if (controller.value.isRecordingVideo) {
      showInSnackBar("Already Recording");
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    print(filePath);

    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    setState(() {});
    // await _startVideoPlayer();
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}
