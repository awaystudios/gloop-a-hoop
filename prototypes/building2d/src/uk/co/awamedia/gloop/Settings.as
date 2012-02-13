package uk.co.awamedia.gloop {
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Settings {
		
		public static const GRID_SIZE : int = 10;
		public static const GLOOP_BOUNCE_FRICTION : Number = .95;
		public static const GLOOP_GRAVITY : Number = .098;
		public static const GLOOP_DRAG : Number = .99;
		static public const COLLISION_STEP:Number = GRID_SIZE / 4;
		static public const COLLISION_DETECTOR_DISTANCE:Number = GRID_SIZE * .75;
		
	}

}