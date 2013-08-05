Mouse zoom and pan support for SVG.

*Usage:*

	<html>
	  <body>
	    <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="454.5625" style="border: solid 1px red"
	      height="441.40625" viewBox="0 0 450 450" id="svgroot">
	      <g id="layer1">
	        <rect width="96.974648" height="46.467018" x="131.31982" y="88.676651"
	          style="fill:#02f530;fill-opacity:1;stroke:#000000;stroke-width:1;stroke-linecap:square;stroke-linejoin:miter;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none;stroke-dashoffset:0" />
	        <rect width="72.73098" height="51.51778" x="28.284271" y="63.42284"
	          style="fill:#02f530;fill-opacity:1;fill-rule:nonzero;stroke:#000000;stroke-width:1;stroke-linecap:square;stroke-linejoin:miter;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none;stroke-dashoffset:0" />
	      </g>
	    </svg>
	    <script type="application/dart">
	      import 'dart:html';
	      import 'package:svg_zoom_and_pan/svg_zoom_and_pan.dart' as zoomAndPan;
	      
	      void main() {
	        var svg = query("svg");
	        zoomAndPan.setupZoomAndPan(svg);
	      }
	    </script>
	    <script src="packages/browser/dart.js"></script>
	  </body>
	</html>


