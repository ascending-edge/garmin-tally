/**
 * @author Greg Rowe <greg.rowe@ascending-edge.com>
 *
 * This class handles the drawing of the Tally view.
 * 
 * Copyright (c) 2017, 2018 Ascending Edge, LLC.
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

     const m_VPAD = 10;
     const m_2VPAD = m_VPAD * 2;

     var m_WIDTH = 0;
     var m_HEIGHT = 0;
     var m_HALF_WIDTH = 0;
     var m_HALF_HEIGHT = 0;

     var m_LOGO_X = 0;
     var m_LOGO_Y = 0;

     const m_COUNTER_FONT = Gfx.FONT_SYSTEM_NUMBER_THAI_HOT;
     var m_COUNTER_X = 0;
     var m_COUNTER_Y = 0;

     const m_LABEL_FONT = Gfx.FONT_SYSTEM_LARGE;
     const m_NAME_FONT = m_LABEL_FONT;
     
     var m_INC_X = 0;
     var m_INC_Y = 0;

     var m_DEC_X = 0;
     var m_DEC_Y = 0;

     var m_RES_X = 0;
     var m_RES_Y = 0;
     
     function initialize() 
     {
          System.println("initialize");          
          m_logo = Ui.loadResource(Rez.Drawables.LauncherIcon);
          m_name = Ui.loadResource(Rez.Strings.AppName);
          m_app = App.getApp();
    	
          View.initialize();
     }

     // Resources are loaded here
     function onLayout(dc)
     {
          System.println("onLayout");
          
          m_WIDTH = dc.getWidth();
          m_HEIGHT = dc.getHeight();
          m_HALF_WIDTH = m_WIDTH / 2.0;
          m_HALF_HEIGHT = m_HEIGHT / 2.0;

          m_LOGO_X = m_HALF_WIDTH - (m_logo.getWidth() / 2);
          m_LOGO_Y = m_HEIGHT - m_logo.getHeight() - m_VPAD;

          m_COUNTER_X = m_HALF_WIDTH;
          m_COUNTER_Y = m_HALF_HEIGHT - (dc.getFontHeight(m_COUNTER_FONT) / 2);

          m_INC_X = 0;
          m_INC_Y = m_HALF_HEIGHT;

          m_DEC_X = 17;
          m_DEC_Y = m_HALF_HEIGHT + 50;

          var text = "0";
          var textDim = dc.getTextDimensions(text, m_LABEL_FONT);
          m_RES_X = m_WIDTH - textDim[0];
          m_RES_Y = m_HALF_HEIGHT + 50;
     }     

     /**
      * This draws the screen.
      */
     function onUpdate(dc) 
     {
          System.println("update");

          // clear the screen
          dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
          dc.clear();

          // draw the widget name (Tally)
          dc.drawText(m_HALF_WIDTH, m_2VPAD, m_NAME_FONT,
                      m_name, Gfx.TEXT_JUSTIFY_CENTER);

          // draw the counter
          dc.drawText(m_COUNTER_X, m_COUNTER_Y, m_COUNTER_FONT,
                      m_app.getCount(), Gfx.TEXT_JUSTIFY_CENTER);

		        
		// Draw the legend if in adjustment mode        
          if(m_app.getMode() == m_app.MODE_ADJUST)
          {
               // increment
               dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
               dc.drawText(m_INC_X, m_INC_Y, m_LABEL_FONT, "+",
                           Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
               // reset
               dc.drawText(m_RES_X, m_RES_Y, m_LABEL_FONT, "0", 
                           Gfx.TEXT_JUSTIFY_RIGHT| Gfx.TEXT_JUSTIFY_VCENTER);
        	
               // decrement
               dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_WHITE);                	
               dc.drawText(m_DEC_X, m_DEC_Y, m_LABEL_FONT, "-",
                           Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);


               dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);        	
          }
        
          // AE logo
          dc.drawBitmap(m_LOGO_X, m_LOGO_Y, m_logo);
     }
}
