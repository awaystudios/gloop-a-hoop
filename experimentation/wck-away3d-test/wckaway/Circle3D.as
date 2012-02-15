package wckaway
{

	import flash.geom.Rectangle;

	import misc.Util;

	import shapes.Oval;

	public class Circle3D extends Oval
	{
		public override function shapes():void {
			super.shapes();
			var bounds:Rectangle = Util.bounds( this );
			bounds.width *= this.scaleX;
			bounds.height *= this.scaleY;
			WckAwayManager.instance.addCircleSkin( this, bounds );
		}
	}
}
