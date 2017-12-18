/**
 * @author Greg Rowe <greg.rowe@ascending-edge.com>
 *
 * This class handles the drawing of the Tally view.
 * 
 * Copyright (c) 2017 Ascending Edge, LLC.
 */
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;


/** 
 * Draws the Tally widget view
 */
class TallyView extends Ui.View 
{
     /// Ascending Edge Logo
	var m_logo = null;

     /// Application name
	var m_name = null;

     /// Application instance
	var m_app = null;


     function initialize() 
     {
          // cached stuff
          m_logo = Ui.loadResource(Rez.Drawables.LauncherIcon);
          m_name = Ui.loadResource(Rez.Strings.AppName);
          m_app = App.getApp();
    	
          View.initialize();
     }


     /**
      * This draws the screen.
      */
     function onUpdate(dc) 
     {
          System.println("update");
		var vpad = 10;
		var width = dc.getWidth();
		var height = dc.getHeight();
		var xOver2 = width / 2;
		var yOver2 = height / 2;
		var font = null;
		var y = 0;
		var x = 0;
		var textDim = null;
		var text = "";
				
          dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
          dc.clear();

          // draw the widget name
          font = Gfx.FONT_SYSTEM_LARGE;
          //textDim = dc.getTextDimensions(m_name, font);
          dc.drawText(xOver2, vpad * 2, font, m_name, Gfx.TEXT_JUSTIFY_CENTER);

		// draw the counter in a large font		
		font = Gfx.FONT_SYSTEM_NUMBER_THAI_HOT;
		y = yOver2 - (dc.getFontHeight(font) / 2);
          dc.drawText(xOver2, y, font, m_app.getCount(),
                      Gfx.TEXT_JUSTIFY_CENTER);

		        
		// Draw the legend if in adjustment mode        
          if(m_app.getMode() == m_app.MODE_ADJUST)
          {
               // increment
               dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
               font = Gfx.FONT_SYSTEM_LARGE;
               dc.drawText(0, yOver2, font, "+",
                           Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
        	
               // decrement
               dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_WHITE);                	
               dc.drawText(17, yOver2 + 50, font, "-",
                           Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
        	
               // reset
               dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);        	
               text = "0";
               textDim = dc.getTextDimensions(text, font);
               dc.drawText(width - textDim[0], yOver2 + 50, font, text, 
                           Gfx.TEXT_JUSTIFY_RIGHT| Gfx.TEXT_JUSTIFY_VCENTER);
               dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);        	
          }
        
          // AE logo
          dc.drawBitmap(xOver2 - (m_logo.getWidth() / 2), 
                        height - m_logo.getHeight() - vpad, m_logo);        	
     }
}
