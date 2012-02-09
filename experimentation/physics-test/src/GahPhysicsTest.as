package
{

	import agt.controllers.camera.FreeFlyCameraController;
	import agt.input.contexts.DefaultMouseKeyboardInputContext;

	import away3d.containers.View3D;
	import away3d.core.base.SubGeometry;
	import away3d.core.math.Matrix3DUtils;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.MouseEvent3D;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.loaders.parsers.OBJParser;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;

	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.collision.shapes.AWPBvhTriangleMeshShape;

	import awayphysics.collision.shapes.AWPSphereShape;
	import awayphysics.collision.shapes.AWPStaticPlaneShape;
	import awayphysics.debug.AWPDebugDraw;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	import awayphysics.dynamics.AWPRigidBody;
	import awayphysics.events.AWPEvent;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.geom.Vector3D;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;

	public class GahPhysicsTest extends Sprite
	{
		[Embed(source="../assets/torus2.obj", mimeType="application/octet-stream")]
		private var TorusAsset:Class;

		private var _view:View3D;
		private var _wallMaterial:ColorMaterial;
		private var _ballMaterial:ColorMaterial;
		private var _targetMaterial:ColorMaterial;
		private var _obstacleMaterial:ColorMaterial;
		private var _transparentWallMaterial:ColorMaterial;
		private var _cameraLight:PointLight;
		private var _physicsWorld:AWPDynamicsWorld;
		private var _physicsDebugDraw:AWPDebugDraw;
		private var _physicsTimeStep:Number = 1.0 / 60;
		private var _ballMesh:Sphere;
		private var _ballBody:AWPRigidBody;
//		private var _cameraController:FreeFlyCameraController;
		private var _draggingBall:Boolean;
		private var _ballIsFlying:Boolean;
		private var _targetBody:AWPRigidBody;
		private var _obstacles:Vector.<AWPRigidBody>;
		private var _torusMesh:Mesh;
		private var _groundY:Number = -250;
		private var _roomDimensions:Vector3D = new Vector3D( 3000, 2000, 7000 );
		private var _wallThickness:Number = 200;

		public function GahPhysicsTest() {
			initStage();
			loadTorus();
		}

		private function loadTorus():void {
			var objParser:OBJParser = new OBJParser( 70 );
			objParser.addEventListener( AssetEvent.ASSET_COMPLETE, torusLoadedHandler )
			objParser.parseAsync( new TorusAsset() );
		}

		private function torusLoadedHandler( event:AssetEvent ):void {
			_torusMesh = event.asset as Mesh;
			init();
		}

		private function init():void {
			initRenderCore();
			initPhysicsCore();
			initLevel();
			initGloop();
			addEventListener( Event.ENTER_FRAME, enterframeHandler );
		}

		private function initStage():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
		}

		private function initRenderCore():void {
			// view
			_view = new View3D();
			_view.antiAlias = 4;
			addChild( _view );
			// camera
			_view.camera.lens.far = 1000000;
			_view.camera.position = new Vector3D( 0, 2000, -1900 );
			_view.camera.lookAt( new Vector3D( 0, 500, 1000 ) );
//			_cameraController = new FreeFlyCameraController( _view.camera );
//			_cameraController.inputContext = new DefaultMouseKeyboardInputContext( this, stage );
			// lights
			_cameraLight = new PointLight();
			_cameraLight.specular = 0.2;
			_cameraLight.transform = _view.camera.transform.clone();
			_view.scene.addChild( _cameraLight );
			var lights:Array = [ _cameraLight ];
			// materials
			_wallMaterial = new ColorMaterial( 0x666666 );
			_wallMaterial.lights = lights;
			_ballMaterial = new ColorMaterial( 0xFFFFFF );
			_ballMaterial.lights = lights;
			_targetMaterial = new ColorMaterial( 0x0000FF );
			_targetMaterial.lights = lights;
			_transparentWallMaterial = new ColorMaterial( 0x666666, 0.5 );
			_transparentWallMaterial.lights = lights;
			_obstacleMaterial = new ColorMaterial( 0xFF0000 );
			_obstacleMaterial.lights = lights;
			// trident
//			var trident:Trident = new Trident();
//			_view.scene.addChild( trident );
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

		private function initLevel():void {
			// ground ---------------
			var groundMesh:Plane = new Plane( _wallMaterial, 50000, 50000 );
			var groundShape:AWPStaticPlaneShape = new AWPStaticPlaneShape( new Vector3D( 0, 1, 0 ) );
			var groundBody:AWPRigidBody = new AWPRigidBody( groundShape, groundMesh, 0 );
			_view.scene.addChild( groundMesh );
			_physicsWorld.addRigidBody( groundBody );
			groundBody.position = new Vector3D( 0, _groundY, 0 );
			// room ---------------

			// back wall
			var dimensions:Vector3D = new Vector3D( _roomDimensions.x, _roomDimensions.y, _wallThickness );
			var position:Vector3D = new Vector3D( 0, groundBody.y + dimensions.y / 2, _roomDimensions.z );
			createBox( dimensions, position, _wallMaterial );
			// right wall
			dimensions = new Vector3D( _wallThickness, _roomDimensions.y, _roomDimensions.z );
			position = new Vector3D( _roomDimensions.x / 2, groundBody.y + dimensions.y / 2, _roomDimensions.z / 2 );
			createBox( dimensions, position, _wallMaterial );
			// left wall
			position = new Vector3D( -_roomDimensions.x / 2, groundBody.y + dimensions.y / 2, _roomDimensions.z / 2 );
			createBox( dimensions, position, _wallMaterial );
			// ceiling
//			dimensions = new Vector3D( _roomDimensions.x, _wallThickness, _roomDimensions.z );
//			position = new Vector3D( 0, groundBody.y + _roomDimensions.y, _roomDimensions.z / 2 );
//			createBox( dimensions, position, _wallMaterial );
			// fixed obstacles ---------------
			dimensions = new Vector3D( _roomDimensions.x / 4, _roomDimensions.y, _wallThickness );
			position = new Vector3D( 100, groundBody.y + _roomDimensions.y / 2, 0.25 * _roomDimensions.z );
			var box:AWPRigidBody = createBox( dimensions, position, _transparentWallMaterial );
			box.rotation = new Vector3D( 0, 30, 0 );
			// free obstacles --------------
			resetObstacles();
			// target ---------------
			dimensions = new Vector3D( 800, 800, 800 );
			position = new Vector3D( _roomDimensions.x / 4, groundBody.y + _roomDimensions.y / 2, _roomDimensions.z - 100 );
			_targetBody = createBox( dimensions, position, _targetMaterial );
		}

		private function resetObstacles():void {
			var i:uint, len:uint;
			// remove previous obstacles
			if( _obstacles ) {
				len = _obstacles.length;
				for( i = 0; i < len; ++i ) {
					_physicsWorld.removeRigidBody( _obstacles[ i ] );
					_view.scene.removeChild( _obstacles[ i ].skin );
				}
			}
			_obstacles = new Vector.<AWPRigidBody>();
			// ring obstacle
			_obstacles.push( createRing(
					new Vector3D( -900, 700, 2400 ),
					_obstacleMaterial, 0 ) );
			// big box obstacle
			createBoxGrid( 3, 4, 800, 0.85 * _roomDimensions.y, 100, new Vector3D( -1200, _groundY, 0.7 * _roomDimensions.z ), 5 );
			// box grid
			createBoxGrid( 4, 6, 450, 0.75 * _roomDimensions.y, 2500, new Vector3D( 750, _groundY, 0.35 * _roomDimensions.z ), 0.5 );
		}

		private function createBoxGrid( n:uint, m:uint, width:Number, height:Number, depth:Number, position:Vector3D, mass:Number = 1 ):void {
			var i:uint, j:uint;
			var cubeWidth:Number = width / n;
			var cubeHeight:Number = height / m;
			for( i = 0; i < n; ++i ) {
				for( j = 0; j < m; ++j ) {
					_obstacles.push( createBox(
							new Vector3D( cubeWidth, cubeHeight, depth ),
							new Vector3D( i * cubeWidth, j * cubeHeight + cubeHeight / 2, 0 ).add( position ),
							_obstacleMaterial, mass, 0.1 ) );
				}
			}
		}

		private function createBox( dimensions:Vector3D, position:Vector3D, material:ColorMaterial, mass:Number = 0, damping:Number = 1 ):AWPRigidBody {
			var boxMesh:Cube = new Cube( material, dimensions.x, dimensions.y, dimensions.z );
			var boxShape:AWPBoxShape = new AWPBoxShape( dimensions.x, dimensions.y, dimensions.z );
			var boxBody:AWPRigidBody = new AWPRigidBody( boxShape, boxMesh, mass );
			boxBody.position = position;
			boxBody.linearDamping = damping;
			boxBody.friction = 0.5;
			boxBody.restitution = 0.33;
			_view.scene.addChild( boxMesh );
			_physicsWorld.addRigidBody( boxBody );
			return boxBody;
		}

		private function createRing( position:Vector3D, material:ColorMaterial, mass:Number = 0 ):AWPRigidBody {
			var ringMesh:Mesh = _torusMesh.clone() as Mesh;
			ringMesh.material = material;
			ringMesh.geometry.subGeometries[ 0 ] = _torusMesh.geometry.subGeometries[ 0 ].clone();
			var meshShape:AWPBvhTriangleMeshShape = new AWPBvhTriangleMeshShape( ringMesh.geometry );
			var ringBody:AWPRigidBody = new AWPRigidBody( meshShape, ringMesh, mass );
			ringBody.rotation = new Vector3D( 90, 0, 0 );
			ringBody.position = position;
			ringBody.linearDamping = 1;
			ringBody.friction = 1;
			ringBody.restitution = 1;
			_view.scene.addChild( ringMesh );
			_physicsWorld.addRigidBody( ringBody );
			return ringBody;
		}

		private function initGloop():void {
			// create ball
			var ballShape:AWPSphereShape = new AWPSphereShape( 50 );
			_ballMesh = new Sphere( _ballMaterial, 50 );
			_ballMesh.mouseEnabled = true;
			_ballMesh.mouseDetails = true;
			_ballMesh.addEventListener( MouseEvent3D.MOUSE_DOWN, ballMouseDownHandler );
			_ballMesh.addEventListener( MouseEvent3D.MOUSE_UP, ballMouseUpHandler );
			_ballBody = new AWPRigidBody( ballShape, _ballMesh, 1 );
			_ballBody.friction = 1;
			_ballBody.linearDamping = 1; // lock in mid air
			_ballBody.angularDamping = 0.95;
			_ballBody.restitution = 1;
			_ballBody.addEventListener( AWPEvent.COLLISION_ADDED, ballCollisionAddedHandler );
			_view.scene.addChild( _ballMesh );
			_physicsWorld.addRigidBody( _ballBody );
		}

		private function ballCollisionAddedHandler( event:AWPEvent ):void {
			// hits target?
			var hit:AWPRigidBody = event.collisionObject as AWPRigidBody;
			if( hit ) {
				if( hit == _targetBody ) {
					var mesh:Mesh = _ballBody.skin as Mesh;
					mesh.material = _obstacleMaterial;
					resetBall( false );
				}
				var i:uint;
				var len:uint = _obstacles.length;
				for( i = 0; i < len; ++i ) {
					var obstacle:AWPRigidBody = _obstacles[ i ];
					if( hit == obstacle ) {
						obstacle.linearDamping = 0.05;
					}
				}
			}
		}

		private function enterframeHandler( event:Event ):void {
			_physicsWorld.step( _physicsTimeStep );
			_physicsDebugDraw.debugDrawWorld();
			if( !_draggingBall ) {
//				_cameraController.update();
			}
			else {
				updateBallDrag();
			}
			if( _ballIsFlying ) {
				var speed:Number = _ballBody.linearVelocity.length;
				if( _ballBody.position.length > 1.5 * _roomDimensions.z || speed <= 0.5 ) {
					resetBall();
					resetObstacles();
				}
			}
			_cameraLight.transform = _view.camera.transform.clone();
			_view.render();
		}

		private function resetBall( reposition:Boolean = true ):void {
			_ballBody.linearVelocity = new Vector3D();
			_ballBody.angularVelocity = new Vector3D();
			if( reposition ) {
				_ballBody.position = new Vector3D();
			}
			_ballBody.linearDamping = 1;
			_ballIsFlying = false;
		}

		private function shootBall():void {
			_ballBody.linearDamping = 0.15; // unlock
			var offset:Vector3D = _ballBody.position.clone();
			offset.negate();
			offset.scaleBy( 15 );
			_ballBody.applyCentralForce( offset );
		}

		private function updateBallDrag():void {
			// cast a ray from mouse screen position into 3d world
			var rayDirection:Vector3D = _view.unproject( stage.mouseX, stage.mouseY );
			rayDirection.negate();
			var rayPosition:Vector3D = _view.camera.position.clone();
			// find ray-plane intersection
			var planeNormal:Vector3D = new Vector3D( 0, 1, -0.35 );
//			planeNormal = _view.camera.sceneTransform.deltaTransformVector( planeNormal );
			// planeD assumed to be zero, as it is = nx * px + ny * py + nz * pz, plane passes through 0, 0, 0
			var planeNormalDotRayPosition:Number = planeNormal.dotProduct( rayPosition );
			var planeNormalDotRayDirection:Number = planeNormal.dotProduct( rayDirection );
			var t:Number = -planeNormalDotRayPosition / planeNormalDotRayDirection;
			var intersection:Vector3D = new Vector3D();
			intersection.x = rayPosition.x + t * rayDirection.x;
			intersection.y = rayPosition.y + t * rayDirection.y;
			intersection.z = rayPosition.z + t * rayDirection.z;
			// place ball at intersection point
			_ballBody.position = intersection;
		}

		private function ballMouseDownHandler( event:MouseEvent3D ):void {
			_draggingBall = true;
		}

		private function ballMouseUpHandler( event:MouseEvent3D ):void {
			_draggingBall = false;
			_ballIsFlying = true;
			shootBall();
		}
	}
}
