package com.away3d.gloop.gameobjects
{

	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.CylinderGeometry;

	import com.away3d.gloop.gameobjects.components.MeshComponent;

	public class Fan extends DefaultGameObject implements IButtonControllable
	{
		private var _btnGroup:uint;
		private var _movableMesh:Mesh;
		private var _isOn:Boolean;

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

			_mesh = new MeshComponent();
			_mesh.mesh = new Mesh( new CylinderGeometry( 50, 50, 5 ), fanMaterial );
			_mesh.mesh.rotationZ = rotation;

			_movableMesh = new Mesh( new CubeGeometry( 5, 5, 100 ), fanMaterial );
			_movableMesh.y = 10;
			_mesh.mesh.addChild( _movableMesh );

			toggleOn(); // TODO: remove. should be off by default
		}

		override public function update( dt:Number ):void {
			super.update( dt );
			if( _isOn ) { // TODO: implement on/off inertia
				_movableMesh.rotationY += 25;
			}
		}

		public function get buttonGroup():uint {
			return _btnGroup;
		}


		public function toggleOn():void {
			_isOn = true;
			FanPhysicsComponent( _physics ).isOn = _isOn;
			trace( this, 'toggle on!' );
		}


		public function toggleOff():void {
			_isOn = false;
			FanPhysicsComponent( _physics ).isOn = _isOn;
			trace( this, 'toggle off!' );
		}
	}
}

import Box2DAS.Common.V2;
import Box2DAS.Dynamics.ContactEvent;
import Box2DAS.Dynamics.b2Fixture;

import com.away3d.gloop.gameobjects.DefaultGameObject;
import com.away3d.gloop.gameobjects.components.PhysicsComponent;

import flash.events.Event;

import wck.BodyShape;

class FanPhysicsComponent extends PhysicsComponent
{
	private const BODY_WIDTH:Number = 60;
	private const BODY_HEIGHT:Number = 5;

	private const AREA_WIDTH:Number = 60;
	private const AREA_HEIGHT:Number = 100;

	private const FAN_STRENGTH:Number = 0.25;

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
		graphics.drawRect( -BODY_WIDTH / 2, -BODY_HEIGHT / 2, BODY_WIDTH, BODY_HEIGHT );

		graphics.beginFill( gameObject.debugColor2 );
		graphics.drawRect( -AREA_WIDTH / 2, -BODY_HEIGHT - AREA_HEIGHT, AREA_WIDTH, AREA_HEIGHT );
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
		var impulse:V2 = b2body.GetWorldVector( new V2( 0, -FAN_STRENGTH * ( 1 / distanceToFan + 1 ) ) );
		_bodyInFanArea.b2body.ApplyImpulse( impulse, _bodyInFanArea.b2body.GetWorldCenter() ); // apply up impulse
	}

	public override function shapes():void {
		// defines fan body fixture
		_bodyFixture = box( BODY_WIDTH, BODY_HEIGHT );
		// defines fan area fixture
		_areaFixture = box( AREA_WIDTH, AREA_HEIGHT, new V2( 0, -BODY_HEIGHT - AREA_HEIGHT + BODY_HEIGHT / 2 ) );
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