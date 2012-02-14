package uk.co.awamedia.gloop.gameobjects
{
	import away3d.entities.Mesh;
	import uk.co.awamedia.gloop.levels.Level;
	import uk.co.awamedia.gloop.Settings;
	
	import flash.geom.Point;

	public class Gloop extends GameObject
	{
		
		public function Gloop(mesh : Mesh)
		{
			super(mesh);
			radius = .75;
		}
		
		override public function update(timeDelta:Number = 1):void {			
			speed.x *= Settings.GLOOP_DRAG;
			speed.y *= Settings.GLOOP_DRAG;
			
			speed.y += Settings.GLOOP_GRAVITY;
		
			super.update(timeDelta);
		}
		
		public function collideWithLevel(level:Level):void {
			if (speed.x < 0 && testAndResolveCollision(level, -radius, 0, true)) speed.x *= -Settings.GLOOP_BOUNCE_FRICTION;
			if (speed.x > 0 && testAndResolveCollision(level,  radius, 0, true)) speed.x *= -Settings.GLOOP_BOUNCE_FRICTION;
			if (speed.y < 0 && testAndResolveCollision(level, 0, -radius, false, true)) speed.y *= -Settings.GLOOP_BOUNCE_FRICTION;
			if (speed.y > 0 && testAndResolveCollision(level, 0,  radius, false, true)) speed.y *= -Settings.GLOOP_BOUNCE_FRICTION;
			
			if (speed.y > 0 && testAndResolveCollision(level,  radius,  radius, false, true)) speed.y *= -Settings.GLOOP_BOUNCE_FRICTION;
			if (speed.y < 0 && testAndResolveCollision(level,  radius, -radius, false, true)) speed.y *= -Settings.GLOOP_BOUNCE_FRICTION;
			if (speed.y < 0 && testAndResolveCollision(level, -radius, -radius, false, true)) speed.y *= -Settings.GLOOP_BOUNCE_FRICTION;
			if (speed.y > 0 && testAndResolveCollision(level, -radius,  radius, false, true)) speed.y *= -Settings.GLOOP_BOUNCE_FRICTION;	
		}
	}
}