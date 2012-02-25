package com.away3d.gloop.input
{
	import Box2DAS.Common.V2;
	import com.away3d.gloop.gameobjects.IMouseInteractive;
	import com.away3d.gloop.Settings;

	import away3d.containers.View3D;

	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.Wall;
	import com.away3d.gloop.gameobjects.hoops.Hoop;
	import com.away3d.gloop.level.Level;

	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class InputManager extends MouseManager
	{

		private var _level : Level;
		private var _mouseDownTime : Number = 0;
		private var _targetObject : IMouseInteractive;

		private var _prevViewMouseX : Number;
		private var _prevViewMouseY : Number;

		private var _startViewMouseX : Number;
		private var _startViewMouseY : Number;

		private var _panX : Number;
		private var _panY : Number;
		private var _zoom : Number;

		private var _isClick : Boolean;
		private var _zooming : Boolean;
		private var _panning : Boolean;

		private var _mouseX:Number;
		private var _mouseY:Number;

		private var _touch1:TouchVO = new TouchVO();
		private var _touch2:TouchVO = new TouchVO();
		private var _touchDistance:Number = 0;
		private var _lastTouchDistance:Number = 0;

		private var _dirty:Boolean = true;

		public function InputManager(view : View3D)
		{
			super(view);
		}

		public function get panX() : Number
		{
			return _panX;
		}

		public function get panY() : Number
		{
			return _panY;
		}

		public function get zoom() : Number
		{
			return _zoom;
		}

		public function reset(level : Level) : void
		{
			_level = level;
			_zoom = 1;
			_panX = 0;
			_panY = 300;
		}

		public function activate() : void
		{
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			_view.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//			_view.stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onPinch);
			_view.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
			_view.stage.addEventListener(TouchEvent.TOUCH_END, onTouch);
			_view.stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouch);
			_view.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		public function deactivate() : void {
			_view.stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
//			_view.stage.removeEventListener( TransformGestureEvent.GESTURE_ZOOM, onPinch );
			_view.stage.removeEventListener( TouchEvent.TOUCH_BEGIN, onTouch );
			_view.stage.removeEventListener( TouchEvent.TOUCH_END, onTouch );
			_view.stage.removeEventListener( TouchEvent.TOUCH_MOVE, onTouch );
			_view.stage.removeEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel );
		}

		// TODO: remove when new method is reviewed ( replaced by "onTouch()" )
		/*private function onPinch(e : TransformGestureEvent) : void {
		 if( !_targetHoop ) {
		 _zooming = true;
		 _zoom += ((e.scaleX + e.scaleY) * 0.5) - 1;
		 }
		 }*/

		private function onTouch( event:TouchEvent ):void {

			var touchVO:TouchVO;
			if( event.type == TouchEvent.TOUCH_BEGIN ) {
				touchVO = _touch1.id == -1 ? _touch1 : _touch2;
				if( _touch1.id == -1 ) {
					touchVO = _touch1;
				}
				else {
					touchVO = _touch2;
					_lastTouchDistance = 0;
				}
				touchVO.id = event.touchPointID;
				touchVO.x = event.stageX;
				touchVO.y = event.stageY;
			}
			else {
				touchVO = event.touchPointID == _touch1.id ? _touch1 : _touch2;
				if( event.type == TouchEvent.TOUCH_END ) {
					touchVO.id = -1;
				}
				else if( event.type == TouchEvent.TOUCH_MOVE ) {
					touchVO.x = event.stageX;
					touchVO.y = event.stageY;
				}
			}

			if( _touch1.id > 0 && _touch2.id > 0 ) {
				// update mouse position
				_mouseX = _touch1.x;
				_mouseY = _touch1.y;
				// update zoom
				var dx:Number = _touch1.x - _touch2.x;
				var dy:Number = _touch1.y - _touch2.y;
				_touchDistance = Math.sqrt( dx * dx + dy * dy );
				if( _lastTouchDistance != 0 ) {
					_zoom += ( _touchDistance - _lastTouchDistance ) * 0.01;
				}
				_lastTouchDistance = _touchDistance;
			}
		}

		public function recordDirty():void {
			_dirty = false;
		}

		public function isDirty():Boolean {
			return _dirty;
		}

		private function onMouseMove( event:MouseEvent ):void {
			_mouseX = _view.mouseX;
			_mouseY = _view.mouseY;
		}

		override public function update() : void
		{
			if (!_mouseDown)
				return; // if there's no touch, there's no sense in updating

			super.update();

			// calculate how far from the origin the players finger has moved
			var distance:Number = (_startViewMouseX - _mouseX) * (_startViewMouseX - _mouseX) + (_startViewMouseY - _mouseY) * (_startViewMouseY - _mouseY);

			// if we still might be clicking and the player has moved far enough, start the dragging
			if (_isClick && distance > Settings.INPUT_DRAG_THRESHOLD_SQUARED) {
				_isClick = false;

				if (_targetObject) {
					_targetObject.onDragStart(mouseX, mouseY);
				} else {
					_panning = true;
				}
			}

			if (_targetObject && !_isClick)
				_targetObject.onDragUpdate(mouseX, mouseY);

			if (_panning && !_zooming)
			{
				_panX -= (_mouseX - _prevViewMouseX);
				_panY += (_mouseY - _prevViewMouseY);
			}

			_prevViewMouseX = _mouseX;
			_prevViewMouseY = _mouseY;
		}

		private function onMouseWheel(e : MouseEvent) : void
		{
			_zoom += e.delta * 0.01;
		}

		override protected function onViewMouseDown(e : MouseEvent) : void
		{
			_dirty = true;

			super.onViewMouseDown(e);
			_mouseDownTime = getTimer();
			_isClick = true;
			_panning = false;
			_zooming = false;

			// if the level has a unplaced hoop, don't pick any hoops from the level
			if (_level.unplacedHoop == null) {
				_targetObject = _level.getNearestIMouseInteractive(mouseX, mouseY);
			}

			_startViewMouseX = _prevViewMouseX = _view.mouseX;
			_startViewMouseY = _prevViewMouseY = _view.mouseY;
		}

		override protected function onViewMouseUp(e : MouseEvent) : void
		{
			super.onViewMouseUp(e);
			var clickDuration : Number = getTimer() - _mouseDownTime;
			if (clickDuration > Settings.INPUT_CLICK_TIME) _isClick = false;

			if (_level.unplacedHoop && _isClick) {
				_level.placeQueuedHoop(mouseX, mouseY);
			}

			if (_targetObject) {
				// deal with click if duration was short enough
				if (_isClick) {
					_targetObject.onClick(mouseX, mouseY);

				// else, end dragging
				} else {
					_targetObject.onDragEnd(mouseX, mouseY);
				}
			}

			_targetObject = null;
			_panning = false;
			_zooming = false;
		}

		public function set panX(value : Number) : void
		{
			_panX = value;
		}

		public function set panY(value : Number) : void
		{
			_panY = value;
		}

		public function set zoom(value : Number) : void
		{
			_zoom = value;
		}
	}

}