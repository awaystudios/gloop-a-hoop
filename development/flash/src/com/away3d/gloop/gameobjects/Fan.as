package com.away3d.gloop.gameobjects
{

	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.CylinderGeometry;

	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Strong;

	public class Fan extends DefaultGameObject implements IButtonControllable
	{
		private var _btnGroup:uint;
		private var _movableMesh:Mesh;
		private var _isOn:Boolean;
		private var _activeFanStrength:Object = { t:0 };

		private const FAN_ON_OFF_TIME:Number = 1.5;

		public function Fan( worldX:Number = 0, worldY:Number = 0, rotation:Number = 0, btnGroup:uint = 0 ) {

			super();

			_btnGroup = btnGroup;

			_physics = new FanPhysicsComponent( this );
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.rotation = rotation;

			_physics.fixedRotation = true;
			_physics.applyGravity = false;
			_physics.linearDamping = 100;

			_physics.setStatic();

			var fanMaterial:ColorMaterial = new ColorMaterial( 0xCCCCCC );

			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh( new CylinderGeometry( 50, 50, 5 ), fanMaterial );
			_meshComponent.mesh.rotationZ = rotation;

			_movableMesh = new Mesh( new CubeGeometry( 5, 5, 100 ), fanMaterial );
			_movableMesh.y = 10;
			_meshComponent.mesh.addChild( _movableMesh );
		}

		override public function update( dt:Number ):void {
			super.update( dt );
			if( _isOn ) {
				_movableMesh.rotationY += 25 * _activeFanStrength.t; // TODO: implement on/off inertia to physics as well?
			}
		}

		public function get buttonGroup():uint {
			return _btnGroup;
		}


		public function toggleOn():void {
			if( _isOn ) return;
			_isOn = true;
			TweenLite.to( _activeFanStrength, FAN_ON_OFF_TIME, { t:1, ease:Strong.easeIn } );
			FanPhysicsComponent( _physics ).isOn = _isOn;
		}


		public function toggleOff():void {
			if( !_isOn ) return;
			TweenLite.to( _activeFanStrength, FAN_ON_OFF_TIME, { t:0, onComplete:onToggleOffComplete } );
			FanPhysicsComponent( _physics ).isOn = _isOn;
		}

		private function onToggleOffComplete():void {
			_isOn = false;
			FanPhysicsComponent( _physics ).isOn = _isOn;
		}
	}
}

import Box2DAS.Common.V2;
import Box2DAS.Dynamics.ContactEvent;
import Box2DAS.Dynamics.b2Fixture;
import com.away3d.gloop.Settings;

import com.away3d.gloop.gameobjects.DefaultGameObject;
import com.away3d.gloop.gameobjects.components.PhysicsComponent;

import flash.events.Event;

import wck.BodyShape;

class FanPhysicsComponent extends PhysicsComponent
{
	
	private var _bodyFixture:b2Fixture;
	private var _areaFixture:b2Fixture;
	private var _bodyInFanArea:BodyShape; // TODO: allow more than 1?
	private var _isOn:Boolean;

	public function FanPhysicsComponent( gameObject:DefaultGameObject ) {

		super( gameObject );

		reportBeginContact = true;
		addEventListener( ContactEvent.BEGIN_CONTACT, handleBeginContact );
		addEventListener( ContactEvent.END_CONTACT, handleEndContact );

		graphics.beginFill( gameObject.debugColor1 );
		graphics.drawRect( -Settings.FAN_BODY_WIDTH / 2, -Settings.FAN_BODY_HEIGHT / 2, Settings.FAN_BODY_WIDTH, Settings.FAN_BODY_HEIGHT );

		graphics.beginFill( gameObject.debugColor2 );
		graphics.drawRect( -Settings.FAN_AREA_WIDTH / 2, -Settings.FAN_BODY_HEIGHT - Settings.FAN_AREA_HEIGHT, Settings.FAN_AREA_WIDTH, Settings.FAN_AREA_HEIGHT );
	}

	public function handleBeginContact( e:ContactEvent ):void {
		if( !_isOn ) return;
		if( !e.fixture.IsSensor() ) return; // only listening for interaction with the area fixture
		var body:BodyShape = e.other.m_userData;
		if( body ) {
			_bodyInFanArea = body;
			startImpulse();
		}
	}

	public function handleEndContact( e:ContactEvent ):void {
		if( !_isOn ) return;
		if( !e.fixture.IsSensor() ) return; // only listening for interaction with the area fixture
		var body:BodyShape = e.other.m_userData;
		if( body ) {
			_bodyInFanArea = null;
			stopImpulse();
		}
	}

	private function startImpulse():void {
		if( !hasEventListener( Event.ENTER_FRAME ) ) {
			addEventListener( Event.ENTER_FRAME, enterframeHandler );
		}
	}

	private function stopImpulse():void {
		if( hasEventListener( Event.ENTER_FRAME ) ) {
			removeEventListener( Event.ENTER_FRAME, enterframeHandler );
		}
	}

	private function enterframeHandler( event:Event ):void {
		var distanceToFan:Number = _bodyInFanArea.b2body.GetWorldCenter().subtract( b2body.GetWorldCenter() ).length();
		var impulse:V2 = b2body.GetWorldVector( new V2( 0, -Settings.FAN_POWER * ( 1 / distanceToFan + 1 ) ) );
		_bodyInFanArea.b2body.ApplyImpulse( impulse, _bodyInFanArea.b2body.GetWorldCenter() ); // apply up impulse
	}

	public override function shapes():void {
		// defines fan body fixture
		_bodyFixture = box( Settings.FAN_BODY_WIDTH, Settings.FAN_BODY_HEIGHT );
		// defines fan area fixture
		_areaFixture = box( Settings.FAN_AREA_WIDTH, Settings.FAN_AREA_HEIGHT, new V2( 0, -Settings.FAN_BODY_HEIGHT - Settings.FAN_AREA_HEIGHT + Settings.FAN_BODY_HEIGHT / 2 ) );
		_areaFixture.SetSensor( true );
	}

	override public function create():void {
		super.create();
		setCollisionGroup( GLOOP_SENSOR, _bodyFixture );
		setCollisionGroup( GLOOP_SENSOR, _areaFixture );
	}

	public function set isOn( value:Boolean ):void {
		_isOn = value;
		if( !_isOn ) stopImpulse();
	}
}