package com.away3d.gloop.events
{
	import flash.events.Event;

	public class GameEvent extends Event
	{
		public static const LEVEL_WIN : String = 'levelWin';
		public static const LEVEL_LOSE : String = 'levelLose';
		public static const LEVEL_LOAD : String = 'levelLoad';
		public static const LEVEL_SELECT : String = 'levelSelect';
		
		public function GameEvent(type : String)
		{
			super(type);
		}
		
		
		public override function clone() : Event
		{
			return new GameEvent(type);
		}
	}
}