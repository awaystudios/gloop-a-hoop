package com.away3d.gloop.screens.chapterselect
{
	import com.away3d.gloop.level.ChapterData;
	import com.away3d.gloop.level.LevelDatabase;
	import com.away3d.gloop.lib.buttons.BackButton;
	import com.away3d.gloop.screens.ScreenBase;
	import com.away3d.gloop.screens.ScreenStack;
	import com.away3d.gloop.screens.Screens;
	
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ChapterSelectScreen extends ScreenBase
	{
		private var _db : LevelDatabase;
		private var _stack : ScreenStack;
		private var _posters : Vector.<ChapterPoster>;
		
		private var _prevPoster : ChapterPoster;
		private var _curPoster : ChapterPoster;
		private var _nextPoster : ChapterPoster;
		
		private var _curPosterIdx : uint;
		
		private var _dragging : Boolean;
		private var _targetX : Number;
		private var _centerX : Number;
		private var _mouseDownX : Number;
			
		private var _backBtn : SimpleButton;
		
		
		public function ChapterSelectScreen(db : LevelDatabase, stack : ScreenStack)
		{
			super();
			
			_db = db;
			_stack = stack;
		}
		
		
		protected override function initScreen():void
		{
			var i : uint;
			var len : uint;
			
			_centerX = _w/2;
			_targetX = _centerX;
			
			_posters = new Vector.<ChapterPoster>();
			
			len = _db.chapters.length;
			for (i=0; i<len; i++) {
				var chapter : ChapterData;
				var poster : ChapterPoster;
				
				chapter = _db.chapters[i];
				poster = new ChapterPoster(chapter);
				poster.x = _centerX + _w * i;
				poster.y = _h/2;
				poster.addEventListener(MouseEvent.CLICK, onPosterClick);
				addChild(poster);
				
				_posters.push(poster);
			}
			
			_curPosterIdx = 0;
			
			_backBtn = new BackButton();
			_backBtn.x = 20;
			_backBtn.y = 20;
			_backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClick);
			addChild(_backBtn);
		}
		
		
		public override function activate() : void
		{
			updatePosters();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
		}
		
		
		public override function deactivate() : void
		{
			endDrag();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
		}
		
		
		private function updatePosters() : void
		{
			_prevPoster = (_curPosterIdx>0)? _posters[_curPosterIdx-1] : null;
			_curPoster = _posters[_curPosterIdx];
			_nextPoster = (_curPosterIdx<_posters.length-1)? _posters[_curPosterIdx+1] : null;
		}
		
		
		private function updatePosterPositions() : void
		{
			_curPoster.x += (_targetX - _curPoster.x) * 0.2;
			
			if (_prevPoster)
				_prevPoster.x = _curPoster.x - _w;
			if (_nextPoster)
				_nextPoster.x = _curPoster.x + _w;
		}
		
		
		private function endDrag() : void
		{
			_dragging = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		
		private function onStageMouseDown(ev : MouseEvent) : void
		{
			_dragging = true;
			_mouseDownX = stage.mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		
		private function onStageMouseMove(ev : MouseEvent) : void
		{
			_targetX = _centerX + (stage.mouseX - _mouseDownX);
		}
		
		
		private function onStageMouseUp(ev : MouseEvent) : void
		{
			endDrag();
			
			if (_targetX < 0.25*_w && _curPosterIdx < _posters.length-1) {
				_curPosterIdx++;
			}
			else if (_targetX > 0.75*_w && _curPosterIdx > 0) {
				_curPosterIdx--;
			}
			
			updatePosters();
			
			_targetX = _centerX;
		}
		
		
		private function onPosterClick(ev : MouseEvent) : void
		{
			var dx : Number;
			
			dx = ev.stageX - _mouseDownX;
			if (dx < 10 && dx > -10) {
				var poster : ChapterPoster;
				poster = ChapterPoster(ev.currentTarget);
				_db.selectChapter(poster.chapterData);
			}
		}
		
		
		private function onBackBtnClick(ev : MouseEvent) : void
		{
			_stack.gotoScreen(Screens.START);
		}
		
		
		private function onEnterFrame(ev : Event) : void
		{
			updatePosterPositions();
		}
	}
}