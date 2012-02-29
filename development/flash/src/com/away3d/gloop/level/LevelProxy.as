package com.away3d.gloop.level
{
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.events.GameEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;

	public class LevelProxy extends EventDispatcher
	{
		private var _id : int;
		private var _idx : uint;
		private var _awd_url : String;
		private var _level : Level;
		
		private var _completed : Boolean;
		
		// Best star result and stars collected this round
		private var _best_num_stars : uint;
		private var _round_num_stars : uint;
		
		private var _inventory : LevelInventory;
		
		
		public function LevelProxy(indexInChapter : uint)
		{
			_idx = indexInChapter;
			_inventory = new LevelInventory();
		}
		
		
		public function get level() : Level
		{
			return _level;
		}
		
		
		public function get id() : int
		{
			return _id;
		}
		
		
		public function get indexInChapter() : uint
		{
			return _idx;
		}
		
		
		public function get bestStarsCollected() : uint
		{
			return _best_num_stars;
		}
		
		public function get starsCollected() : uint
		{
			return _round_num_stars;
		}
		
		
		public function get inventory() : LevelInventory
		{
			return _inventory;
		}
		
		
		public function get completed() : Boolean
		{
			return _completed;
		}
		
		
		public function calcRoundScore() : uint
		{
			var score:int = Settings.SCORE_BASE + _round_num_stars * Settings.SCORE_STAR_VALUE;
			if (level.finishedWithBullseye) score *= Settings.SCORE_BULLSEYE_MULTIPLIER;
			return score;
		}
		
		
		public function parseXml(xml : XML) : void
		{
			_id = parseInt(xml.@id.toString());
			_awd_url = xml.@awd.toString();
			
			_inventory.parseXml(xml.inventory[0]);
		}
		
		
		public function getStateXml() : XML
		{
			var xml : XML;
			
			xml = new XML('<level/>');
			xml.@id = _id.toString();
			xml.@completed = _completed.toString();
			xml.@stars = _best_num_stars.toString();
			
			return xml;
		}
		
		
		public function setStateFromXml(xml : XML) : void
		{
			_completed = (xml.@completed.toString() == 'true');
			_best_num_stars = parseInt(xml.@stars.toString()) || 0;
		}
		
		
		public function load(forceReload : Boolean = false) : void
		{
			if (!_level || forceReload) 
			{
				if(_level)
				{
					_level.dispose();
					_level = null;
				}
				
				var loader : LevelLoader;
				
				loader = new LevelLoader(Settings.GRID_SIZE);
				loader.addEventListener(Event.COMPLETE, onLevelComplete);
				loader.load(new URLRequest(_awd_url));
			}
			else 
			{
				dispatchEvent(new GameEvent(GameEvent.LEVEL_LOAD));
			}
		}
		
		
		public function reset() : void
		{
			_level.reset();
			_inventory.reset();
			
			_round_num_stars = 0;
			
			dispatchEvent(new GameEvent(GameEvent.LEVEL_RESET));
		}
		
		private function onLevelComplete(ev : Event) : void
		{
			var loader : LevelLoader;
			
			loader = LevelLoader(ev.currentTarget);
			loader.removeEventListener(Event.COMPLETE, onLevelComplete);
			
			_level = loader.loadedLevel;
			_level.addEventListener(GameEvent.LEVEL_LOSE, onLevelLose);
			_level.addEventListener(GameEvent.LEVEL_WIN, onLevelWin);
			_level.addEventListener(GameEvent.LEVEL_STAR_COLLECT, onLevelStarCollect);
			
			dispatchEvent(new GameEvent(GameEvent.LEVEL_LOAD));
		}
		
		private function onLevelStarCollect(ev : GameEvent) : void
		{
			_round_num_stars++;
			dispatchEvent(ev.clone());
		}
		
		private function onLevelWin(ev : GameEvent) : void
		{
			_completed = true;
			if (_round_num_stars > _best_num_stars)
				_best_num_stars = _round_num_stars;
			
			dispatchEvent(ev.clone());
		}
		
		private function onLevelLose(ev : GameEvent) : void
		{
			dispatchEvent(ev.clone());
			reset();
		}
	}
}