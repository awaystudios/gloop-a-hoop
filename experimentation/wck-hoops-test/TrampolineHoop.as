package
{

	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;

	import shapes.Box;

	import wck.BodyShape;

	/*
	* A hoop that makes gloop bounce normally.
	* NOTE: A restitution value greater than 0.5 can actually impulse the gloop artificially ( velocity gain ).
	* The final velocity is affected by the gloop's incident velocity.
	* */
	public class TrampolineHoop extends Box
	{
		public override function create():void {
			type = "Static";
			this.restitution = 1.25;
			reportPreSolve = true;
			listenWhileVisible( this, ContactEvent.PRE_SOLVE, handlePreSolveContact );
			super.create();
		}

		private function handlePreSolveContact( e:ContactEvent ):void {
			var body:BodyShape = e.other.m_userData;
			if( body ) {
				var collisionValid:Boolean = true;
				if( e.normal ) {
					var localSpaceNormal:V2 = b2body.GetLocalVector( e.normal );
					trace( "collision local normal: " + localSpaceNormal  );
					if( Math.abs( localSpaceNormal.x ) > 0.01 ) collisionValid = false; // no hits from the sides
					if( localSpaceNormal.y > 0 ) collisionValid = false; // no hits from the back
					if( collisionValid ) {
						trace( "COLLISION VALID" );
						restitution = 1.25;
					}
					else {
						restitution = 0;
					}
				}
			}
		}
	}
}
