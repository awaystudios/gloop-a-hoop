package com.away3d.gloop.gameobjects.components
{
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	import Box2DAS.Common.V2;
	
	import com.away3d.gloop.Settings;
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;
	
	public class WallPhysicsComponent extends PhysicsComponent
	{
		
		protected var _width : Number;
		protected var _height : Number;
		protected var _offsetX : Number;
		protected var _offsetY : Number;
		
		public function WallPhysicsComponent(gameObject : DefaultGameObject, offsetX : Number, offsetY : Number, width : Number, height : Number)
		{
			super(gameObject);
			_offsetX = offsetX-Settings.WALL_PADDING;
			_offsetY = offsetY-Settings.WALL_PADDING;
			_width = width+2*Settings.WALL_PADDING;
			_height = height+2*Settings.WALL_PADDING;
			graphics.beginFill(gameObject.debugColor1);
			graphics.drawRect(_offsetX, _offsetY, _width, _height);
		}
		
		public override function shapes() : void
		{
			poly([
				[_offsetX, 			_offsetY],
				[_offsetX + _width, _offsetY],
				[_offsetX + _width, _offsetY + _height],
				[_offsetX, 			_offsetY + _height],
			]);	
		}
		
		override public function create() : void
		{
			super.create();
			setCollisionGroup(LEVEL);
		}
	
	}

}