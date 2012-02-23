package com.away3d.gloop.gameobjects.hoops
{
	import Box2DAS.Common.V2;
	import com.away3d.gloop.gameobjects.events.GameObjectEvent;
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.Settings;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class LauncherHoop extends Hoop
	{
		
		private var _gloop : Gloop;		
		private var _aim : Point;
		private var _fired : Boolean = false;

		public function LauncherHoop(worldX : Number = 0, worldY : Number = 0, rotation : Number = 0)
		{
			super(worldX, worldY, rotation);
			_rotatable = false;
			_aim = new Point;
		}
		
		override public function reset():void {
			super.reset();
			_fired = false;
		}
		
		public override function onCollidingWithGloopStart(gloop : Gloop) : void
		{
			super.onCollidingWithGloopStart(gloop);
			if (_fired) return;	// don't catch the gloop if we've fired once already
			_gloop = gloop; // catch the gloop
			dispatchEvent(new GameObjectEvent(GameObjectEvent.LAUNCHER_CATCH_GLOOP, this));
		}
		
		override public function onDragUpdate(mouseX:Number, mouseY:Number):void {
			if (_fired) return; // if hoop has fired, disable movement
			if (!_gloop) return super.onDragUpdate(mouseX, mouseY); // if there's no gloop, run the regular drag code and bail
			
			var hoopPos:V2 = _physics.b2body.GetPosition();			
			_aim.x = hoopPos.x * Settings.PHYSICS_SCALE - mouseX;
			_aim.y = hoopPos.y * Settings.PHYSICS_SCALE - mouseY;
			
			_physics.b2body.SetTransform(hoopPos, -Math.atan2(_aim.x, _aim.y));
			_physics.updateBodyMatrix(null);
		}
		
		override public function onDragEnd(mouseX:Number, mouseY:Number):void {
			if (!_gloop) return super.onDragEnd(mouseX, mouseY); // if there's no gloop, run the regular drag code and bail
			if (_aim.length < Settings.LAUNCHER_POWER_MIN) return;
			launch();
		}
		
		public function launch() : void
		{
			if (!_gloop)
				return; // can't fire if not holding the gloop
			
			var power:Number = Math.min(_aim.length, Settings.LAUNCHER_POWER_MAX);
			power = (power - Settings.LAUNCHER_POWER_MIN) / Settings.LAUNCHER_POWER_SCALE;
				
			var impulse : V2 = _physics.b2body.GetWorldVector(new V2(0, -power));
			_gloop.physics.b2body.ApplyImpulse(impulse, _physics.b2body.GetWorldCenter());
			
			_gloop.onLaunch();
			
			_gloop = null; // release the gloop
			_fired = true;
			
			dispatchEvent(new GameObjectEvent(GameObjectEvent.LAUNCHER_FIRE_GLOOP, this));
		}
		
		override public function update(dt : Number) : void
		{
			super.update(dt);
			if (!_gloop)
				return;
			_gloop.physics.b2body.SetLinearVelocity(new V2(0, 0)); // kill incident velocity
			_gloop.physics.b2body.SetTransform(_physics.b2body.GetPosition().clone(), 0); // position gloop on top of launcher
		}
		
		override public function get debugColor1() : uint
		{
			return 0x5F9E30;
		}
		
		override public function get debugColor2() : uint
		{
			return 0x436F22;
		}
	
	}

}