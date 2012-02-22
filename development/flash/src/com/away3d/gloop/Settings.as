package com.away3d.gloop
{
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Settings
	{
		
		static public const GLOOP_RADIUS : Number = 30;
		static public const GLOOP_ANGULAR_DAMPING : Number = 1;
		static public const GLOOP_FRICTION : Number = 1;
		static public const GLOOP_RESTITUTION : Number = .75;
		
		static public const GLOOP_DECAL_SPEED_FACTOR : Number = 2;
		static public const GLOOP_DECAL_MIN_SPEED : Number = 1;
		static public const GLOOP_MAX_DECALS_PER_HIT : Number = 20;
		static public const GLOOP_MAX_DECALS_TOTAL : Number = 30;
		
		static public const HOOP_RADIUS : Number = 60;
		static public const HOOP_LINEAR_DAMPING : Number = 100;
		static public const HOOP_ROTATION_STEP : Number = 45;
		
		static public const LAUNCHER_POWER_MIN : Number = 15;
		static public const LAUNCHER_POWER_MAX : Number = 200;
		static public const LAUNCHER_POWER_SCALE : Number = 10;
		
		static public const ROCKET_POWER : Number = 15;
		
		static public const TRAMPOLINE_RESTITUTION : Number = 1.25;
		
		static public const FAN_BODY_WIDTH : Number = 60;
		static public const FAN_BODY_HEIGHT : Number = 5;
		static public const FAN_AREA_WIDTH : Number = 60;
		static public const FAN_AREA_HEIGHT : Number = 100;
		static public const FAN_POWER : Number = 0.25;
		
		static public const STAR_RADIUS : Number = 30;
		
		static public const PHYSICS_SCALE : Number = 60;
		static public const PHYSICS_TIME_STEP : Number = 0.05;
		static public const PHYSICS_VELOCITY_ITERATIONS : Number = 5;
		static public const PHYSICS_POSITION_ITERATIONS : Number = 5;
		static public const PHYSICS_GRAVITY_Y : Number = 1;
	}

}