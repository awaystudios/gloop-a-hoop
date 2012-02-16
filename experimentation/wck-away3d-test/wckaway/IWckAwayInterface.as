/**
 * Created by Li using JetBrains Astella.
 * Date: 2/15/12
 */
package wckaway
{

	import flash.geom.Rectangle;

	import shapes.ShapeBase;

	public interface IWckAwayInterface
	{
		function addBoxSkin( body:ShapeBase, bounds:Rectangle ):void
		function addCircleSkin( body:ShapeBase, bounds:Rectangle ):void
	}
}
