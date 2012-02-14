package uk.co.awamedia.gloop.events
{
	import flash.events.Event;
	
	public class LevelInteractionEvent extends Event
	{
		private var _grid_x : uint;
		private var _grid_y : uint;
		
		public static const RELEASE : String = 'interactionEventRelease';
		public static const DRAG : String = 'interactionEventDrag';
		public static const DOWN : String = 'interactionEventTap';
		
		
		public function LevelInteractionEvent(type:String, gridX : uint, gridY : uint)
		{
			super(type);
			
			_grid_x = gridX;
			_grid_y = gridY;
		}
		
		
		public function get gridX() : Number
		{
			return _grid_x;
		}
		
		
		public function get gridY() : Number
		{
			return _grid_y;
		}
	}
}