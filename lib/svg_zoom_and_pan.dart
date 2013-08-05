library svg_zoom_and_pan;

import 'dart:html';
import 'dart:core';
import 'dart:svg' as svg;
import 'dart:math' as math;

class _Point{
  num x,y;
  _Point(this.x, this.y);
}

class _SvgZoomAndPan {
  final num KEY_ZOOM_STEP = 1.3;
  final svg.SvgSvgElement root;
  final _Point mouse = new _Point(0, 0);
  final _Point offset = new _Point(0, 0); 
  num minScale = 0.25;
  _Point size;
  num scale = 1.0;
  bool mouseDown = false; 
  bool panning = false;

  _SvgZoomAndPan(this.root) {
    svg.Rect viewbox = getViewBox();
    size = new _Point(viewbox.width, viewbox.height);
    minScale = math.min(document.body.clientWidth / viewbox.width, document.body.clientHeight / viewbox.height);
    attach();    
  }
  
  svg.Rect getViewBox() {
    String vb = root.attributes["viewBox"];
    List<String> vals = vb.split(" ");
    svg.Rect rect = root.createSvgRect();
    rect.x = double.parse(vals[0]);
    rect.y = double.parse(vals[1]);
    rect.width = double.parse(vals[2]);
    rect.height = double.parse(vals[3]);
    return rect;
  }
  
  void updateMousePosition(MouseEvent e) {
    mouse.x = e.client.x;
    mouse.y = e.client.y;
    svg.Rect viewbox = getViewBox();
    offset.x = viewbox.x;
    offset.y = viewbox.y;
  }
  
  svg.Point toUsertSpace(num x, num y) {
    svg.Matrix ctm = root.getScreenCtm();
    svg.Point p = root.createSvgPoint();
    p.x = x;
    p.y = y;
    return p.matrixTransform(ctm.inverse());
  }
  
  void attach() {
    root.onMouseDown.listen((MouseEvent e) {
      updateMousePosition(e);
      mouseDown = true;
    });
    root.onMouseUp.listen((e) => mouseDown = false);
    root.onMouseMove.listen((MouseEvent e) {
      if (mouseDown) {
        panning = true;
        num x = mouse.x;
        num y = mouse.y;
        svg.Point start = toUsertSpace(x, y);
        svg.Point pos = toUsertSpace(e.client.x, e.client.y);
        svg.Rect viewBox = getViewBox();
        viewBox.x = offset.x + (start.x - pos.x);
        viewBox.y = offset.y + (start.y - pos.y);
        setViewBox(viewBox);
      } else {
        panning = false;
        updateMousePosition(e);
      }
    });
    root.onClick.listen((e) => panning = false);
    root.onMouseWheel.listen((MouseEvent event) {
      if(event.deltaY > 0) {
        scale /= KEY_ZOOM_STEP;
      } else {
        scale *= KEY_ZOOM_STEP;
      }
      updateZoom();
      event.preventDefault();
    });
    window.onKeyPress.listen((KeyboardEvent e) {
      String c =  new String.fromCharCode(e.charCode);
      switch (c) {
        case ']':
          scale /= KEY_ZOOM_STEP;
          updateZoom();
          break;
        case '[':
          scale *= KEY_ZOOM_STEP;
          updateZoom();
          break;
        case '\\':
          scale = 1;
          updateZoom();
          svg.Rect viewBox = getViewBox();
          viewBox.x = 0;
          viewBox.y = 0;
          setViewBox(viewBox);
          break;
        }
    });
  }
  
  void updateZoom() {
    if (scale < minScale)
      scale = minScale;
    num x = mouse.x;
    num y = mouse.y;
    svg.Point before = toUsertSpace(x, y);
    svg.Rect viewbox = getViewBox();
    viewbox.width = size.x / scale;
    viewbox.height = size.y / scale;
    setViewBox(viewbox);
    svg.Point after = toUsertSpace(x, y);
    num dx = before.x - after.x;
    num dy = before.y - after.y;
    viewbox.x = viewbox.x + dx;
    viewbox.y = viewbox.y + dy;
    setViewBox(viewbox);
  }
  
  void setViewBox(svg.Rect viewBox) {
    root.attributes['viewBox'] = "${viewBox.x} ${viewBox.y} ${viewBox.width} ${viewBox.height}";
  }
}  

void setupZoomAndPan(svg.SvgSvgElement root) {
  new _SvgZoomAndPan(root);
}
