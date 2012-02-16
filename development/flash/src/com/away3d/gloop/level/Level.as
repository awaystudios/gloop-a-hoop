package com.away3d.gloop.level
{
	import away3d.containers.Scene3D;
	
	import com.away3d.gloop.gameobjects.GameObject;
	
	import wck.World;

	public class Level
	{
		private var _scene : Scene3D;
		private var _world : World;
		
		private var _hoops : Vector.<GameObject>;
		
		public function Level()
		{
			_scene = new Scene3D();
		}
		
		
		public function get scene() : Scene3D
		{
			return _scene;
		}
		
		
		public function get world() : World
		{
			return _world;
		}
	}
}