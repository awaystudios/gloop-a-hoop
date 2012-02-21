package com.away3d.gloop.gameobjects.hoops {
	import Box2DAS.Common.V2;
	import com.away3d.gloop.gameobjects.Gloop;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class RocketHoop extends Hoop {
		
		public function RocketHoop(worldX:Number=0, worldY:Number=0, rotation:Number=0) {
			super(worldX, worldY, rotation);
		}
		
		override public function onCollidingWithGloopStart(gloop:Gloop):void {
			super.onCollidingWithGloopStart(gloop);
			
			gloop.physics.b2body.SetLinearVelocity( new V2( 0, 0 ) ); // kill incident velocity
			var impulse:V2 = _physics.b2body.GetWorldVector( new V2( 0, -15 ) );
			gloop.physics.b2body.ApplyImpulse( impulse, _physics.b2body.GetWorldCenter() ); // apply up impulse
		}
		
	}

}