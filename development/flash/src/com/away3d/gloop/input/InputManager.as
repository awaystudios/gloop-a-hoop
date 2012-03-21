package com.away3d.gloop.input
{

	import away3d.containers.View3D;

	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.IMouseInteractive;
	import com.away3d.gloop.level.Level;

	import flash.events.Event;

	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
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

		private var _interactionPointX:Number = 0;
		private var _interactionPointY:Number = 0;

		private var _interactionDeltaX:Number = 0;
		private var _interactionDeltaY:Number = 0;

		private var _prevInteractionPointX : Number = 0;
		private var _prevInteractionPointY : Number = 0;
		
		private var _startInteractionPointX : Number = 0;
		private var _startInteractionPointY : Number = 0;
		
		private var _panX : Number;
		private var _panY : Number;
		private var _zoom : Number;
		
		private var _isClick : Boolean;
		private var _zooming : Boolean;
		private var _panning : Boolean;

		private var _touch1:TouchVO = new TouchVO();
		private var _touch2:TouchVO = new TouchVO();
		private var _touchDistance:Number = 0;
		private var _lastTouchDistance:Number = 0;

		private var _panVelocityX:Number = 0;
		private var _panVelocityY:Number = 0;

		private var _interacting:Boolean;

		private var _onPanImpulse:Boolean;

		private const MAX_IMPULSE:Number = 50;

		public function InputManager(view : View3D)
		{
			super(view);
		}
		
		public function reset(level : Level) : void
		{
			_level = level;
			_zoom = 1;
			_panX = 0;
			_panY = 300;
			_panVelocityX = 0;
			_panVelocityY = 0;
			
			_touch1.id = -1;
			_touch2.id = -1;
		}
		
		override public function activate() : void
		{
			super.activate();
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			_view.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_view.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
			_view.stage.addEventListener(TouchEvent.TOUCH_END, onTouch);
			_view.stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouch);
			_view.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		override public function deactivate() : void {
			super.deactivate();
			_view.stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			_view.stage.removeEventListener( TouchEvent.TOUCH_BEGIN, onTouch );
			_view.stage.removeEventListener( TouchEvent.TOUCH_END, onTouch );
			_view.stage.removeEventListener( TouchEvent.TOUCH_MOVE, onTouch );
			_view.stage.removeEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel );
		}

		override public function update():void {

			_interactionDeltaX = -(_interactionPointX - _prevInteractionPointX);
			_interactionDeltaY = (_interactionPointY - _prevInteractionPointY);
			_prevInteractionPointX = _interactionPointX;
			_prevInteractionPointY = _interactionPointY;
			
			if( _onPanImpulse ) {
				_panVelocityX *= 0.9;
				_panVelocityY *= 0.9;
				_panX += _panVelocityX;
				_panY += _panVelocityY;
				var speed:Number = Math.sqrt( _panVelocityX * _panVelocityX + _panVelocityY * _panVelocityY );
				if( speed < 0.1 ) _onPanImpulse = false;
			}

			if( !_mouseDown ) {
				return; // if there's no touch, there's no sense in updating
			}

			super.update();

			// calculate how far from the origin the players finger has moved
			var distance:Number = (_startInteractionPointX - _interactionPointX) * (_startInteractionPointX - _interactionPointX) + (_startInteractionPointY - _interactionPointY) * (_startInteractionPointY - _interactionPointY);

			// if we still might be clicking and the player has moved far enough, start the dragging
			if( _isClick && distance > Settings.INPUT_DRAG_THRESHOLD_SQUARED ) {
				_isClick = false;
				if( _targetObject ) {
					_targetObject.onDragStart( projectedMouseX, projectedMouseY );
				} else {
					_panning = true;
				}
			}

			if( _targetObject && !_isClick )
				_targetObject.onDragUpdate( projectedMouseX, projectedMouseY );

			if( _panning && !_zooming ) {
				_panX += _interactionDeltaX;
				_panY += _interactionDeltaY;
			}
		}

		override protected function onViewMouseDown(e : MouseEvent) : void
		{
			super.onViewMouseDown(e);

			_isClick = true;
			_panning = false;
			_zooming = false;
			_interacting = true;
			_mouseDownTime = getTimer();

			// if the level has a unplaced hoop, don't pick any hoops from the level
			if (_level.unplacedHoop == null) {
				_targetObject = _level.getNearestIMouseInteractive(projectedMouseX, projectedMouseY);
			}

			_interactionPointX = _startInteractionPointX = _prevInteractionPointX = _view.mouseX;
			_interactionPointY = _startInteractionPointY = _prevInteractionPointY = _view.mouseY;

			update();
		}

		override protected function onViewMouseUp(e : Event) : void
		{
			super.onViewMouseUp(e);

			var clickDuration : Number = getTimer() - _mouseDownTime;
			if (clickDuration > Settings.INPUT_CLICK_TIME) _isClick = false;

			if (_level.unplacedHoop && _isClick) {
				_level.placeQueuedHoop(projectedMouseX, projectedMouseY);
			}

			if (_targetObject) {
				// deal with click if duration was short enough
				if (_isClick) {
					_targetObject.onClick(projectedMouseX, projectedMouseY);

				// else, end dragging
				} else {
					_targetObject.onDragEnd(projectedMouseX, projectedMouseY);
				}
			}

			_targetObject = null;
			_panning = false;
			_zooming = false;
			_interacting = false;

			if( !_isClick ) {
				_panVelocityX = _interactionDeltaX;
				_panVelocityY = _interactionDeltaY;
				var speed:Number = Math.sqrt( _panVelocityX * _panVelocityX + _panVelocityY * _panVelocityY );
				if( speed > 1 ) { // TODO: impulse not working well on touch, review...
					_onPanImpulse = true;
					_panVelocityX = _panVelocityX > MAX_IMPULSE ? MAX_IMPULSE : _panVelocityX;
					_panVelocityX = _panVelocityX < -MAX_IMPULSE ? -MAX_IMPULSE : _panVelocityX;
					_panVelocityY = _panVelocityY > MAX_IMPULSE ? MAX_IMPULSE : _panVelocityY;
					_panVelocityY = _panVelocityY < -MAX_IMPULSE ? -MAX_IMPULSE : _panVelocityY;
				}
			}

			_interactionPointX = _startInteractionPointX = _prevInteractionPointX = _view.mouseX;
			_interactionPointY = _startInteractionPointY = _prevInteractionPointY = _view.mouseY;
		}

		public function applyImpulse( x:Number, y:Number ):void {
			_onPanImpulse = true;
			_panVelocityX += x;
			_panVelocityY += y;
		}

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

			if( _touch1.id >= 0 && _touch2.id >= 0 ) {
				_interacting = true;
				// update mouse position
				_interactionPointX = _touch1.x;
				_interactionPointY = _touch1.y;
				// update zoom
				var dx:Number = _touch1.x - _touch2.x;
				var dy:Number = _touch1.y - _touch2.y;
				_touchDistance = Math.sqrt( dx * dx + dy * dy );
				if( _lastTouchDistance != 0 ) {
					_zoom += ( _touchDistance - _lastTouchDistance ) * 0.01;
				}
				_lastTouchDistance = _touchDistance;
			}
			else {
				_interacting = false;
			}
		}

		private function onMouseWheel(e : MouseEvent) : void
		{
			_zoom += e.delta * 0.01;
		}

		private function onMouseMove( event:MouseEvent ):void {
			// contained because of an AIR 3.2 bug with quick touch events generating nonsense mouse move values
			if( _view.mouseX > 0 && _view.mouseX < 100000 ) {
				_interactionPointX = _view.mouseX;
			}
			if( _view.mouseY > 0 && _view.mouseY < 100000 ) {
				_interactionPointY = _view.mouseY;
			}
		}

		public function set panX( value:Number ):void {
			_panX = value;
		}

		public function get panX():Number {
			return _panX;
		}

		public function set panY( value:Number ):void {
			_panY = value;
		}

		public function get panY():Number {
			return _panY;
		}

		public function set zoom( value:Number ):void {
			_zoom = value;
		}

		public function get zoom():Number {
			return _zoom;
		}

		public function get interacting():Boolean {
			return _interacting;
		}
	}

}