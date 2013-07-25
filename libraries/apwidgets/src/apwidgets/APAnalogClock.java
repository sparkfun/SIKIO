/**
 * Copyright 2010 Rikard Lundstedt
 * 
 * This file is part of APWidgets.
 * 
 * APWidgets is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * APWidgets is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with APWidgets. If not, see <http://www.gnu.org/licenses/>.
 */

package apwidgets;

import processing.core.PApplet;
import android.view.ViewGroup;
import android.widget.AnalogClock;
/**
 * An analog clock. Add instances to {@link apwidgets.APWidgetContainer}.
 * 
 * @author Rikard Lundstedt
 *
 */
public class APAnalogClock extends APWidget{
	/** Creates an analog clock.
	 * 
	 * @param x The analog clock's x position.
	 * @param y The analog clock's y position.
	 */
	public APAnalogClock(int x, int y) {
		super(x, y, ViewGroup.LayoutParams.WRAP_CONTENT,
				ViewGroup.LayoutParams.WRAP_CONTENT);
	}
	/**
	 * Creates an analog clock.
	 * 
	 * @param x The analog clock's x position in pixels.
	 * @param y The analog clock's y position in pixels.
	 * @param size The analog clocks size in pixels.
	 */
	public APAnalogClock(int x, int y, int size) {
		super(x, y, size, size);
	}
	/**
	 * Initializes the analog clock. Is called by {@link APWidgetContainer} 
	 * as it is added to it.
	 * 
	 */
	public void init(PApplet pApplet) {
		this.pApplet = pApplet;

		if (view == null) {
			view = new AnalogClock(pApplet);
		}
		super.init(pApplet);
	}
}
	


