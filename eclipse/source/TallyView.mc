/**
 * @author Greg Rowe <greg.rowe@ascending-edge.com>
 *
 * Copyright (c) 2017, 2018 Ascending Edge, LLC.
 */
using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application;


/** 
 * Draws the Tally widget view
 */
class TallyView extends WatchUi.View
{
     const LABEL_FONT = Graphics.FONT_SYSTEM_MEDIUM;
     
     /// Ascending Edge Logo
	var m_logo = null;

     /// An array to hold two bitmaps for labeling the start/stop
     /// button
     var m_menu = null;

     /// This is the label for the widget name, Tally
	var m_labelApp = null;

     /// This is the counter value.
     var m_labelCounter = null;

     // These are the widgets that make up the legend
     var m_labelInc = null;
     var m_labelDec = null;
     var m_labelReset = null;

     /// This is for convenience to avoid calling getApp() over and
     /// over
     var m_app = null;

     
     function initialize() 
     {
          System.println("initialize");
          m_app = Application.getApp();

          // Logo
          m_logo = new WatchUi.Bitmap({
                    :rezId => Rez.Drawables.LauncherIcon,
                         :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                         :locY => WatchUi.LAYOUT_VALIGN_BOTTOM,
                         });

          // Menu
          m_menu = new [m_app.MODE_END_MARKER];
          m_menu[m_app.MODE_VIEW] =
               new WatchUi.Bitmap({:rezId => Rez.Drawables.Menu});
          m_menu[m_app.MODE_ADJUST] =
               new WatchUi.Bitmap({:rezId => Rez.Drawables.Back});

          // Application name
          var name = WatchUi.loadResource(Rez.Strings.AppName);
          m_labelApp = new WatchUi.Text({
                    :text => name,
                         :color => Graphics.COLOR_BLACK,
                         :font => Graphics.FONT_SYSTEM_LARGE,
                         :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                         :locY => 10});
          // Counter
          m_labelCounter = new WatchUi.Text({
                    :color => Graphics.COLOR_BLACK,
                         :font => Graphics.FONT_SYSTEM_NUMBER_THAI_HOT,
                         :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                         :locY => WatchUi.LAYOUT_VALIGN_CENTER});

          // Increment label
          m_labelInc = new WatchUi.Text({
                    :text => "+",
                         :color => Graphics.COLOR_BLACK,
                         :font => LABEL_FONT,
                         :justification =>
                         Graphics.TEXT_JUSTIFY_LEFT
                         | Graphics.TEXT_JUSTIFY_VCENTER});
          // Decrement label
          m_labelDec = new WatchUi.Text({
                    :text => "-",
                         :color => Graphics.COLOR_RED,
                         :font => LABEL_FONT,
                         :justification =>
                         Graphics.TEXT_JUSTIFY_LEFT
                         | Graphics.TEXT_JUSTIFY_VCENTER});
          // Reset label
          m_labelReset = new WatchUi.Text({
                    :text => "0",
                         :color => Graphics.COLOR_BLACK,
                         :font => LABEL_FONT,
                         :justification =>
                         Graphics.TEXT_JUSTIFY_RIGHT
                         | Graphics.TEXT_JUSTIFY_VCENTER});
          
          View.initialize();
     }


     /**
      * This finds the coordinates of a point on the circumference of
      * a circle.  This is used here to find the correct location of
      * the legend labels.
      *
      * @param angle which point on the circle (0 is 3 o'clock and it
      * goes clockwise thus 6 o'clock is 900).
      *
      * @param x x position of center of circle
      *
      * @param y y position of center of circle
      *
      * @param radius the size of the circle
      *
      * @return an array of 2 points: x,y representing the position on
      * the circle
      * 
      */
     function circleXY(angle, x, y, radius)
     {
          // x = center_x + radius * cos(angle)
          // y = center_y + radius * sin(angle)
          var coord = new[2];
          var angle_radians = angle * Math.PI / 180;
          coord[0] = x + radius * Math.cos(angle_radians);
          coord[1] = y + radius * Math.sin(angle_radians);
          return coord;
     }


     /**
      * This is called when the layout may need to be recomputed.  All
      * placement calculations are done here.
      */
     function onLayout(dc)
     {
          System.println("onLayout");
          
          var width = dc.getWidth();
          var height = dc.getHeight();
          var halfWidth = width / 2;
          var halfHeight = height / 2;

          // visual padding
          var pad = 5;
          
          var xy = circleXY(180, halfWidth, halfHeight, halfWidth);
          m_labelInc.setLocation(xy[0] + pad, xy[1]);

          xy = circleXY(150, halfWidth, halfHeight, halfWidth);
          m_labelDec.setLocation(xy[0] + pad, xy[1]);

          xy = circleXY(30, halfWidth, halfHeight, halfWidth);
          m_labelReset.setLocation(xy[0] - pad, xy[1]);

          xy = circleXY(330, halfWidth, halfHeight, halfWidth);
          for(var i=0; i<m_app.MODE_END_MARKER; ++i)
          {
               var bm = m_menu[i];
               bm.setLocation(xy[0] - bm.width, xy[1]);
          }
     }


     /**
      * Draws the labels that mark the buttons.  This varies based on
      * mode.
      */
     function drawLegend(dc)
     {
          var mode = m_app.getMode();
          if(mode == m_app.MODE_ADJUST)
          {
               m_labelInc.draw(dc);
               m_labelDec.draw(dc);
               m_labelReset.draw(dc);
          }
          m_menu[mode].draw(dc);
     }

     
     /**
      * This draws the screen.
      */
     function onUpdate(dc) 
     {
          //System.println("update");
          m_labelCounter.setText(m_app.getCount().format("%d"));
          
          // clear the screen
          dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
          dc.clear();

          m_labelApp.draw(dc);
          m_labelCounter.draw(dc);
		        
          drawLegend(dc);
          m_logo.draw(dc);
     }
}
