package com.away3d.gloop.gameobjects
{

	import Box2DAS.Common.V2;

	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;

	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.utils.EmbeddedResources;

	import flash.display.Bitmap;

	public class Box extends DefaultGameObject
	{
		private var _initialX:Number;
		private var _initialY:Number;

		public function Box( worldX:Number = 0, worldY:Number = 0 ) {

			super();

			_physics = new BoxPhysicsComponent( this );
			_physics.x = _initialX = worldX/* + 700*/;
			_physics.y = _initialY = worldY/* + 550*/;
			_physics.applyGravity = true;
			_physics.density = Settings.BOX_DENSITY;

			initVisual();
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
			geom.scale( 0.33 );

			_meshComponent.mesh = new Mesh( geom, mat );

		}

		override public function reset():void {
			super.reset();
			_physics.b2body.SetLinearVelocity( new V2() );
			_physics.b2body.SetAngularVelocity( 0 );
			_physics.b2body.SetAwake( false );
			_physics.rotation = 0;
			_physics.moveTo( _initialX, _initialY, false );
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
		setCollisionGroup( GLOOP );
	}

}
