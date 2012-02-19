package accelerometer
{

	import flash.events.Event;

	import wck.World;

	public class BounceWorld extends World
	{
		private var _worldWidth:Number;
		private var _worldHeight:Number;

		public function BounceWorld( width:Number, height:Number ) {
			super();
			_worldWidth = width;
			_worldHeight = height;
			init();
		}

		private function init():void {
			// balls
			var i:uint, j:uint;
			var w:uint = 3;
			var h:uint = 1;
			var radius:Number = 50;
			var spacing:Number = 20;
			var offset:Number = ( w / 2 ) * ( 2 * radius + spacing );
			var delta:Number = 2 * radius + spacing;
			for( i = 0; i < w; ++i ) {
				for( j = 0; j < h; ++j ) {
					var x:Number = _worldWidth / 2 - offset + delta * i;
					var y:Number = _worldHeight / 2 - offset + delta * j;
					createBall( x + rand( -10, 10 ), y + rand( -10, 10 ), radius );
				}
			}
			// walls
			var wallThickness:Number = 20;
			createWall( _worldWidth / 2, _worldHeight - wallThickness / 2, _worldWidth, wallThickness ); // floor
			createWall( _worldWidth / 2, wallThickness / 2, _worldWidth, 20 ); // roof
			createWall( _worldWidth - wallThickness / 2, _worldHeight / 2, wallThickness, _worldHeight ); // right wall
			createWall( wallThickness / 2, _worldHeight / 2, wallThickness, _worldHeight ); // left wall
		}

		private function rand(min:Number, max:Number):Number
		{
		    return (max - min)*Math.random() + min;
		}

		private function createBall( x:Number, y:Number, radius:Number ):void {
			var ball:Ball = new Ball( radius );
			ball.x = x;
			ball.y = y;
			addChild( ball );
		}

		private function createWall( x:Number, y:Number, width:Number, height:Number ):void {
			var wall:Wall = new Wall();
			wall.x = x;
			wall.y = y;
			wall.width = width;
			wall.height = height;
			addChild( wall );
		}
	}
}
