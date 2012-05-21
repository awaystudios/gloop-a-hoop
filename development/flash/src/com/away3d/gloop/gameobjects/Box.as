package com.away3d.gloop.gameobjects
{

	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;

	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;

	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.components.GloopVisualComponent;
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.sound.SoundManager;
	import com.away3d.gloop.sound.Sounds;
	import com.away3d.gloop.utils.EmbeddedResources;

	import flash.display.Bitmap;

	public class Box extends DefaultGameObject
	{
		private var _initialX:Number;
		private var _initialY:Number;

		public function Box( worldX:Number = 0, worldY:Number = 0 ) {

			super();

			_physics = new BoxPhysicsComponent( this );
			_physics.x = _initialX = worldX;
			_physics.y = _initialY = worldY;
			_physics.applyGravity = true;
			_physics.restitution = 0.5;
			_physics.friction = 0.8;
			_physics.inertiaScale = 2;
//			_physics.enableReportBeginContact();
			_physics.enableReportPreSolveContact()
			_physics.density = Settings.BOX_DENSITY;

			initVisual();
		}

		override public function onCollidingWithSomethingPreSolve( event:ContactEvent ):void {
			var speed:Number = _physics.b2body.GetLinearVelocity().length();
			if( speed > 1 ) {
				SoundManager.play( Sounds.GAME_BOING, SoundManager.CHANNEL_MAIN );
			}
		}

		private function initVisual():void {

			var geom:Geometry;
			var tex:BitmapTexture;
			var mat:TextureMaterial;

			_meshComponent = new MeshComponent();

			tex = new BitmapTexture( Bitmap( new EmbeddedResources.BoxDiffusePNGAsset ).bitmapData );
			mat = new TextureMaterial( tex ); // TODO: clone materials

//			geom = new CubeGeometry();
			geom = Geometry( AssetLibrary.getAsset( 'BOX' ) ).clone();
			geom.scale( 0.33*0.9 );

			_meshComponent.mesh = new Mesh( geom, mat );

		}

		override public function reset():void {
			super.reset();
			_physics.b2body.SetLinearVelocity( new V2() );
			_physics.b2body.SetAngularVelocity( 0 );
			_physics.b2body.SetTransform( new V2( _initialX / Settings.PHYSICS_SCALE, _initialY / Settings.PHYSICS_SCALE ), 0 );
			_physics.b2body.SetAwake( false );
			_physics.updateBodyMatrix( null );
		}

		override public function setMode( playMode:Boolean ):void {
			super.setMode( playMode );
			BoxPhysicsComponent( _physics ).setMode( playMode );
		}
	}
}

import com.away3d.gloop.Settings;
import com.away3d.gloop.gameobjects.DefaultGameObject;
import com.away3d.gloop.gameobjects.components.PhysicsComponent;

class BoxPhysicsComponent extends PhysicsComponent {

	public function BoxPhysicsComponent( gameObject:DefaultGameObject ) {
		super( gameObject );
		graphics.beginFill( gameObject.debugColor1 );
		graphics.drawRect( -Settings.BOX_SIZE / 2, -Settings.BOX_SIZE / 2, Settings.BOX_SIZE, Settings.BOX_SIZE );
	}

	public override function shapes():void {
		box( Settings.BOX_SIZE, Settings.BOX_SIZE );
	}

	override public function create():void {
		super.create();
	}

	public function setMode( playMode:Boolean ):void {

		if( !b2body ) return;

		if( playMode ) {
			setStatic( false );
			applyGravity = true;
		}
		else {
			setStatic( true );
			applyGravity = false;
//			b2body.SetAwake( false );
		}
	}

}
