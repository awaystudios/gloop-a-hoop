package
{

	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;

	import flash.geom.Transform;

	import shapes.Box;

	import wck.BodyShape;

	/*
	 * As the TrampolineHoop but makes the gloop bounce in a fixed direction and speed.
	 * */
	public class RocketHoop extends Box
	{
		public var impulseSpeed:Number = 15;

		public override function create():void {
			type = "Dynamic";
			linearDamping = 999999;
			angularDamping = 999999;
			density = 9999;
			reportBeginContact = true;
			reportEndContact = true;
			listenWhileVisible( this, ContactEvent.BEGIN_CONTACT, handleContact );
			super.create();
		}

		public function handleContact( e:ContactEvent ):void {
			var body:BodyShape = e.other.m_userData;
			if( body ) {
				body.b2body.SetLinearVelocity( new V2( 0, 0 ) ); // kill incident velocity
				var impulse:V2 = b2body.GetWorldVector( new V2( 0, -impulseSpeed ) );
				body.b2body.ApplyImpulse( impulse, body.b2body.GetWorldCenter() ); // apply up impulse
			}
		}
	}
}
