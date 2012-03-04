package com.away3d.gloop.gameobjects
{

	import Box2DAS.Dynamics.ContactEvent;

	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.CylinderGeometry;
	import Box2DAS.Common.V2;
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.Settings;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	

	public class Fan extends DefaultGameObject implements IButtonControllable
	{
		private var _btnGroup:uint;
		private var _blades:Mesh;
		private var _isOn:Boolean;
		private var _activeFanStrength:Object = { t:0 };
		private var _gloop:Gloop;

		public function Fan( worldX:Number = 0, worldY:Number = 0, rotation:Number = 0, btnGroup:uint = 0 ) {
			super();

			_btnGroup = btnGroup;

			_physics = new FanPhysicsComponent( this );
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.enableReportBeginContact();
			_physics.enableReportEndContact();
			_physics.rotation = rotation;

			_physics.fixedRotation = true;
			_physics.applyGravity = false;
			_physics.linearDamping = 100;

			_physics.setStatic();

			var fanMaterial:ColorMaterial = new ColorMaterial( 0xCCCCCC );

			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh(Geometry(AssetLibrary.getAsset('FanAxis_geom')), fanMaterial );
			_meshComponent.mesh.rotationZ = rotation;
			
			var guard : Mesh;
			
			guard = new Mesh(Geometry(AssetLibrary.getAsset('FanGuard_geom')), fanMaterial);
			_meshComponent.mesh.addChild(guard);

			_blades = new Mesh(Geometry(AssetLibrary.getAsset('FanBlades_geom')), fanMaterial);
			_meshComponent.mesh.addChild( _blades );
		}

		override public function update( dt:Number ):void {
			super.update( dt );
			if( _isOn ) {
				_blades.rotationY += 25 * _activeFanStrength.t; // TODO: implement on/off inertia to physics as well?
			}
			
			if(_isOn && _gloop){
				var distanceToFan:Number = _gloop.physics.b2body.GetWorldCenter().subtract( _physics.b2body.GetWorldCenter() ).length();
				var impulse:V2 = _physics.b2body.GetWorldVector( new V2( 0, -Settings.FAN_POWER * ( 1 / distanceToFan + 1 ) * dt ) );
				_gloop.physics.b2body.ApplyImpulse( impulse, _gloop.physics.b2body.GetWorldCenter() ); // apply up impulse
			}
		}
		
		override public function onCollidingWithGloopStart( gloop:Gloop, event:ContactEvent = null ):void {
			super.onCollidingWithGloopStart(gloop);
			_gloop = gloop;
		}
		
		override public function onCollidingWithGloopEnd( gloop:Gloop, event:ContactEvent = null ):void {
			super.onCollidingWithGloopEnd(gloop);
			_gloop = null;
		}

		public function toggleOn():void {
			if( _isOn ) return;
			_isOn = true;
			var d : Number = Math.random() * 0.2;
			TweenLite.to( _activeFanStrength, Settings.FAN_ON_OFF_TIME, { delay: d, t:1, ease:Cubic.easeIn } );
		}

		public function toggleOff():void {
			if( !_isOn ) return;
			TweenLite.to( _activeFanStrength, Settings.FAN_ON_OFF_TIME, { t:0, onComplete:onToggleOffComplete } );
		}

		private function onToggleOffComplete():void {
			_isOn = false;
		}
		
		public function get buttonGroup():uint {
			return _btnGroup;
		}
	}
}

import Box2DAS.Common.V2;
import Box2DAS.Dynamics.b2Fixture;
import com.away3d.gloop.gameobjects.components.PhysicsComponent;
import com.away3d.gloop.gameobjects.DefaultGameObject;
import com.away3d.gloop.Settings;
import wck.BodyShape;

class FanPhysicsComponent extends PhysicsComponent
{
	public function FanPhysicsComponent( gameObject:DefaultGameObject ) {
		super( gameObject );

		graphics.beginFill( gameObject.debugColor1 );
		graphics.drawRect( -Settings.FAN_BODY_WIDTH / 2, -Settings.FAN_BODY_HEIGHT / 2, Settings.FAN_BODY_WIDTH, Settings.FAN_BODY_HEIGHT );

		graphics.beginFill( gameObject.debugColor2 );
		graphics.drawRect( -Settings.FAN_AREA_WIDTH / 2, -Settings.FAN_BODY_HEIGHT - Settings.FAN_AREA_HEIGHT, Settings.FAN_AREA_WIDTH, Settings.FAN_AREA_HEIGHT );
	}

	public override function shapes():void {
		// defines fan body fixture
		box( Settings.FAN_BODY_WIDTH, Settings.FAN_BODY_HEIGHT );
		// defines fan area fixture
		box( Settings.FAN_AREA_WIDTH, Settings.FAN_AREA_HEIGHT, new V2( 0, -Settings.FAN_BODY_HEIGHT - Settings.FAN_AREA_HEIGHT + Settings.FAN_BODY_HEIGHT / 2 ) );
	}

	override public function create():void {
		super.create();
		setCollisionGroup( GLOOP_SENSOR, b2fixtures[0] );
		setCollisionGroup( GLOOP_SENSOR, b2fixtures[1] );
		b2fixtures[1].SetSensor( true );
	}
}