package
{

	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapTexture;

	import flash.display.BitmapData;

	import flash.events.KeyboardEvent;

	import flash.geom.Vector3D;
	import flash.ui.Keyboard;

	public class SplatterTest1 extends TestBase3D
	{
		[Embed(source="../../assets/images/blood.png")]
		private var BloodImage:Class;

		[Embed(source="../../assets/images/blood1.png")]
		private var Blood1Image:Class;

		[Embed(source="../../assets/images/blood2.png")]
		private var Blood2Image:Class;

		private var _splatter:DecalSplatter;
		private var _room:Room;

		public function SplatterTest1() {
			super();
		}

		override protected function postInit():void {
			// create room
			var roomMaterial:ColorMaterial = new ColorMaterial( 0xCCCCCC );
			roomMaterial.ambient = 0.3;
			roomMaterial.lightPicker = _sceneLights;
			_room = new Room( new Vector3D( 10000, 10000, 10000 ), roomMaterial );
			_room.y = 4000;
			_view.scene.addChild( _room );
			// init splatter thing
			_splatter = new DecalSplatter();
			_splatter.numRays = 50;
			_splatter.aperture = 2.5;
			var decal0:Mesh = createDecal( 10, new BitmapTexture( new BloodImage().bitmapData ) );
			var decal1:Mesh = createDecal( 10, new BitmapTexture( new Blood1Image().bitmapData ) );
			var decal2:Mesh = createDecal( 1, new BitmapTexture( new Blood2Image().bitmapData ) );
			_splatter.decals = Vector.<Mesh>( [ decal0, decal1, decal2 ] );
			// listen for key presses
			stage.addEventListener( KeyboardEvent.KEY_DOWN, stageKeyDownHandler );
		}

		private function createDecal( size:Number, texture:BitmapTexture ):Mesh {

			var material:TextureMaterial = new TextureMaterial( texture );
			material.alphaBlending = true;
			material.lightPicker = _sceneLights;
			var decal:Mesh = new Mesh( new PlaneGeometry(), material );
			decal.scale( size );
			decal.rotationX += 90;
			decal.bakeTransformations();

			return decal;
		}

		private function stageKeyDownHandler( event:KeyboardEvent ):void {
			switch( event.keyCode ) {
				case Keyboard.SPACE:
				{
					splatterFromMouse();
					break;
				}
			}
		}

		private function splatterFromMouse():void {
			// shoot splatter from mouse
			_splatter.sourcePosition = _view.camera.position;
			_splatter.splattDirection = _view.unproject( _view.mouseX, _view.mouseY );
			_splatter.evaluate( _room.meshes );
		}
	}
}
