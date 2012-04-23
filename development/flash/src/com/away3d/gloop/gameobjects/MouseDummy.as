package com.away3d.gloop.gameobjects
{

	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Fixture;

	import com.away3d.gloop.gameobjects.components.PhysicsComponent;

	public class MouseDummy extends DefaultGameObject
	{
		private var _isColliding:Boolean;
		private var _numColliders:int = 0;

		public function MouseDummy() {
			super();
			_physics = new MouseDummyPhysicsComponent( this );
		}

		public function resetColliders():void {
			_numColliders = 0;
		}

		override public function onCollidingWithSomethingStart( event:ContactEvent ):void {
			if( validateCollider( event.other ) ) {
				_numColliders++;
				_isColliding = _numColliders > 1;
			}
		}

		override public function onCollidingWithSomethingEnd( event:ContactEvent ):void {
			if( validateCollider( event.other ) ) {
				_numColliders--;
				_isColliding = _numColliders > 1;
			}
		}

		public function get isColliding():Boolean {
			return _isColliding;
		}

		private function validateCollider( fixture:b2Fixture ):Boolean {
			var otherPhysics:PhysicsComponent = fixture.m_userData as PhysicsComponent;
			if( otherPhysics.gameObject is Star ) return false;
			else if( otherPhysics.gameObject is Fan ) return false;
			else if( otherPhysics.gameObject is GoalWall ) return false;
			return true;
		}
	}
}

import com.away3d.gloop.gameobjects.DefaultGameObject;
import com.away3d.gloop.gameobjects.components.PhysicsComponent;

class MouseDummyPhysicsComponent extends PhysicsComponent {

	public function MouseDummyPhysicsComponent( gameObject:DefaultGameObject ) {
		super( gameObject );

		graphics.beginFill( 0x00FF00, 0.5 );
		graphics.drawCircle( 0, 0, 100 );

		enableReportBeginContact();
		enableReportEndContact();
	}

	public override function shapes():void {
		circle( 100 );
	}

	override public function create():void {
		super.create();
		b2body.SetSleepingAllowed( false );
		b2body.SetAwake( true );
		b2fixtures[ 0 ].SetSensor( true );
	}
}
