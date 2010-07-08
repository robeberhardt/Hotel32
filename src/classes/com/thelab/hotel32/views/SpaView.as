package com.thelab.hotel32.views
{
	import com.greensock.loading.display.ContentDisplay;
	import com.thelab.hotel32.assets.AssetLoader;
	import com.thelab.hotel32.assets.fonts.FontLibrary;
	import com.thelab.hotel32.common.PageButton;
	import com.thelab.hotel32.common.SimpleBackgroundLoader;
	import com.thelab.hotel32.common.TabPanel;
	import com.thelab.hotel32.helpers.BasicTextField;
	
	import flash.display.Bitmap;
	import flash.events.Event;

	public class SpaView extends BasicView
	{
		
		private var tabPanel								: TabPanel;
		private var bgLoader								: SimpleBackgroundLoader;
		
		public function SpaView(name:String=null)
		{
			super(name);
		}
		
		override public function setup():void
		{
			assetsLoaded.addOnce(onAssetsLoaded);
			loadAssets();
		}
		
		private function onAssetsLoaded():void
		{
			
			tabPanel = new TabPanel("spaTabPanel", pageXML);
			addChild(tabPanel);
			
			tabPanel.paginatorReady.addOnce( function()
			{
				tabPanel.paginator.selectedSender.add(onPageSelected);
				tabPanel.selectByIndex(0);
				tabPanel.show();
			});
			
			
			tabPanel.visible = false;
						
			bgLoader = new SimpleBackgroundLoader(pageXML);
			addChildAt(bgLoader, 0);
			bgLoader.transitionMiddle.add( function() { tabPanel.refreshContent(); } );
			bgLoader.show();
			
			sendReady();
		}
		
		private function onPageSelected(which:PageButton):void
		{
			var selectedTabName:String = TabPanel(which.parent.parent).selectedTab.name;
			var theURL:String = pageXML..tab.(@id == selectedTabName).images.image[which.index-1].@id.toString();
			bgLoader.load(theURL);
			
		}
	}
}