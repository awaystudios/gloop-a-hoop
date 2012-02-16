package wckaway
{

	import flash.geom.Rectangle;

	import misc.Util;

	import shapes.Box;

	public class Box3D extends Box
	{
		public override function shapes():void {
			super.shapes();
			var bounds:Rectangle = Util.bounds( this );
			bounds.width *= this.scaleX;
			bounds.height *= this.scaleY;
			WckAwayManager.instance.addBoxSkin( this, bounds );
		}
	}
}
