package com.away3d.gloop.gameobjects.hoops
{
	import Box2DAS.Common.V2;
	import com.away3d.gloop.gameobjects.Gloop;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class LauncherHoop extends Hoop
	{
		
		private var _gloop:Gloop;
		
		private var _power:Number = 1;
		private var _angle:Number = 0;
		
		public function LauncherHoop(worldX : Number = 0, worldY : Number = 0, rotation : Number = 0)
		{
			super(worldX, worldY, rotation);
		}
		
		override protected function onCollidingWithGloopStart(gloop:Gloop):void {
			super.onCollidingWithGloopStart(gloop);
			_gloop = gloop; // catch the gloop
		}
		
		
		/**
		 * Aims the launcher
		 * @param	power	(0.0-1.0) 	A normalized value of the power used to fire
		 * @param	angle	(0-360)		The angle to fire at in degrees
		 */
		public function aim(power:Number, angle:Number):void {
			_power = power;
			_angle = angle;
		}
		
		public function fire():void {
			if (!_gloop) return; // can't fire if not holding the gloop
			
			var impulse:V2 = _physics.b2body.GetWorldVector( new V2( 0, -_power * 15 ) );
			_gloop.physics.b2body.ApplyImpulse( impulse, _physics.b2body.GetWorldCenter() );
			
			_gloop = null; // release the gloop
		}
		
		override public function update(dt:Number):void {
			super.update(dt);
			if (!_gloop) return;
			_gloop.physics.b2body.SetLinearVelocity( new V2( 0, 0 ) ); // kill incident velocity
			_gloop.physics.b2body.SetTransform( _physics.b2body.GetPosition().clone(), 0); // position gloop on top of launcher
		}
	
	}

}