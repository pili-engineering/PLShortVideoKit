var cm = easyar.ComponentManager.getInstance();
var s = easyar.Scene.getInstance();

var arcamera = easyar.ARCameraPrefab.createOnObject(s.rootObject());
arcamera.transform.matrix = easyar.Matrix44F.inverse(easyar.Matrix44F.lookAt({x:0, y:1, z:5}, {x:0, y:1, z:0}, {x:0, y:1, z:0}));
arcamera.open();

//cube
var obj_cube = s.rootObject().createChild();
var geo_cube = new easyar.CubeGeometry();
var mat_cube = new easyar.UnlitMaterial();
mat_cube.diffuseColor = {r:1, g:0, b:0, a:1};
var sur_cube = cm.createComponentOnObject("surface", obj_cube, {material:mat_cube, geometry:geo_cube});
obj_cube.transform.matrix = easyar.Matrix44F.TRS({x:0, y:0, z:-3}, {x:0.5, y:0.5, z:0}, {x:1, y:1, z:1});

//camera
var obj_camera = s.rootObject().createChild();
var com_camera = cm.createComponentOnObject("camera", obj_camera, {});
com_camera.backgroundColor = {r:0.8, g:0.8, b:0.8, a:0.8};
obj_camera.transform.matrix = easyar.Matrix44F.inverse(easyar.Matrix44F.lookAt({x:0, y:0, z:5}, {x:0, y:0, z:0}, {x:0, y:1, z:0}));

com_camera.removeRenderer();
var customPipeline = cm.createComponentOnObject("customPipeline", obj_camera, {});
customPipeline.load("local://Recorder.json");
