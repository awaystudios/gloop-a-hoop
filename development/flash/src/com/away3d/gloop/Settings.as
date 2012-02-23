package com.away3d.gloop
{
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 * NOTE: these settings are overriden by an external source.
	 */
	public class Settings
	{

		static public var GLOOP_RADIUS : Number = 25;
		static public var GLOOP_ANGULAR_DAMPING : Number = 0;
		static public var GLOOP_FRICTION : Number = 1;
		static public var GLOOP_RESTITUTION : Number = .75;
		static public var GLOOP_LINEAR_DAMPING : Number = .1;

		static public var GLOOP_DECAL_SPEED_FACTOR : Number = 2;
		static public var GLOOP_DECAL_MIN_SPEED : Number = 0.5;
		static public var GLOOP_MAX_DECALS_PER_HIT : Number = 20;
		static public var GLOOP_MAX_DECALS_TOTAL : Number = 30;
		static public var GLOOP_LOST_MOMENTUM_THRESHOLD : Number = .01;
		
		[comment("delay between splats while on a surface, in updates")]
		static public var GLOOP_SPLAT_COOLDOWN : int = 20;

		[comment("values closer to one makes the average move faster")]
		static public var GLOOP_MOMENTUM_MULTIPLIER : Number = .1;
		static public var HOOP_RADIUS : Number = 60;
		static public var HOOP_ROTATION_STEP : Number = 45;

		static public var BUTTON_RADIUS : Number = 60;

		[comment("dragging a distance shorter than this cancels the launch")]
		static public var LAUNCHER_POWER_MIN : Number = 30;
		[comment("the drag distance is capped to this value, dragging longer won't make a difference")]
		static public var LAUNCHER_POWER_MAX : Number = 200;
		[comment("the value remaining is scaled by this multiplier before being applied to gloop")]
		static public var LAUNCHER_POWER_SCALE : Number = 10;

		static public var ROCKET_POWER : Number = 15;

		static public var TRAMPOLINE_RESTITUTION : Number = 1.25;

		static public var FAN_BODY_WIDTH : Number = 60;
		static public var FAN_BODY_HEIGHT : Number = 5;
		static public var FAN_AREA_WIDTH : Number = 60;
		static public var FAN_AREA_HEIGHT : Number = 100;
		static public var FAN_POWER : Number = 0.25;

		static public var STAR_RADIUS : Number = 30;

		static public var PHYSICS_SCALE : Number = 60;
		static public var PHYSICS_TIME_STEP : Number = 0.05;
		static public var PHYSICS_VELOCITY_ITERATIONS : Number = 5;
		static public var PHYSICS_POSITION_ITERATIONS : Number = 5;
		static public var PHYSICS_GRAVITY_Y : Number = 1;
		
		static public var SHOW_COLLISION_WALLS : Boolean = true;
		static public var SHOW_COSMETIC_MESHES : Boolean = false;
	}

}