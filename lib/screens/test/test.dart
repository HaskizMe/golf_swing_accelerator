// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:three_js/three_js.dart' as three;
// //import 'package:example/src/statistics.dart';
// import 'package:three_js_geometry/three_js_geometry.dart';
// import 'package:three_js_geometry/tube_geometry.dart';
// import 'package:three_js_helpers/three_js_helpers.dart';
// import 'dart:math' as math;
//
//
// class WebglGeometryExtrudeSplines extends StatefulWidget {
//
//   const WebglGeometryExtrudeSplines({super.key});
//
//   @override
//   createState() => _State();
// }
//
// class _State extends State<WebglGeometryExtrudeSplines> {
//   List<int> data = List.filled(60, 0, growable: true);
//   late Timer timer;
//   late three.ThreeJS threeJs;
//
//   @override
//   void initState() {
//     timer = Timer.periodic(const Duration(seconds: 1), (t){
//       setState(() {
//         data.removeAt(0);
//         data.add(threeJs.clock.fps);
//       });
//     });
//     threeJs = three.ThreeJS(
//       onSetupComplete: (){setState(() {});},
//       setup: setup,
//     );
//     super.initState();
//   }
//   @override
//   void dispose() {
//     controls.dispose();
//     timer.cancel();
//     threeJs.dispose();
//     three.loading.clear();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Stack(
//           children: [
//             threeJs.build(),
//             //Statistics(data: data)
//           ],
//         )
//     );
//   }
//   late three.OrbitControls controls;
//   // late CameraHelper cameraHelper;
//   late three.AnimationMixer mixer;
//   // late three.Camera splineCamera;
//   // late three.Mesh cameraEye;
//
//
//   static final golfSwingPath = three.CatmullRomCurve3( points: [
//     three.Vector3(-0.8, 0, 0),        // Starting point (addressing the ball)
//     three.Vector3(-0.7, 0.2, -0.8),   // Backswing: club goes up and behind
//     three.Vector3(-0.45, 0.5, -1.2),
//     three.Vector3(-0.3, 0.8, -1.3),
//     three.Vector3(-0.2, 1.2, -1.4),
//     three.Vector3(0.15, 1.9, -1),
//     three.Vector3(0.15, 2.1, -0.8),
//     three.Vector3(-0.1, 2.3, -0.5),
//     three.Vector3(-0.2, 2.4, -0.2),
//     three.Vector3(-0.3, 2.4, 0),
//     three.Vector3(-0.5, 2.2, 0.3),
//     three.Vector3(-0.7, 2.0, 0.4),
//     three.Vector3(-0.7, 1.5, 0.7),
//     three.Vector3(-0.7, 1.8, 0.7),
//     three.Vector3(-0.7, 2.1, 0.4),
//     three.Vector3(-0.6, 2.1, 0),
//     three.Vector3(-0.3, 2.1, -0.4),
//     three.Vector3(-0.1, 1.8, -0.8),
//     three.Vector3(-0.5, 1.3, -1),
//     three.Vector3(-0.7, 0.8, -0.9),
//     three.Vector3(-0.8, 0.4, -0.7),
//     three.Vector3(-0.8, 0, 0),
//   ]);
//
//   // Keep a dictionary of Curve instances
//   final splines = {
//     'GolfSwingPath': golfSwingPath
//   };
//
//   late three.Object3D parent;
//   late TubeGeometry tubeGeometry;
//   three.Mesh? mesh;
//
//   final Map<String,dynamic> params = {
//     'spline': 'GolfSwingPath',
//     'scale': 1.87,
//     'extrusionSegments': 100,
//     'radiusSegments': 10,
//     'closed': true,
//     'animationView': false,
//     'lookAhead': false,
//     'cameraHelper': false,
//   };
//
//   final material = three.MeshLambertMaterial.fromMap( { 'color': 0xff00ff } );
//
//   final wireframeMaterial = three.MeshBasicMaterial.fromMap( { 'color': 0x000000, 'opacity': 0.3, 'wireframe': true, 'transparent': true } );
//
//   void addTube() {
//     if ( mesh != null ) {
//       parent.remove( mesh! );
//       mesh!.geometry?.dispose();
//     }
//
//     final extrudePath = splines[ params['spline'] ];
//     tubeGeometry = TubeGeometry( extrudePath, params['extrusionSegments'], .03, params['radiusSegments'], params['closed'] );
//     addGeometry( tubeGeometry );
//     setScale();
//   }
//
//
//   void setScale() {
//     mesh?.scale.setValues( params['scale'], params['scale'], params['scale'] );
//     mesh?.position.setValues(1.4, -1.8, -.5);
//   }
//
//
//   void addGeometry( geometry ) {
//     mesh = three.Mesh( geometry, material );
//     final wireframe = three.Mesh( geometry, wireframeMaterial );
//     mesh?.add( wireframe );
//     parent.add( mesh );
//   }
//
//   Future<void> setup() async {
//     threeJs.camera = three.PerspectiveCamera(45, threeJs.width / threeJs.height, 1, 2200);
//     threeJs.camera.position.setValues(3, 6, 10);
//     controls = three.OrbitControls(threeJs.camera, threeJs.globalKey);
//     threeJs.scene = three.Scene();
//     threeJs.scene.background = three.Color.fromHex32(0x87CEEB);
//
//     final ambientLight = three.AmbientLight(0xffffff, 0.9);
//     threeJs.scene.add(ambientLight);
//
//     final pointLight = three.PointLight(0xffffff, 0.8);
//
//     pointLight.position.setValues(0, 0, 0);
//
//     threeJs.camera.add(pointLight);
//     threeJs.scene.add(threeJs.camera);
//
//     threeJs.camera.lookAt(threeJs.scene.position);
//
//     // Load golfer.glb
//     three.GLTFLoader loader = three.GLTFLoader().setPath('assets/');
//     final golfer = await loader.fromAsset('golfer.glb');
//
//     if (golfer?.scene != null) {
//       golfer!.scene.scale.setValues(2, 2, 2); // Scale the golfer
//       golfer.scene.position.setValues(0, 0, 0); // Position the golfer at the origin
//       threeJs.scene.add(golfer.scene);
//
//       // Compute bounding box for the golfer
//       final boundingBox = three.BoundingBox().setFromObject(golfer.scene);
//       final center = boundingBox.getCenter(three.Vector3());
//       final size = boundingBox.getSize(three.Vector3());
//
//       // Center the golfer
//       golfer.scene.position.sub(center); // Adjust position to center the object
//
//       // Adjust the camera to view the model
//       final maxDim = math.max(size.x, math.max(size.y, size.z));
//       final distance = maxDim * 4; // Scale the distance based on object size
//       threeJs.camera.position.setValues(center.x, center.y, distance); // Move the camera back
//       threeJs.camera.lookAt(center); // Point the camera to the center
//
//       print('Golfer centered at: $center with size: $size');
//     } else {
//       print("Failed to load golfer.glb");
//     }
//
//     final object = golfer!.scene;
//     threeJs.scene.add(object);
//     mixer = three.AnimationMixer(object);
//     mixer.clipAction(golfer.animations![0], null, null)!.play();
//
//
//     // Slow down the animation by reducing the timeScale
//     mixer.timeScale = .1; // Slow down to half speed
//
//     threeJs.addAnimationEvent((dt){
//       mixer.update(dt);
//       controls.update();
//     });
//     // Add the TubeGeometry (path)
//     parent = three.Object3D();
//     threeJs.scene.add(parent);
//
//     addTube(); // Recreate the TubeGeometry with scaling
//
//   }
//
//
// }




import 'dart:async';
import 'package:flutter/material.dart';
import 'package:three_js/three_js.dart' as three;
import 'package:three_js/three_js.dart';
import 'package:three_js_geometry/three_js_geometry.dart';
import 'package:three_js_geometry/tube_geometry.dart';
import 'dart:math' as math;

class ThreeD extends StatefulWidget {
  final Map<String, List<double>> swingPoints;

  const ThreeD({required this.swingPoints, super.key});

  @override
  createState() => _State();
}

class _State extends State<ThreeD> {
  late three.ThreeJS threeJs;
  late three.OrbitControls controls;
  late three.Object3D parent;
  late TubeGeometry tubeGeometry;
  List<Vector> swingPathPoints = [];
  three.Mesh? mesh;

  @override
  void initState() {
    calculateSwingPath(xValues: widget.swingPoints['x']!, yValues: widget.swingPoints['y']!, zValues: widget.swingPoints['z']!, deltaT: .01);
    threeJs = three.ThreeJS(
      onSetupComplete: () => setState(() {}),
      setup: setup,
    );
    super.initState();
  }
  @override
  void dispose() {
    controls.dispose();
    threeJs.dispose();
    three.loading.clear();
    super.dispose();
  }

  List<Map<String, double>> calculateSwingPath({
    required List<double> xValues,
    required List<double> yValues,
    required List<double> zValues,
    required double deltaT, // Time difference in seconds (0.01 for 10ms)
  }) {
    const double gForceToAcceleration = 9.81; // Conversion factor
    List<Map<String, double>> path = []; // To store positions (x, y, z)

    // Initialize velocity and position
    double vx = 0, vy = 0, vz = 0;
    double px = 0, py = 0, pz = 0;

    for (int i = 0; i < xValues.length; i++) {
      // Convert g-force to acceleration (m/s²)
      double ax = xValues[i] * gForceToAcceleration;
      double ay = yValues[i] * gForceToAcceleration;
      double az = zValues[i] * gForceToAcceleration;

      // Update velocity (trapezoidal integration)
      if (i > 0) {
        double prevAx = xValues[i - 1] * gForceToAcceleration;
        double prevAy = yValues[i - 1] * gForceToAcceleration;
        double prevAz = zValues[i - 1] * gForceToAcceleration;

        vx += (deltaT / 2) * (ax + prevAx);
        vy += (deltaT / 2) * (ay + prevAy);
        vz += (deltaT / 2) * (az + prevAz);
      }

      // Update position (trapezoidal integration)
      if (i > 0) {
        double prevVx = vx - (deltaT / 2) * ax;
        double prevVy = vy - (deltaT / 2) * ay;
        double prevVz = vz - (deltaT / 2) * az;

        px += (deltaT / 2) * (vx + prevVx);
        py += (deltaT / 2) * (vy + prevVy);
        pz += (deltaT / 2) * (vz + prevVz);
      }

      swingPathPoints.add(three.Vector3(px, py, pz));
      // Store position in the path
      path.add({'x': px, 'y': py, 'z': pz});
    }

    return path;
  }

  final Map<String,dynamic> params = {
    'spline': 'GolfSwingPath',
    'scale': 1.87,
    'extrusionSegments': 100,
    'radiusSegments': 10,
    'closed': true,
    'animationView': false,
    'lookAhead': false,
    'cameraHelper': false,
  };

  // static final golfSwingPath = three.CatmullRomCurve3(
  //     points: [
  //       three.Vector3(-0.8, 0, 0),
  //       three.Vector3(-0.7, 0.2, -0.8),
  //       three.Vector3(-0.45, 0.5, -1.2),
  //       three.Vector3(-0.3, 0.8, -1.3),
  //       three.Vector3(-0.2, 1.2, -1.4),
  //       three.Vector3(0.15, 1.9, -1),
  //       three.Vector3(0.15, 2.1, -0.8),
  //       three.Vector3(-0.1, 2.3, -0.5),
  //       three.Vector3(-0.2, 2.4, -0.2),
  //       three.Vector3(-0.3, 2.4, 0),
  //       three.Vector3(-0.5, 2.2, 0.3),
  //       three.Vector3(-0.7, 2.0, 0.4),
  //       three.Vector3(-0.7, 1.5, 0.7),
  //       three.Vector3(-0.7, 1.8, 0.7),
  //       three.Vector3(-0.7, 2.1, 0.4),
  //       three.Vector3(-0.6, 2.1, 0),
  //       three.Vector3(-0.3, 2.1, -0.4),
  //       three.Vector3(-0.1, 1.8, -0.8),
  //       three.Vector3(-0.5, 1.3, -1),
  //       three.Vector3(-0.7, 0.8, -0.9),
  //       three.Vector3(-0.8, 0.4, -0.7),
  //       three.Vector3(-0.8, 0, 0),
  // ]);

  // static final golfSwingPath = three.CatmullRomCurve3(
  //     points: swingPathPoints);

  final material = three.MeshLambertMaterial.fromMap( { 'color': 0xff00ff } );

  final wireframeMaterial = three.MeshBasicMaterial.fromMap( { 'color': 0x000000, 'opacity': 0.3, 'wireframe': true, 'transparent': true } );

  void addSwingPath() {
    parent = three.Object3D();
    threeJs.scene.add(parent);
    if ( mesh != null ) {
      parent.remove( mesh! );
      mesh!.geometry?.dispose();
    }

    // Makes a swing path with tube geometry
    //final extrudePath = golfSwingPath;
    final golfSwingPath = three.CatmullRomCurve3(points: swingPathPoints);
    tubeGeometry = TubeGeometry( golfSwingPath, params['extrusionSegments'], .03, params['radiusSegments'], params['closed'] );
    mesh = three.Mesh( tubeGeometry, material );
    final wireframe = three.Mesh( tubeGeometry, wireframeMaterial );
    mesh?.add( wireframe );
    parent.add( mesh );

    // We set the scale of the swing path and set the position of it in the scene
    mesh?.scale.setValues( params['scale'], params['scale'], params['scale'] );
    mesh?.position.setValues(1.4, -1.8, -.5);
  }

  void setUpBackground() {
    // Add background to scene
    threeJs.scene = three.Scene();
    threeJs.scene.background = three.Color.fromHex32(0x87CEEB); // Sky blue color

    // Adds ambient light to scene
    final ambientLight = three.AmbientLight(0xffffff, 0.9);
    threeJs.scene.add(ambientLight);

    final pointLight = three.PointLight(0xffffff, 0.8);
    pointLight.position.setValues(0, 10, 10); // Move the light above the scene
    threeJs.scene.add(pointLight);

    // Add sky (large sphere)
    final skyGeometry = three.SphereGeometry(500, 32, 32); // Large sphere
    final skyMaterial = three.MeshBasicMaterial.fromMap({
      'color': 0x87CEEB, // Sky blue color
      'side': three.BackSide // Render inside of the sphere
    });
    final sky = three.Mesh(skyGeometry, skyMaterial);
    threeJs.scene.add(sky);

    // Add Ground
    final groundGeometry = three.PlaneGeometry(200, 200); // Large plane
    final groundMaterial = three.MeshLambertMaterial.fromMap({'color': 0x00ff00}); // Green color
    final ground = three.Mesh(groundGeometry, groundMaterial);
    ground.rotation.x = -math.pi / 2; // Rotate to lay flat
    ground.position.y = -2.4; // Position just below the model
    //threeJs.scene.add(ground);
  }

  Future<void> loaderGolferAsset() async {
    // Load golfer.glb
    three.GLTFLoader loader = three.GLTFLoader().setPath('assets/');
    final golfer = await loader.fromAsset('stickFigureGolfer.glb');

    if (golfer?.scene != null) {
      golfer!.scene.scale.scale(2); // Scale the golfer
      //golfer.scene.position.setValues(0, 2, 0); // Position the golfer at the origin
      threeJs.scene.add(golfer.scene);

      // Compute bounding box for the golfer
      final boundingBox = three.BoundingBox().setFromObject(golfer.scene);
      final center = boundingBox.getCenter(three.Vector3());
      final size = boundingBox.getSize(three.Vector3());

      // Center the golfer
      golfer.scene.position.sub(center); // Adjust position to center the object
      golfer.scene.position.x += 1.0;    // Move it slightly to the right on the X-axis

      //golfer.scene.position.setValues(0, 0, 0);
      // Adjust the camera to view the model
      final maxDim = math.max(size.x, math.max(size.y, size.z));
      final distance = maxDim * 4.5; // Scale the distance based on object size
      threeJs.camera.position.setValues(center.x, center.y, distance); // Move the camera back
      threeJs.camera.lookAt(center); // Point the camera to the center

      print('Golfer centered at: $center with size: $size');
      final object = golfer.scene;
      threeJs.scene.add(object);
    } else {
      print("Failed to load golfer.glb");
    }
  }

  // Setup up camera and orbit controls
  void setupCamera(){
    threeJs.camera = three.PerspectiveCamera(45, threeJs.width / threeJs.height, 1, 2200);
    threeJs.camera.position.setValues(3, 6, 10);
    controls = three.OrbitControls(threeJs.camera, threeJs.globalKey);
  }

  Future<void> setup() async {
    setupCamera();
    setUpBackground();
    await loaderGolferAsset();
    addSwingPath();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        body: Stack(
          children: [
            threeJs.build(),
          ],
        )
    );
  }



}
