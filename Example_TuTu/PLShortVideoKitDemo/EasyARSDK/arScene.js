var cm = easyar.ComponentManager.getInstance();
var s = easyar.Scene.getInstance();

var arcamera = easyar.ARCameraPrefab.createOnObject(s.rootObject());
arcamera.transform.matrix = easyar.Matrix44F.inverse(easyar.Matrix44F.lookAt({ x: 0, y: 1, z: 5 }, { x: 0, y: 1, z: 0 }, { x: 0, y: 1, z: 0 }));
//arcamera.setCenterMode("augmenter");

arcamera.open();

//light
var obj_light1 = s.rootObject().createChild();
var com_light1 = cm.createComponentOnObject("directionalLight", obj_light1, {});
var obj_light2 = s.rootObject().createChild();
var com_light2 = cm.createComponentOnObject("ambientLight", obj_light2, {});
com_light2.ambient = 0.7;

var obj_spm = s.rootObject().createChild();
obj_spm.name = "spm2_root";
var spm_loader = cm.createComponentOnObject("ezm", obj_spm, {});

spm_loader.load("asset/model/abc.spm2", function(obj){
	obj.active = true;
	console.log(obj.parent);
		console.log(obj.children());

	obj.children().forEach(function(cn) {
		cn.components().forEach(function(c){
			if(c.kind == "animation"){
				c.playAtIndex(0);
			}
			else if (c.kind == "particlesystem") {
				c.play();
			}
		});
	});
});

