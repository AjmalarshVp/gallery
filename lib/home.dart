// ignore_for_file: override_on_non_overriding_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/zoom.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

ValueNotifier<List> database = ValueNotifier([]);

class gallery extends StatefulWidget {
  const gallery({Key? key}) : super(key: key);

  @override
  State<gallery> createState() => _galleryState();
}

class _galleryState extends State<gallery> {

  getPermissionCamera()async{
    var checkStatus =  await Permission.camera.status;
    if(checkStatus.isGranted){
     getPermissionStorage();
    } else if(checkStatus.isDenied){
      await Permission.camera.request();
      if(checkStatus.isGranted){
        getPermissionStorage();
      }
    }else{
      const SnackBar(content: Text("Please enable camera permission to continue",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,);
      openAppSettings();
    }
    }

  getPermissionStorage()async{
   var storagePermission = await Permission.storage.status;
   var managePermission = await Permission.manageExternalStorage.status;
   var mediaPermission = await Permission.accessMediaLocation.status;
   if(storagePermission.isGranted && managePermission.isGranted && mediaPermission.isGranted){
    await getimage();
     
   }else if(storagePermission.isDenied||managePermission.isDenied||mediaPermission.isDenied){
     await Permission.storage.request();
     await Permission.accessMediaLocation.request();
     await Permission.manageExternalStorage.request();
     if(storagePermission.isGranted && managePermission.isGranted){
       getimage();
      
     }
   }else{
     const SnackBar(content: Text("Please enable storage permission to continue",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,);
     openAppSettings();
   }
 }



  // void initstate() {
  //  print('...........fuck.....');
  //    Directory directory = Directory.fromUri(
  //       Uri.parse('/data/user/0/com.example.flutter_application_1/'));
  //    getitems(directory);
  //       super.initState();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('...........check.....');
     Directory directory = Directory.fromUri(
       Uri.parse('/data/user/0/com.example.flutter_application_1/'));
     getitems(directory);
  }

  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getPermissionCamera();

         
        },
        child: Icon(Icons.camera_alt_rounded),
      ),
      body: ValueListenableBuilder(
        valueListenable: database,
        builder: (context, List data, _) {
          return GridView.extent(
            maxCrossAxisExtent: 180,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: List.generate(
              data.length,
              (index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => Zoom(data: data[index])));
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete"),
                          content: const Text("Do you want to delete?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("No")),
                            TextButton(
                                onPressed: () async {
                                  File file = File(data[index].imagepath);
                                  if (await file.exists()) {
                                    await file.delete();
                                  }
                                  data[index].delete();
                                  Navigator.pop(context);
                                },
                                child: const Text("Yes")),
                          ],
                        );
                      },
                    );
                  },
                  child: Hero(
                    tag: data[index],
                    child: Image.file(File(data[index].toString())),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  getitems(Directory directory) async {
    final listdir = await directory.list().toList();
    database.value.clear();
    listdir.forEach((element) {
      if (element.path.substring((element.path.length - 4)) == '.jpg') {
        database.value.add(element.path);
        database.notifyListeners();
      }
    });
  }

   
          Future  getimage()async{
            final image =
              await ImagePicker().pickImage(source: ImageSource.camera);
          if (image == null) {
            return;
          } else {
            File imagepath = File(image.path);
            print('ajmal...............$imagepath');
            await imagepath.copy(
                '/data/user/0/com.example.flutter_application_1/image_(${DateTime.now()}).jpg');
            Directory directory = Directory.fromUri(
                Uri.parse('/data/user/0/com.example.flutter_application_1/'));
            getitems(directory);
            GallerySaver.saveImage(imagepath.path, albumName: 'rohu');
          }


          }
}
