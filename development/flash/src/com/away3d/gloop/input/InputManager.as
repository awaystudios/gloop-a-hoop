package com.away3d.gloop.input
{
	import Box2DAS.Common.V2;
	import com.away3d.gloop.Settings;

	import away3d.containers.View3D;

	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.Wall;
	import com.away3d.gloop.gameobjects.hoops.Hoop;
	import com.away3d.gloop.level.Level;

	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;

	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class InputManager extends MouseManager
	{

		private var _level : Level;
		private var _mouseDownTime : Number = 0;
		private var _targetHoop : Hoop;

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
			_view.stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onPinch);
			_view.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		public function deactivate() : void
		{
			_view.stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, onPinch);
			_view.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		override public function update() : void
		{
			if (!_mouseDown)
				return; // if there's no touch, there's no sense in updating

			super.update();

			// calculate how far from the origin the players finger has moved
			var distance:Number = (_startViewMouseX - _view.mouseX) * (_startViewMouseX - _view.mouseX) + (_startViewMouseY - _view.mouseY) * (_startViewMouseY - _view.mouseY);

			// if we still might be clicking and the player has moved far enough, start the dragging
			if (_isClick && distance > Settings.INPUT_DRAG_THRESHOLD_SQUARED) {
				_isClick = false;

				if (_targetHoop) {
					_targetHoop.onDragStart(mouseX, mouseY);
				} else {
					_panning = true;
				}
			}

			if (_targetHoop && !_isClick)
				_targetHoop.onDragUpdate(mouseX, mouseY);

			if (_panning && !_zooming)
			{
				_panX -= (_view.mouseX - _prevViewMouseX);
				_panY += (_view.mouseY - _prevViewMouseY);
			}

			_prevViewMouseX = _view.mouseX;
			_prevViewMouseY = _view.mouseY;
		}

		private function onPinch(e : TransformGestureEvent) : void
		{
			if (!_targetHoop)
			{
				_zooming = true;
				_zoom += ((e.scaleX + e.scaleY) * 0.5) - 1;
			}
		}

		private function onMouseWheel(e : MouseEvent) : void
		{
			_zoom += e.delta * 0.01;
		}

		override protected function onViewMouseDown(e : MouseEvent) : void
		{
			super.onViewMouseDown(e);
			_mouseDownTime = getTimer();
			_isClick = true;
			_panning = false;
			_zooming = false;

			// if the level has a unplaced hoop, don't pick any hoops from the level
			if (_level.unplacedHoop == null) {
				_targetHoop = _level.getNearestHoop(mouseX, mouseY);
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

			if (_targetHoop) {
				// deal with click if duration was short enough
				if (_isClick) {
					_targetHoop.onClick(mouseX, mouseY);

				// else, end dragging
				} else {
					_targetHoop.onDragEnd(mouseX, mouseY);
				}
			}

			_targetHoop = null;
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