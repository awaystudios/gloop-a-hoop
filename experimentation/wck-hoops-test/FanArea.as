package
{

	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;

	import flash.events.Event;

	import shapes.Box;

	import wck.BodyShape;

	public class FanArea extends Box
	{
		public var fanCenter:V2;

		private var _body:BodyShape; // TODO: what if more than 1 body collides with area?

		public var fanStrength:Number = 1;

		public override function create():void {
			type = "Static";
			isSensor = true;
			reportBeginContact = true;
			reportEndContact = true;
			mouseEnabled = false;
			listenWhileVisible( this, ContactEvent.BEGIN_CONTACT, handleBeginContact );
			listenWhileVisible( this, ContactEvent.END_CONTACT, handleEndContact );
			super.create();
		}

		public function handleBeginContact( e:ContactEvent ):void {
			var body:BodyShape = e.other.m_userData;
			if( body ) {
				_body = body;
				if( !hasEventListener( Event.ENTER_FRAME ) ) {
					addEventListener( Event.ENTER_FRAME, enterframeHandler );
				}
			}
		}

		public function handleEndContact( e:ContactEvent ):void {
			var body:BodyShape = e.other.m_userData;
			if( body ) {
				_body = null;
				if( hasEventListener( Event.ENTER_FRAME ) ) {
					removeEventListener( Event.ENTER_FRAME, enterframeHandler );
				}
			}
		}

		private function enterframeHandler( event:Event ):void {
			var distanceToFan:Number = _body.b2body.GetWorldCenter().subtract( fanCenter ).length();
			var impulse:V2 = b2body.GetWorldVector( new V2( 0, -fanStrength * ( 1 / distanceToFan + 1 ) ) );
			_body.b2body.ApplyImpulse( impulse, _body.b2body.GetWorldCenter() ); // apply up impulse
		}
	}
}
