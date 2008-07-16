package com.plexiglass.containers
{
	import away3d.containers.View3D;
	import away3d.materials.MovieMaterial;
	import away3d.primitives.Plane;
	
	import com.openflux.containers.Container;
	import com.openflux.core.*;
	import com.openflux.utils.MetaStyler;
	import com.plexiglass.animators.PlexiAnimator;
	import com.plexiglass.cameras.ICamera;
	import com.plexiglass.cameras.SimpleCamera;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.ChildExistenceChangedEvent;
	import mx.styles.IStyleClient;
	
	public class PlexiContainer extends Container implements IPlexiContainer
	{
		private var _view:View3D;
		private var viewContainer:UIComponent;
		private var container:UIComponent;
		private var _renderers:Array = new Array();
		private var _camera:ICamera;
		private var planes:Dictionary = new Dictionary(true);
		
		public function PlexiContainer()
		{
			super();
			container = new Canvas();
			container.visible = false;
			_view = new View3D();
		}
		
		//************************************
		// Public Properties
		//************************************
		
		override public function get children():Array { return _renderers; }
		
		public function getChildPlane(child:UIComponent):Plane {
			return planes[child];
		}
		
		public function get view():View3D { return _view; }
		
		[StyleBinding]
		public function get camera():ICamera { return _camera; }
		public function set camera(value:ICamera):void {
			if(_camera) {
				_camera.detach(this);
			}
			_camera = value;
			if(_camera) {
				_camera.attach(this);
				MetaStyler.initialize(_camera, this.data as IStyleClient);
			}
		}
		
		//************************************
		// Framework overides
		//************************************
		
		override protected function createChildren():void {
			if (!animator) {
				animator = new PlexiAnimator();
			}
			super.createChildren();
			viewContainer = new UIComponent();
			rawChildren.addChild(viewContainer);
			rawChildren.addChild(container);
			viewContainer.addChild(view);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			if (!camera) {
				camera = new SimpleCamera();
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (_camera)
				_camera.update(unscaledWidth, unscaledHeight);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {
			var hasWidth:Boolean = child.width > 0;
			var hasHeight:Boolean = child.height > 0;
			
			if (!hasWidth || !hasHeight)
			{
				container.addChild(child);
				var ui:UIComponent = child as UIComponent;
				ui.validateSize(true);
				ui.validateNow();
				if (!hasWidth) ui.width = ui.getExplicitOrMeasuredWidth();
				if (!hasHeight) ui.height = ui.getExplicitOrMeasuredHeight();
				container.removeChild(child);
			}
			
			if (child.width > 0 && child.height > 0) {
				var m:MovieMaterial = new MovieMaterial(child as Sprite, {smooth:true, interactive:true});
				var p:Plane = new Plane({yUp:false, material:m, width:child.width, height:child.height, bothsides:true});
				view.scene.addChild(p);
				planes[child] = p;
			}
			
			children.push(child);
			
			dispatchEvent(new ChildExistenceChangedEvent(ChildExistenceChangedEvent.CHILD_ADD, false, false, child));
			return child;
		}
		
		override public function getChildAt(index:int):DisplayObject {
			return container.getChildAt(index);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			container.removeChild(child);
			view.scene.removeChild(planes[child]);
			delete planes[child];
			return child;
		}
		
		//************************************
		// Event Handlers
		//************************************
		
		private function enterFrameHandler(event:Event):void {
			if (view && view.stage) {
				view.render();
			}
		}
	}
}