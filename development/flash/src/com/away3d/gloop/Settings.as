package com.away3d.gloop
{
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 * NOTE: these settings are overriden by an external source.
	 */
	public class Settings
	{
		static public var GRID_SIZE : Number = 100;
		
		static public var CANNON_BASE_X : Number = 0;
		static public var CANNON_BASE_Y : Number = 0;
		static public var CANNON_BASE_W : Number = 100;
		static public var CANNON_BASE_H : Number = 100;
		
		static public var CANNON_BARREL_X : Number = 0;
		static public var CANNON_BARREL_Y : Number = 0;
		static public var CANNON_BARREL_W : Number = 100;
		static public var CANNON_BARREL_H : Number = 100;
		
		[comment("the time to wait before enabling gloop/cannon collisions after launching, in updates")]
		static public var CANNON_PHYSICS_DELAY:Number = 8;

		static public var GLOOP_RADIUS : Number = 25;
		static public var GLOOP_ANGULAR_DAMPING : Number = 0;
		static public var GLOOP_FRICTION : Number = 1;
		static public var GLOOP_RESTITUTION : Number = .75;
		static public var GLOOP_LINEAR_DAMPING : Number = .1;

		static public var GLOOP_DECAL_SPEED_FACTOR : Number = 2;
		static public var GLOOP_DECAL_MIN_SPEED : Number = 0.5;
		static public var GLOOP_DECAL_LIMIT_PER_HIT : Number = 20;
		static public var GLOOP_DECAL_LIMIT_TOTAL : Number = 30;
		static public var GLOOP_LOST_MOMENTUM_THRESHOLD : Number = .01;
		
		[comment("delay between splats while on a surface, in updates")]
		static public var GLOOP_SPLAT_COOLDOWN : int = 20;

		[comment("values closer to one makes the average move faster")]
		static public var GLOOP_MOMENTUM_MULTIPLIER : Number = .1;
		
		static public var GLOOP_MAX_SPEED : Number = 5.5;
		
		static public const HOOP_RADIUS : Number = GRID_SIZE / 2;
		
		static public var SCORE_BULLSEYE_MULTIPLIER : Number = 2;
		static public var SCORE_STAR_VALUE : Number = 350;
		static public var SCORE_BASE : Number = 500;
		
		static public var GOALWALL_DETECTOR_HEIGHT : Number = 200;
		static public var GOALWALL_DETECTOR_WIDTH : Number = 200;
		[comment("the threshold to be under to score a bullseye (0-1) lower is smaller")]
		static public var GOALWALL_BULLSEYE_THRESHOLD : Number = .2;
		
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
		
		static public var FAN_ON_OFF_TIME:Number = 0.4;

		static public var STAR_RADIUS : Number = 30;

		static public var PHYSICS_SCALE : Number = 60;
		static public var PHYSICS_TIME_STEP : Number = 0.05;
		static public var PHYSICS_VELOCITY_ITERATIONS : Number = 5;
		static public var PHYSICS_POSITION_ITERATIONS : Number = 5;
		static public var PHYSICS_GRAVITY_Y : Number = 1;
		
		static public var SHOW_COLLISION_WALLS : Boolean = false;
		static public var SHOW_COSMETIC_MESHES : Boolean = true;
		
		static public var TRACE_NUM_POINTS : uint = 20;
		static public var TRACE_MIN_DTIME : Number = 1;
		static public var TRACE_MIN_DPOS_SQUARED : Number = 100;
		static public var TRACE_MIN_SCALE : Number = 0.3;
		static public var TRACE_MAX_SCALE : Number = 0.7;
		
		[comment("the maximum time in milliseconds between down and up events to consider the input a click")]
		static public var INPUT_CLICK_TIME : uint = 250;
		[comment("the maximum distance a hoops centerpoint can be from the click to be considered hit")]
		static public var INPUT_PICK_DISTANCE : uint = 50;
		[comment("the maximum distance the player needs to drag before the actual drag events happen (also disables clicking)")]
		static public var INPUT_DRAG_THRESHOLD_SQUARED : uint = 100;
		
		[comment("the number of milliseconds to wait after hitting the goal wall until dispatching the level win")]
		static public var WIN_DELAY : int = 1500;
	}

}