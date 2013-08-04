import 'dart:html';
import 'dart:svg' as s;
import 'dart:math' as math;

class VisualCoords{
  num x,y;
  VisualCoords(this.x, this.y);
}

final num KEY_ZOOM_STEP = 1.3;
num minScale = 0.25;
VisualCoords size;
final VisualCoords mouse = new VisualCoords(0, 0);
final VisualCoords offset = new VisualCoords(0, 0); 
s.SvgSvgElement svg;
num scale = 1.0;
bool mouseDown = false;
bool panning = false;

s.Rect getViewBox(s.SvgSvgElement svg) {
  String vb = svg.attributes["viewBox"];
  List<String> vals = vb.split(" ");
  s.Rect rect = svg.createSvgRect();
  rect.x = double.parse(vals[0]);
  rect.y = double.parse(vals[1]);
  rect.width = double.parse(vals[2]);
  rect.height = double.parse(vals[3]);
  return rect;
}

void updateMousePosition(MouseEvent e) {
  mouse.x = e.client.x;
  mouse.y = e.client.y;
  s.Rect viewbox = getViewBox(svg);
  offset.x = viewbox.x;
  offset.y = viewbox.y;
}

s.Point toUsertSpace(num x, num y) {
  s.Matrix ctm = svg.getScreenCtm();
  s.Point p = svg.createSvgPoint();
  p.x = x;
  p.y = y;
  return p.matrixTransform(ctm.inverse());
}

void attach(Element svg) {
  svg.onMouseDown.listen((MouseEvent e) {
    updateMousePosition(e);
    mouseDown = true;
  });
  svg.onMouseUp.listen((e) => mouseDown = false);
  svg.onMouseMove.listen((MouseEvent e) {
    if (mouseDown) {
      panning = true;
      num x = mouse.x;
      num y = mouse.y;
      s.Point start = toUsertSpace(x, y);
      s.Point pos = toUsertSpace(e.client.x, e.client.y);
      s.Rect viewBox = getViewBox(svg);
      viewBox.x = offset.x + (start.x - pos.x);
      viewBox.y = offset.y + (start.y - pos.y);
      setViewBox(svg, viewBox);
    } else {
      panning = false;
      updateMousePosition(e);
    }
  });
}

setViewBox(Element svg, s.Rect viewBox) {
  svg.attributes['viewBox'] = "${viewBox.x} ${viewBox.y} ${viewBox.width} ${viewBox.height}";
}


void main() {
  svg = query("svg");
  s.Rect viewbox = getViewBox(svg);
  size = new VisualCoords(viewbox.width, viewbox.height);
  minScale = math.min(document.body.clientWidth / viewbox.width, document.body.clientHeight / viewbox.height);
  attach(svg);
}
