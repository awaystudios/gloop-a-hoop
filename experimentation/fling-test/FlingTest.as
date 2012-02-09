package
{

	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.core.raytracing.picking.MouseHitMethod;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.ConeGeometry;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapTexture;

	import awayphysics.collision.shapes.AWPBoxShape;

	import awayphysics.collision.shapes.AWPSphereShape;
	import awayphysics.collision.shapes.AWPStaticPlaneShape;
	import awayphysics.debug.AWPDebugDraw;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;

	import com.li.litools.away3d.camera.OrbitCameraController;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;

	public class FlingTest extends Sprite
	{
		[Embed(source="../assets/images/checkerboard.jpg")]
		private var CheckerboardImage:Class;

		private var _view:View3D;
		private var _cameraLight:PointLight;
		private var _wallMaterial:ColorMaterial;
		private var _floorMaterial:TextureMaterial;
		private var _gloopMaterial:ColorMaterial;
		private var _obstacleMaterial:ColorMaterial;
		private var _physicsWorld:AWPDynamicsWorld;
		private var _physicsDebugDraw:AWPDebugDraw;
		private var _gloopBody:AWPRigidBody;
		private var _draggingGloop:Boolean;
		private var _gloopIsFlying:Boolean;
		private var _directorMesh:Mesh;
		private var _gloopMesh:Mesh;
		private var _cameraController:OrbitCameraController;

		private const PHYSICS_TIME_STEP:Number = 1.0 / 60;

		public function FlingTest() {
			addEventListener( Event.ADDED_TO_STAGE, stageInitHandler );
		}

		private function stageInitHandler( evt:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, stageInitHandler );
			initStage();
			initRenderCore();
			initPhysicsCore();
			initLevel();
			initGloop();
			addEventListener( Event.ENTER_FRAME, enterframeHandler );
		}

		// -----------------------
		// core
		// -----------------------

		private function initStage():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			stage.addEventListener( MouseEvent.MOUSE_DOWN, stageMouseDownHandler );
			stage.addEventListener( MouseEvent.MOUSE_UP, stageMouseUpHandler );
		}

		private function initRenderCore():void {
			// view
			_view = new View3D();
			_view.antiAlias = 4;
			addChild( _view );
			// camera
			_view.camera.lens.far = 1000000;
			_view.camera.position = new Vector3D( 0, 300, -700 );
//			_view.camera.lookAt( new Vector3D( 0, 500, 1000 ) );
			// camera controller
			_cameraController = new OrbitCameraController( _view.camera, stage );
			_cameraController.mouseInputFactor = 0.005;
			_cameraController.maxElevation = 0.5;
			// lights
			_cameraLight = new PointLight();
			_cameraLight.specular = 0.2;
			_cameraLight.transform = _view.camera.transform.clone();
			_view.scene.addChild( _cameraLight );
			var lights:StaticLightPicker = new StaticLightPicker( [ _cameraLight ] );
			// materials
			_floorMaterial = new TextureMaterial( new BitmapTexture( new CheckerboardImage().bitmapData ) );
			_floorMaterial.lightPicker = lights;
			_wallMaterial = new ColorMaterial( 0x666666 );
			_wallMaterial.lightPicker = lights;
			_wallMaterial.ambient = 0.5;
			_gloopMaterial = new ColorMaterial( 0x00FF00 );
			_gloopMaterial.lightPicker = lights;
			_obstacleMaterial = new ColorMaterial( 0x0000FF );
			_obstacleMaterial.lightPicker = lights;
		}

		private function initPhysicsCore():void {
			// world
			_physicsWorld = new AWPDynamicsWorld();
			_physicsWorld.initWithDbvtBroadphase();
			_physicsWorld.collisionCallbackOn = true;
			_physicsWorld.gravity = new Vector3D( 0, -20, 0 );
			// debug world
			_physicsDebugDraw = new AWPDebugDraw( _view, _physicsWorld );
			_physicsDebugDraw.debugMode = AWPDebugDraw.DBG_NoDebug;
		}

		// -----------------------
		// gloop
		// -----------------------

		private function initGloop():void {
			// create gloop
			var ballShape:AWPSphereShape = new AWPSphereShape( 50 );
			_gloopMesh = new Mesh( new SphereGeometry( 50 ), _gloopMaterial );
			_gloopMesh.mouseEnabled = true;
			_gloopMesh.mouseHitMethod = MouseHitMethod.BOUNDS_ONLY;
			_gloopMesh.addEventListener( MouseEvent3D.MOUSE_DOWN, gloopMouseDownHandler );
			_gloopMesh.addEventListener( MouseEvent3D.MOUSE_UP, gloopMouseUpHandler );
			_gloopBody = new AWPRigidBody( ballShape, _gloopMesh, 1 );
			_gloopBody.friction = 1;
			_gloopBody.linearDamping = 1; // used to lock in mid air when waiting for shot
			_gloopBody.angularDamping = 0.95;
			_gloopBody.restitution = 1;
			_view.scene.addChild( _gloopMesh );
			_physicsWorld.addRigidBody( _gloopBody );
			// director
			_directorMesh = new Mesh( new ConeGeometry( 5, 300 ), new ColorMaterial( 0xFF0000 ) );
			_directorMesh.visible = false;
			_view.scene.addChild( _directorMesh );
		}

		// -----------------------
		// level
		// -----------------------

		private var _roomDimensions:Vector3D = new Vector3D( 10000, 10000, 10000 );
		private function initLevel():void {
			var wallThickness:Number = 250;
			var groundY:Number = -250;
			// ground ---------------
			var groundMesh:Mesh = new Mesh( new PlaneGeometry( _roomDimensions.x, _roomDimensions.z ), _floorMaterial );
			var groundShape:AWPStaticPlaneShape = new AWPStaticPlaneShape( new Vector3D( 0, 1, 0 ) );
			var groundBody:AWPRigidBody = new AWPRigidBody( groundShape, groundMesh, 0 );
			_view.scene.addChild( groundMesh );
			_physicsWorld.addRigidBody( groundBody );
			groundBody.position = new Vector3D( 0, groundY, 0 );
			// back wall
			var geometry:CubeGeometry = new CubeGeometry( _roomDimensions.x, _roomDimensions.y, wallThickness );
			var shape:AWPBoxShape = new AWPBoxShape( geometry.width, geometry.height, geometry.depth );
			var position:Vector3D = new Vector3D( 0, groundBody.y + geometry.height / 2, _roomDimensions.z / 2 );
			createBox( geometry, shape, position, _wallMaterial );
			// right wall
			geometry = new CubeGeometry( wallThickness, _roomDimensions.y, _roomDimensions.z );
			shape = new AWPBoxShape( geometry.width, geometry.height, geometry.depth );
			position = new Vector3D( _roomDimensions.x / 2, groundBody.y + geometry.height / 2, 0 );
			createBox( geometry, shape, position, _wallMaterial );
			// left wall
			geometry = new CubeGeometry( wallThickness, _roomDimensions.y, _roomDimensions.z );
			shape = new AWPBoxShape( geometry.width, geometry.height, geometry.depth );
			position = new Vector3D( -_roomDimensions.x / 2, groundBody.y + geometry.height / 2, 0 );
			createBox( geometry, shape, position, _wallMaterial );
			// front wall
			geometry = new CubeGeometry( _roomDimensions.x, _roomDimensions.y, wallThickness );
			shape = new AWPBoxShape( geometry.width, geometry.height, geometry.depth );
			position = new Vector3D( 0, groundBody.y + geometry.height / 2, -_roomDimensions.z / 2 );
			createBox( geometry, shape, position, _wallMaterial );
			// obstacles
			createBoxGrid( 4, 6, 1000, 1500, 150, new Vector3D( -500, groundY, 3000 ) );
			createBoxGrid( 1, 6, 200, 1000, 150, new Vector3D( -2000, groundY, 0 ) );
			createBoxGrid( 1, 6, 200, 1000, 150, new Vector3D( 2000, groundY, 500 ) );
		}

		private function createBox( geometry:CubeGeometry, shape:AWPBoxShape, position:Vector3D, material:MaterialBase, mass:Number = 0, damping:Number = 1 ):AWPRigidBody {
			var boxMesh:Mesh = new Mesh( geometry, material );
			var boxBody:AWPRigidBody = new AWPRigidBody( shape, boxMesh, mass );
			boxBody.position = position;
			boxBody.linearDamping = damping;
			boxBody.friction = 0.5;
			boxBody.restitution = 0.5;
			_view.scene.addChild( boxMesh );
			_physicsWorld.addRigidBody( boxBody );
			return boxBody;
		}

		private function createBoxGrid( n:uint, m:uint, width:Number, height:Number, depth:Number, position:Vector3D, mass:Number = 1 ):void {
			var i:uint, j:uint;
			var cubeWidth:Number = width / n;
			var cubeHeight:Number = height / m;
			var cubeGeometry:CubeGeometry = new CubeGeometry( cubeWidth, cubeHeight, depth );
			var cubeShape:AWPBoxShape = new AWPBoxShape( cubeGeometry.width, cubeGeometry.height, cubeGeometry.depth );
			for( i = 0; i < n; ++i ) {
				for( j = 0; j < m; ++j ) {
					createBox( cubeGeometry, cubeShape,
							new Vector3D( i * cubeWidth, j * cubeHeight + cubeHeight / 2, 0 ).add( position ),
							_obstacleMaterial, mass, 0.1 );
					}
			}
		}

		// -----------------------
		// fling mechanics
		// -----------------------

		private function updateGloopDrag():void {
			// cast a ray from mouse screen position into 3d world
			var rayDirection:Vector3D = _view.unproject( stage.mouseX, stage.mouseY );
			rayDirection.negate();
			var rayPosition:Vector3D = _view.camera.position.clone();
			// find ray-plane intersection
			var planeNormal:Vector3D = _directorMesh.forwardVector.clone();
			//			planeNormal = _view.camera.sceneTransform.deltaTransformVector( planeNormal );
			// planeD assumed to be zero, as it is = nx * px + ny * py + nz * pz, plane passes through 0, 0, 0
			var planeNormalDotRayPosition:Number = planeNormal.dotProduct( rayPosition );
			var planeNormalDotRayDirection:Number = planeNormal.dotProduct( rayDirection );
			var t:Number = -planeNormalDotRayPosition / planeNormalDotRayDirection;
			var intersection:Vector3D = new Vector3D();
			intersection.x = rayPosition.x + t * rayDirection.x;
			intersection.y = rayPosition.y + t * rayDirection.y;
			intersection.z = rayPosition.z + t * rayDirection.z;
			// place ball at intersection point ( lock side movement )
			var dir:Vector3D = _directorMesh.upVector.clone();
			var proj:Number = intersection.dotProduct( dir );
			dir.scaleBy( proj );
			_gloopBody.position = dir;
			// scale director
			var dis:Number = _gloopBody.position.length;
			_directorMesh.scaleY = 1 + dis / 100;
		}

		private function gloopMouseDownHandler( event:MouseEvent3D ):void {
			_draggingGloop = true;
		}

		private function gloopMouseUpHandler( event:MouseEvent3D ):void {
			releaseGloop();
		}

		private function stageMouseDownHandler( event:MouseEvent ):void {
			if( !_gloopIsFlying ) {
				_directorMesh.visible = true;
			}
		}

		private function stageMouseUpHandler( event:MouseEvent ):void {
			if( _draggingGloop && !_gloopIsFlying ) {
				releaseGloop();
			}
		}

		private function releaseGloop():void {
			_draggingGloop = false;
			_gloopIsFlying = true;
			_directorMesh.visible = false;
			shootGloop();
		}

		// -----------------------
		// gloop mechanics
		// -----------------------

		private function resetGloop( reposition:Boolean = true ):void {
			_gloopBody.linearVelocity = new Vector3D();
			_gloopBody.angularVelocity = new Vector3D();
			if( reposition ) {
				_gloopBody.position = new Vector3D();
			}
			_gloopBody.linearDamping = 1;
			_gloopIsFlying = false;
			_directorMesh.scaleY = 1;
		}

		private function shootGloop():void {
			_gloopBody.linearDamping = 0.15; // unlock
			var offset:Vector3D = _gloopBody.position.clone();
			offset.negate();
			offset.scaleBy( 10 );
			_gloopBody.applyCentralForce( offset );
		}

		// -----------------------
		// enterframe
		// -----------------------

		private var _dummy:Object3D = new Object3D();
		private function enterframeHandler( event:Event ):void {

			_physicsWorld.step( PHYSICS_TIME_STEP );
			_physicsDebugDraw.debugDrawWorld();

			if( !_gloopIsFlying && _draggingGloop ) {
				updateGloopDrag();
			}

			if( !_gloopIsFlying && !_draggingGloop ) {
				// update camera
				_cameraController.update();
				// update director
				_directorMesh.position = new Vector3D();
				_directorMesh.rotationY = _view.camera.rotationY;
				var forward:Vector3D = _directorMesh.upVector.clone();
				forward.scaleBy( 250 );
				_directorMesh.position = _directorMesh.position.add( forward );
				_directorMesh.rotationX = _view.camera.rotationX + 0.7 * 90;
			}

			if( _gloopIsFlying ) {
				// check when to reset
				var speed:Number = _gloopBody.linearVelocity.length;
				if( _gloopBody.position.length > 1.5 * _roomDimensions.z || speed <= 0.05 ) {
					resetGloop();
				}
				// follow gloop
				var delta:Vector3D = _view.camera.position.subtract( _gloopBody.position );
				delta.normalize();
				delta.scaleBy( 500 );
				var target:Vector3D = _gloopBody.position.add( delta );
				delta = target.subtract( _view.camera.position );
				delta.scaleBy( 0.03 );
				_view.camera.position = _view.camera.position.add( delta );
				_view.camera.y += 20;
				_dummy.position = _view.camera.position;
				_dummy.lookAt( _gloopMesh.position );
				_view.camera.rotationX += ( _dummy.rotationX - _view.camera.rotationX ) * 0.1;
				_view.camera.rotationY += ( _dummy.rotationY - _view.camera.rotationY ) * 0.1;
				_view.camera.rotationZ += ( _dummy.rotationZ - _view.camera.rotationZ ) * 0.1;
			}

			_cameraLight.transform = _view.camera.transform.clone();

			_view.render();
		}
	}
}
