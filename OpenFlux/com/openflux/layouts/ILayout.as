package com.openflux.layouts
{
	import com.openflux.core.IDataView;
	import com.openflux.layouts.animators.ILayoutAnimator;
	
	import flash.geom.Point;
	//import flash.events.MouseEvent;
	//import mx.events.DragEvent;
	
	public interface ILayout
	{			
		function get animator():ILayoutAnimator;
		function set animator(value:ILayoutAnimator):void;
		
		//IFluxList == FlexibleContainer
		function attach(container:IDataView):void; // , animator:LayoutAnimator
		function detach(container:IDataView):void;
		
		function getMeasuredSize():Point;
		function generateLayout():void;
		function findItemAt(px:Number, py:Number, seamAligned:Boolean):int;
		
		/* // not worrying about dnd right now.
		function dragStart(e:MouseEvent) : Boolean;
		function dragEnter(e:DragEvent) : Boolean;
		function dragOver(e:DragEvent) : Boolean;
		function dragDrop(e:DragEvent) : Boolean;
		function dragComplete(e:DragEvent) : Boolean;
		function dragOut(e:DragEvent) : Boolean;
		*/
	}
}