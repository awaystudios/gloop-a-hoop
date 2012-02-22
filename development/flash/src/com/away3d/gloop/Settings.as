package com.away3d.gloop
{
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Settings
	{
		
		static public var GLOOP_RADIUS : Number = 30;
		static public var GLOOP_ANGULAR_DAMPING : Number = 1;
		static public var GLOOP_FRICTION : Number = 1;
		static public var GLOOP_RESTITUTION : Number = .75;
		
		static public var GLOOP_DECAL_SPEED_FACTOR : Number = 2;
		static public var GLOOP_DECAL_MIN_SPEED : Number = 1;
		static public var GLOOP_MAX_DECALS_PER_HIT : Number = 20;
		static public var GLOOP_MAX_DECALS_TOTAL : Number = 30;
		
		static public var HOOP_RADIUS : Number = 60;
		static public var HOOP_ROTATION_STEP : Number = 45;
		
		static public var BUTTON_RADIUS : Number = 60;
		
		static public var LAUNCHER_POWER_MIN : Number = 15;
		static public var LAUNCHER_POWER_MAX : Number = 200;
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
	}

}